import 'dart:io';

import 'package:amap_base/amap_base.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_qiniu/flutter_qiniu.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/image_upload.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/qiniu_token_vo.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class ShareShopPageBloc extends BlocBase {
  static const String QI_NIU_URI = 'http://qncdn.gdsdec.com/';
  bool isEnd = false;
  int _pageNumber = 0, _pageSize = 10;
  String _photo;

  // 我的共享店
  MyStorePageVo _myStorePageVo;
  BehaviorSubject<MyStorePageVo> _myStorePageVoController = BehaviorSubject<MyStorePageVo>();
  Sink<MyStorePageVo> get _myStorePageVoSink => _myStorePageVoController.sink;
  Stream<MyStorePageVo> get myStorePageVoStream => _myStorePageVoController.stream;

  BehaviorSubject<String> _shorePhotoController = BehaviorSubject<String>();
  Sink<String> get _shorePhotoSink => _shorePhotoController.sink;
  Stream<String> get shorePhotoStream => _shorePhotoController.stream;

  // 我的共享点列表
  getMyStorePage(BuildContext context) async {
    await getToken().then((token) async {
      print(token);
      _pageNumber = 0;
      var formData = {
        'pageNumber': _pageNumber,
        'pageSize': _pageSize
      };
      await requestPost('getMyStorePage', formData: formData, context: context, token: token).then((val) {
        MyStorePageVo temp = MyStorePageVo.fromJson(val);
        _myStorePageVo = temp;
        setIsEnd(temp.data.totalPage);
        _myStorePageVoSink.add(_myStorePageVo);
      });
    });
  }

  // 我的共享店列表加载更多
  getMyStorePageLoadMore(BuildContext context) async {
    if (!isEnd) {
      await getToken().then((token) async {
        _pageNumber++;
        var formData = {
          'pageNumber': _pageNumber,
          'pageSize': _pageSize
        };
        await requestPost('getMyStorePage', formData: formData, context: context, token: token).then((val) {
          MyStorePageVo temp = MyStorePageVo.fromJson(val);
          _myStorePageVo.data.list.addAll(temp.data.list);
          setIsEnd(temp.data.totalPage);
          _myStorePageVoSink.add(_myStorePageVo);
        });
      });
    }
  }

  // 我们共享店列表是否到底
  setIsEnd(int totalPage) {
    if (totalPage == _pageNumber + 1) {
      isEnd = true;
    } else {
      isEnd = false;
    }
  }

  // 获取相册文件并上传
  getShorePhoto() async {
    await ImageUpload().uploadImage().then((val) {
      if (!TextUtil.isEmpty(val)) {
        _shorePhotoSink.add(val);
      }
    });
  }

  // 初始化定位
  final _amapLocation = AMapLocation();
  initAMapLocation() {
    _amapLocation.init();
  }

  //  获取定位
  getLocation(TextEditingController controller, TextEditingController controller1) async {
    final options = LocationClientOptions(
                      isOnceLocation: true,
                      locatingWithReGeocode: true
                    );
      if (await Permissions().requestPermission()) {
        var location = _amapLocation.getLocation(options);
        location.then((val) {
          Location location = val;
          String region = '${location.province}${location.city}${location.district}';
          String address = location.address.substring(region.length);
          controller.text = region;
          controller1.text = address;
        });
      } else {
        showToast('权限不足');
      }
  }
  
  // 获取七牛云上传token
  Future getQiNiuToken() async {
    return await requestPost('getQiNiuToken');
  }


  @override
  void dispose() {
    _myStorePageVoController.close();
    _shorePhotoController.close();
  }
}