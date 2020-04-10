import 'package:flutter/widgets.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';
import 'package:rxdart/rxdart.dart';

class PersonFollowPageBloc extends BlocBase {

  List<ShopData> _shopDatas;
  BehaviorSubject<List<ShopData>> _shopDataController = BehaviorSubject<List<ShopData>>();
  Sink<List<ShopData>> get _shopDataSink => _shopDataController.sink;
  Stream<List<ShopData>> get shopDataStream => _shopDataController.stream;

  BehaviorSubject<bool> _isEndController = BehaviorSubject<bool>();
  Sink<bool> get _isEndSink => _isEndController.sink;
  Stream<bool> get isEndStream => _isEndController.stream;

  int _pageNumber = 0;
  int _pageSize = 10;
  bool _isEnd = false;
  MyStorePageVo _myStorePageVo;
  getMyFollowPage(BuildContext context) {
    getToken().then((token) {
      var formData = {
        'pageNumber': 0,
        'pageSize': _pageSize
      };
      requestPost('getMyFollowPage', formData: formData, context: context, token: token).then((val) {
          _myStorePageVo = MyStorePageVo.fromJson(val);
          setIsEnd(_myStorePageVo.data.totalPage);
          List<ShopData> tempShopDataList = [];
          _myStorePageVo.data.list.forEach((item) {
            ShopData tempShopData = ShopData(
              likeVolume: item.likeVolume,
              address: item.address,
              lng: item.lng,
              storeName: item.storeName,
              photo: item.photo,
              id: item.id,
              lat: item.lat,
              starCode: item.starCode,
              status: item.status,
              type: item.type,
              brief: item.brief
            );
            tempShopDataList.add(tempShopData);
          });
          _shopDatas = tempShopDataList;
          _shopDataSink.add(_shopDatas);
      });
    });
  }

  loadMoreMyFollowPage(BuildContext context) {
    if (!_isEnd) {
      getToken().then((token) {
        _pageNumber++;
        var formData = {
          'pageNumber': _pageNumber,
          'pageSize': _pageSize
        };
        requestPost('getMyFollowPage', formData: formData, context: context, token: token).then((val) {
            _myStorePageVo = MyStorePageVo.fromJson(val);
            setIsEnd(_myStorePageVo.data.totalPage);
            List<ShopData> tempShopDataList = [];
            _myStorePageVo.data.list.forEach((item) {
              ShopData tempShopData = ShopData(
                likeVolume: item.likeVolume,
                address: item.address,
                lng: item.lng,
                storeName: item.storeName,
                photo: item.photo,
                id: item.id,
                lat: item.lat,
                starCode: item.starCode,
                status: item.status,
                type: item.type,
                brief: item.brief
              );
              tempShopDataList.add(tempShopData);
            });
            _shopDatas.addAll(tempShopDataList);
            _shopDataSink.add(_shopDatas);
        });
      });
    }
  }

  setIsEnd(int totalPage) {
    if (totalPage == _pageNumber + 1) {
      _isEndSink.add(true);
      _isEnd = true;
    } else {
      _isEndSink.add(false);
      _isEnd = false;
    }
  }

  @override
  void dispose() {
    _shopDataController.close();
    _isEndController.close();
  }
}