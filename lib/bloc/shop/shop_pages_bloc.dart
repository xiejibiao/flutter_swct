import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/shop/commodity_page_by_commodity_type_vo.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';
import 'package:rxdart/subjects.dart';

class ShopPagesBloc extends BlocBase {

  int _leftIndex = 0;
  BehaviorSubject<int> _leftIndexController = BehaviorSubject<int>();
  Sink<int> get _leftIndexSink => _leftIndexController.sink;
  Stream<int> get leftIndexStream => _leftIndexController.stream;

  // 门店分类、详情，是否关注
  List<CommodityTypeList> commodityTypeList;
  BehaviorSubject<ShopTypeAndEssentialMessageVo> _shopTypeAndEssentialMessageVoController = BehaviorSubject<ShopTypeAndEssentialMessageVo>();
  Sink<ShopTypeAndEssentialMessageVo> get _shopTypeAndEssentialMessageVoSink => _shopTypeAndEssentialMessageVoController.sink;
  Stream<ShopTypeAndEssentialMessageVo> get shopTypeAndEssentialMessageVoStream => _shopTypeAndEssentialMessageVoController.stream;

  // 获取门店商品列表
  int commodityTypeId;
  int pageNumber = 0;
  int pageSize = 10;
  CommodityPageByCommodityTypeVo commodityPageByCommodityTypeVo;
  BehaviorSubject<CommodityPageByCommodityTypeVo> _commodityPageByCommodityTypeVoController = BehaviorSubject<CommodityPageByCommodityTypeVo>();
  Sink<CommodityPageByCommodityTypeVo> get _commodityPageByCommodityTypeVoControllerSink => _commodityPageByCommodityTypeVoController.sink;
  Stream<CommodityPageByCommodityTypeVo> get commodityPageByCommodityTypeVoControllerStream => _commodityPageByCommodityTypeVoController.stream;

  // 是否加载全部
  BehaviorSubject<bool> _isTheEndController = BehaviorSubject<bool>();
  Sink<bool> get _isTheEndSink => _isTheEndController.sink;
  Stream<bool> get isTheEndStream => _isTheEndController.stream;

  // 左侧分类是否被选中
  thisIndexIsSelected(int index) {
    if (_leftIndex == index) {
      return true;
    } else {
      return false;
    }
  }

  // 修改左侧分类的当前下标
  setLeftIndex(int index) {
    if (_leftIndex != index) {
      _leftIndex = index;
      commodityTypeId = commodityTypeList[index].id;
      getCommodityPageByCommodityTypeId();
      _leftIndexSink.add(index);
    }
  }

  // 获取门店分类，详情，是否关注
  getShopTypeAndEssentialMessage(BuildContext context, int id) {
    getToken().then((token) async {
      print(token);
      var formData = {
        'id': id
      };
      await requestPost('getShopTypeAndEssentialMessage', formData: formData, token: token, context: context).then((data) async {
        ShopTypeAndEssentialMessageVo shopTypeAndEssentialMessageVo = ShopTypeAndEssentialMessageVo.fromJson(data);
        commodityTypeList = shopTypeAndEssentialMessageVo.data.commodityTypeList;
        if (shopTypeAndEssentialMessageVo.data.commodityTypeList.length > 0) {
          commodityTypeId = shopTypeAndEssentialMessageVo.data.commodityTypeList[0].id;
          await getCommodityPageByCommodityTypeId();
        }
        _shopTypeAndEssentialMessageVoSink.add(shopTypeAndEssentialMessageVo);
      });
    });
  }

  // 获取门店商品列表
  getCommodityPageByCommodityTypeId() async {
    _isTheEndSink.add(false);
    pageNumber = 0;
    var formData = {
      'commodityTypeId': commodityTypeId,
      'pageNumber': pageNumber,
      'pageSize': pageSize
    };
    await requestPost('getCommodityPageByCommodityTypeId', formData: formData).then((data) {
      this.commodityPageByCommodityTypeVo = CommodityPageByCommodityTypeVo.fromJson(data);
      setIsTheEnd(commodityPageByCommodityTypeVo.data.totalPage);
      _commodityPageByCommodityTypeVoControllerSink.add(this.commodityPageByCommodityTypeVo);
    });
  }

  loadMoreCommodityPageByCommodityTypeId() async {
    if ((pageNumber + 1) < commodityPageByCommodityTypeVo.data.totalPage) {
      pageNumber++;
      var formData = {
        'commodityTypeId': commodityTypeId,
        'pageNumber': pageNumber,
        'pageSize': pageSize
      };
      await requestPost('getCommodityPageByCommodityTypeId', formData: formData).then((data) {
        CommodityPageByCommodityTypeVo tempCommodityPageByCommodityTypeVo = CommodityPageByCommodityTypeVo.fromJson(data);
        this.commodityPageByCommodityTypeVo.data.list.addAll(tempCommodityPageByCommodityTypeVo.data.list);
        setIsTheEnd(commodityPageByCommodityTypeVo.data.totalPage);
        _commodityPageByCommodityTypeVoControllerSink.add(commodityPageByCommodityTypeVo);
      });
    }
  }

  // 是否加载全部
  setIsTheEnd(int totalPage) {
    if ((pageNumber + 1) == totalPage) {
      _isTheEndSink.add(true);
    }
  }

  @override
  void dispose() {
    _leftIndexController.close();
    _shopTypeAndEssentialMessageVoController.close();
    _commodityPageByCommodityTypeVoController.close();
    _isTheEndController.close();
  }
}