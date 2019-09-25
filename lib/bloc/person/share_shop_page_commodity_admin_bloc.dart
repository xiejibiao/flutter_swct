import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/commodity_detail_util.dart';
import 'package:flutter_swcy/common/image_upload.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_commodity_detail_edit.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quill_delta/quill_delta.dart';

class ShareShopPageCommodityAdminBloc extends BlocBase {
  List<dynamic> items = [];
  BehaviorSubject<List<dynamic>> _itemsController = BehaviorSubject<List<dynamic>>();
  Sink<List<dynamic>> get _itemsSink => _itemsController.sink;
  Stream<List<dynamic>> get itemsStream => _itemsController.stream;

  /// 获取解析详情
  getItems(String detail) {
    items = TextUtil.isEmpty(detail) ? [] : json.decode(detail);
    _itemsSink.add(items);
  }

  /// 修改商品详情
  editCommodityDetail(BuildContext context, String detail, int id, ShopPagesBloc shopPagesBloc) {
    var formData = {
      'detail': detail,
      'id': id
    };
    requestPost('editCommodityDetail', formData: formData).then((val) {
      CommenVo commenVo = CommenVo.fromJson(val);
      if(commenVo.code == '200') {
        showToast('编辑成功');
        shopPagesBloc.resetCommodityDetail(detail, id);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        showToast(commenVo.message);
      }
    });
  }

  /// 修改分享店详情
  editStoreDescription(BuildContext context, String detail, int id, ShareShopPageBloc shareShopPageBloc) {
    var formData = {
      'description': detail,
      'id': id
    };
    requestPost('editStoreDescription', formData: formData).then((val) {
      CommenVo commenVo = CommenVo.fromJson(val);
      if (commenVo.code == '200') {
        showToast('修改成功');
        shareShopPageBloc.resetStoreDescription(detail, id);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        showToast(commenVo.message);
      }
    });
  }

  /// 修改一个模块 item 要修改的模块， data 新的数据， items 总数据
  _resetItems(dynamic item, Map data) {
    items.insert((items.indexOf(item)), data);
    items.removeAt((items.indexOf(item)));
    String temp = json.encode(items);
    items = TextUtil.isEmpty(temp) ? [] : json.decode(temp);
    _itemsSink.add(items);
  }

  /// 删除一个模块 item 要删除的模块
  removeItem(dynamic item) {
    items.removeAt((items.indexOf(item)));
    String temp = json.encode(items);
    items = TextUtil.isEmpty(temp) ? [] : json.decode(temp);
    _itemsSink.add(items);
  }

  /// 修改图片模块 item 要修改的模块
  uploadImages(item) {
    ImageUpload().uploadImages(maxImages: 9, selectionLimitReachedText: '只允许选择9张图片').then((urlList) {
      if (urlList.length != 0) {
        Map data = {
          'type': 'image',
          'content': urlList
        };
        _resetItems(item, data);
      }                              
    });
  }

  /// 新增图片模块
  addUploadImages(BuildContext context) {
    ImageUpload().uploadImages(maxImages: 9, selectionLimitReachedText: '只允许选择9张图片').then((urlList) {
      if (urlList.length != 0) {
        Map data = {
          'type': 'image',
          'content': urlList
        };
        items.add(data);
        String temp = json.encode(items);
        items = TextUtil.isEmpty(temp) ? [] : json.decode(temp);
        _itemsSink.add(items);
      }       
      Navigator.pop(context);                       
    });
  }

  /// 修改文字模块
  editTextItem(content, BuildContext context, item) {
    Delta delta = getDelta(content);
    Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShareShopPageCommodityAdminBloc(), child: ShareShopPageCommodityDetailEdit(deltaDetail: delta)))).then((val) {
      if (val != null) {
        Map data = {
          'type': 'text',
          'content': val
        };
        _resetItems(item, data);
      }
    });
  }

  /// 新增文字模块
  addTextItem(BuildContext context) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShareShopPageCommodityAdminBloc(), child: ShareShopPageCommodityDetailEdit()))).then((val) {
      if(val != null) {
        Map data = {
          'type': 'text',
          'content': val
        };
        items.add(data);
        String temp = json.encode(items);
        items = TextUtil.isEmpty(temp) ? [] : json.decode(temp);
        _itemsSink.add(items);
      }
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _itemsController.close();
  }
}