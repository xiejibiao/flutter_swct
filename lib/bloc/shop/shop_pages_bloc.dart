import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_page_by_commodity_type_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_shopingcar_vo.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Sink<CommodityPageByCommodityTypeVo> get _commodityPageByCommodityTypeVoSink => _commodityPageByCommodityTypeVoController.sink;
  Stream<CommodityPageByCommodityTypeVo> get commodityPageByCommodityTypeVoStream => _commodityPageByCommodityTypeVoController.stream;

  // 是否加载全部
  BehaviorSubject<bool> _isTheEndController = BehaviorSubject<bool>();
  Sink<bool> get _isTheEndSink => _isTheEndController.sink;
  Stream<bool> get isTheEndStream => _isTheEndController.stream;

  // 关注，取消关注
  bool _isFollow = false;
  BehaviorSubject<bool> _isFollowController = BehaviorSubject<bool>();
  Sink<bool> get _isFollowSink => _isFollowController.sink;
  Stream<bool> get isFollowStream => _isFollowController.stream;

  // 持久化保存购物车商品
  String commodityString = '[]';
  // 进入商家时，必须初始化此值
  String commodityKey = 'COMMODITY_INFO';
  BehaviorSubject<List<CommodityInfoVo>> _commodityInfoVoListController = BehaviorSubject<List<CommodityInfoVo>>();
  Sink<List<CommodityInfoVo>> get _commodityInfoVoListSink => _commodityInfoVoListController.sink;
  Stream<List<CommodityInfoVo>> get commodityInfoVoListStream => _commodityInfoVoListController.stream;
  // 持久化购物车商品价格
  BehaviorSubject<double> _allPriceController = BehaviorSubject<double>();
  Sink<double> get _allPriceSink => _allPriceController.sink;
  Stream<double> get allPriceStream => _allPriceController.stream;
  // 持久化购物车数量
  BehaviorSubject<int> _allCommodityCountController = BehaviorSubject<int>();
  Sink<int> get _allCommodityCountSink => _allCommodityCountController.sink;
  Stream<int> get allCommodityCountStream => _allCommodityCountController.stream;
  // 是否全选
  BehaviorSubject<bool> _isAllCheckController = BehaviorSubject<bool>();
  Sink<bool> get _isAllCheckSink => _isAllCheckController.sink;
  Stream<bool> get isAllCheckStream => _isAllCheckController.stream;

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
      var formData = {
        'id': id
      };
      await requestPost('getShopTypeAndEssentialMessage', formData: formData, token: token, context: context).then((data) async {
        ShopTypeAndEssentialMessageVo shopTypeAndEssentialMessageVo = ShopTypeAndEssentialMessageVo.fromJson(data);
        commodityTypeList = shopTypeAndEssentialMessageVo.data.commodityTypeList;
        if (shopTypeAndEssentialMessageVo.data.commodityTypeList.length > 0) {
          commodityTypeId = shopTypeAndEssentialMessageVo.data.commodityTypeList[0].id;
          _isFollow = shopTypeAndEssentialMessageVo.data.follow;
          _isFollowSink.add(_isFollow);
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
      _commodityPageByCommodityTypeVoSink.add(this.commodityPageByCommodityTypeVo);
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
        _commodityPageByCommodityTypeVoSink.add(commodityPageByCommodityTypeVo);
      });
    }
  }

  // 是否加载全部
  setIsTheEnd(int totalPage) {
    if ((pageNumber + 1) == totalPage) {
      _isTheEndSink.add(true);
    }
  }

  // 收藏
  followAndCleanFollow(int id, BuildContext context) {
    getToken().then((token) {
      var formData = {
        'id': id
      };
      requestPost('followAndCleanFollow', token: token, formData: formData, context: context).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        showToast(commenVo.message);
        _isFollow = !_isFollow;
        _isFollowSink.add(_isFollow);
      });
    });
  }

  // 进入商家时，必须初始化此值
  setCommodityKey(int shopId) {
    commodityKey = '${commodityKey}_$shopId';
  }

  // 保存商品, 主键，商品名称，数量，价格，图片
  saveCommodity(id, name, count, price, cover) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    commodityString = sharedPreferences.getString(commodityKey);
    var temp = commodityString == null ? [] : json.decode(commodityString);
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int ival = 0;
    _allPriceSink.add(0);
    _allCommodityCountSink.add(0);
    tempList.forEach((item) {
      if (item['id'] == id) {
        tempList[ival]['count']++;
        isHave = true;
      }
      if(item['isCheck']) {
        _allPriceSink.add(tempList[ival]['price'] * tempList[ival]['count']);
        _allCommodityCountSink.add(tempList[ival]['count']);
      }
      ival++;
    });

    if (!isHave) {
      Map<String, dynamic> newCommodity = {
        'id': id,
        'name': name,
        'count': count,
        'price': price,
        'cover': cover,
        'isCheck': true        
      };
      tempList.add(newCommodity);
      // _allPriceSink.add(count * price);
      // _allCommodityCountSink.add(count);
    }
    commodityString = json.encode(tempList).toString();
    sharedPreferences.setString(commodityKey, commodityString);
    showToast('加入购物车成功');
    await getCommodityList();
  }

  // 购物车全部清空
  removeCommodity() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(commodityKey);
    print('清空完成');
  }

  // 获取购物车商品列表
  getCommodityList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    commodityString = sharedPreferences.getString(commodityKey);
    List<CommodityInfoVo> commodityInfoVoList = [];
    double tempAllPrice = 0;
      int tempAllCommodityCount = 0;
    if (commodityString != null) {
      List<Map> tempList = (json.decode(commodityString.toString()) as List).cast();
      _isAllCheckSink.add(true);
      tempList.forEach((item) {
        if (item['isCheck']) {
          tempAllPrice += (item['count'] * item['price']);
          tempAllCommodityCount += item['count'];
        } else {
          _isAllCheckSink.add(false);
        }
        commodityInfoVoList.add(CommodityInfoVo.fromJson(item));
      });
    }
    _allPriceSink.add(tempAllPrice);
    _allCommodityCountSink.add(tempAllCommodityCount);
    _commodityInfoVoListSink.add(commodityInfoVoList);
  }

  // 删除单个购物车商品
  deleteOneCommodity(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    commodityString = sharedPreferences.getString(commodityKey);
    List<Map> tempList = (json.decode(commodityString.toString()) as List).cast();
    int tempIndex = 0;
    int delIndex = 0;

    tempList.forEach((item) {
      if (item['id'] == id) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    commodityString = json.encode(tempList).toString();
    sharedPreferences.setString(commodityKey, commodityString);
    await getCommodityList();
  }

  // 修改单个商品的选中状态
  changeCheckState(CommodityInfoVo commodityInfoVo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    commodityString = sharedPreferences.getString(commodityKey);
    List<Map> tempList = (json.decode(commodityString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['id'] == commodityInfoVo.id) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = commodityInfoVo.toJson();
    commodityString = json.encode(tempList).toString();
    sharedPreferences.setString(commodityKey, commodityString);
    await getCommodityList();
  }

  // 点击全选按钮操作
  changeAllCheckBtnState(bool isCheck) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    commodityString = sharedPreferences.getString(commodityKey);
    List<Map> tempList = (json.decode(commodityString.toString()) as List).cast();
    List<Map> newList = [];
    tempList.forEach((item) {
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    });
    commodityString = json.encode(newList).toString();
    sharedPreferences.setString(commodityKey, commodityString);
    await getCommodityList();
  }

  // 添加或减少数量
  addOrReduceAction(CommodityInfoVo commodityInfoVo, String todo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    commodityString = sharedPreferences.getString(commodityKey);
    List<Map> tempList = (json.decode(commodityString.toString()) as List).cast();
    int temeIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if(item['id'] == commodityInfoVo.id) {
        changeIndex = temeIndex;
      }
      temeIndex++;
    });
    if (todo == 'add') {
      commodityInfoVo.count++;
    } else if (commodityInfoVo.count > 1) {
      commodityInfoVo.count--;
    }
    tempList[changeIndex] = commodityInfoVo.toJson();
    commodityString = json.encode(tempList).toString();
    sharedPreferences.setString(commodityKey, commodityString);
    await getCommodityList();
  }

  // 获取购物车商品列表最新价格
  getCommodityNewestPrice() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    commodityString = sharedPreferences.getString(commodityKey);
    if (commodityString != null) {
      List<Map> tempList = (json.decode(commodityString.toString()) as List).cast();
      List<int> listId = [];
      tempList.forEach((item) {
        listId.add(item['id']);
      });
      var formData = {
        'id': listId
      };
      await requestPost('getCommodityNewestPrice', formData: formData).then((val) {
        CommodityShopingCarVo commodityShopingCarVo = CommodityShopingCarVo.fromJson(val);
        commodityShopingCarVo.data.forEach((item) {
          for(int j = 0; j < tempList.length; j++) {
            if (tempList[j]['id'] == item.id) {
              tempList[j]['price'] = item.price;
              break;
            }
          }
        });
      });
      commodityString = json.encode(tempList).toString();
      sharedPreferences.setString(commodityKey, commodityString);
      await getCommodityList();
    }
  }


  @override
  void dispose() {
    _leftIndexController.close();
    _shopTypeAndEssentialMessageVoController.close();
    _commodityPageByCommodityTypeVoController.close();
    _isTheEndController.close();
    _isFollowController.close();
    _commodityInfoVoListController.close();
    _allCommodityCountController.close();
    _allPriceController.close();
    _isAllCheckController.close();
  }
}