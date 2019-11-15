import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/preference_utils.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_page_by_commodity_type_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_shopingcar_vo.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';
import 'package:flutter_swcy/vo/unified_order_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/subjects.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class ShopPagesBloc extends BlocBase {

  int leftIndex = 0;
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

  // 左侧分类是否被选中
  thisIndexIsSelected(int index) {
    if (leftIndex == index) {
      return true;
    } else {
      return false;
    }
  }

  // 修改左侧分类的当前下标
  setLeftIndex(int index, bool isAdmin) {
    if (leftIndex != index) {
      leftIndex = index;
      commodityTypeId = commodityTypeList[index].id;
      getCommodityPageByCommodityTypeId(isAdmin);
      _leftIndexSink.add(index);
    }
  }

  // 获取门店分类，详情，是否关注
  getShopTypeAndEssentialMessage(BuildContext context, int id, bool isAdmin) {
    getToken().then((token) async {
      var formData = {
        'id': id
      };
      await requestPost('getShopTypeAndEssentialMessage', formData: formData, token: token, context: context).then((data) async {
        ShopTypeAndEssentialMessageVo shopTypeAndEssentialMessageVo = ShopTypeAndEssentialMessageVo.fromJson(data);
        commodityTypeList = shopTypeAndEssentialMessageVo.data.commodityTypeList;
        _isFollow = shopTypeAndEssentialMessageVo.data.follow;
        _isFollowSink.add(_isFollow);
        if (shopTypeAndEssentialMessageVo.data.commodityTypeList.length > 0) {
          commodityTypeId = shopTypeAndEssentialMessageVo.data.commodityTypeList[leftIndex].id;
          await getCommodityPageByCommodityTypeId(isAdmin);
        }
        _shopTypeAndEssentialMessageVoSink.add(shopTypeAndEssentialMessageVo);
      });
    });
  }

  // 获取门店商品列表
  getCommodityPageByCommodityTypeId(bool isAdmin) async {
    _isTheEndSink.add(false);
    pageNumber = 0;
    var formData = {
      'commodityTypeId': commodityTypeId,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'isAdmin': isAdmin
    };
    await requestPost('getCommodityPageByCommodityTypeId', formData: formData).then((data) {
      this.commodityPageByCommodityTypeVo = CommodityPageByCommodityTypeVo.fromJson(data);
      setIsTheEnd(commodityPageByCommodityTypeVo.data.totalPage);
      _commodityPageByCommodityTypeVoSink.add(this.commodityPageByCommodityTypeVo);
    });
  }

  loadMoreCommodityPageByCommodityTypeId(bool isAdmin) async {
    if ((pageNumber + 1) < commodityPageByCommodityTypeVo.data.totalPage) {
      pageNumber++;
      var formData = {
        'commodityTypeId': commodityTypeId,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'isAdmin': isAdmin
      };
      await requestPost('getCommodityPageByCommodityTypeId', formData: formData).then((data) {
        CommodityPageByCommodityTypeVo tempCommodityPageByCommodityTypeVo = CommodityPageByCommodityTypeVo.fromJson(data);
        if (tempCommodityPageByCommodityTypeVo.code == '200') {
          this.commodityPageByCommodityTypeVo.data.list.addAll(tempCommodityPageByCommodityTypeVo.data.list);
          setIsTheEnd(commodityPageByCommodityTypeVo.data.totalPage);
          _commodityPageByCommodityTypeVoSink.add(commodityPageByCommodityTypeVo);
        } else {
          showToast(tempCommodityPageByCommodityTypeVo.message);
        }
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

  // 添加类型
  addCommodityType(BuildContext context, String name, int storeId) {
    var formData = {
      'name': name,
      'storeId': storeId
    };
    requestPost('addCommodityType', formData: formData).then((val) {
      CommenVo commenVo = CommenVo.fromJson(val);
      if (commenVo.code == '200') {
        showToast('添加商品类型成功');
        getShopTypeAndEssentialMessage(context, storeId, true);
      } else {
        showToast(commenVo.message);
      }
    });
  }

  // 删除类型
  deleteCommodityType(int typeId, BuildContext context, int storeId) {
    var formData = {
      'id': typeId
    };
    requestPost('deleteCommodityType', formData: formData).then((val) {
      CommenVo commenVo = CommenVo.fromJson(val);
      if (commenVo.code == '200') {
        showToast('删除商品类型成功');
        getShopTypeAndEssentialMessage(context, storeId, true);
      } else {
        showToast(commenVo.message);
      }
    });
  }

  // 修改商品类型
  editCommodityType(int typeId, String name, BuildContext context, int storeId) {
    var formData = {
      'id': typeId,
      'name': name
    };
    requestPost('editCommodityType', formData: formData).then((val) {
      CommenVo commenVo = CommenVo.fromJson(val);
      if (commenVo.code == '200') {
        showToast('修改商品类型成功');
        getShopTypeAndEssentialMessage(context, storeId, true);
      } else {
        showToast(commenVo.message);
      }
    });
  }

  /// 添加商品成功后，添加对象到列表
  addCommodityToList(CommodityList commodityList) {
    commodityPageByCommodityTypeVo.data.list.add(commodityList);
    _commodityPageByCommodityTypeVoSink.add(commodityPageByCommodityTypeVo);
  }

  /// 删除商品成功后，删除对象
  removeCommodityById(int id) {
    int removeIndex = 0;
    for(int i = 0; i < commodityPageByCommodityTypeVo.data.list.length; i++) {
      if (commodityPageByCommodityTypeVo.data.list[i].id == id) {
        removeIndex = i;
        break;
      }
    }
    commodityPageByCommodityTypeVo.data.list.removeAt(removeIndex);
    _commodityPageByCommodityTypeVoSink.add(commodityPageByCommodityTypeVo);
  }

  /// 修改商品后，直接修改列表对象
  editCommodityToList(CommodityList commodityList) {
    int editIndex = 0;
    for(int i = 0; i < commodityPageByCommodityTypeVo.data.list.length; i++) {
      if (commodityPageByCommodityTypeVo.data.list[i].id == commodityList.id) {
        editIndex = i;
        break;
      }
    }
    commodityPageByCommodityTypeVo.data.list[editIndex] = commodityList;
    _commodityPageByCommodityTypeVoSink.add(commodityPageByCommodityTypeVo);
  }

  // 修改商品详情后，重新修改商品详情字段
  resetCommodityDetail(String detail, int id) {
    int editIndex = 0;
    for(int i = 0; i < commodityPageByCommodityTypeVo.data.list.length; i++) {
      if (commodityPageByCommodityTypeVo.data.list[i].id == id) {
        editIndex = i;
        break;
      }
    }
    commodityPageByCommodityTypeVo.data.list[editIndex].detail= detail;
    _commodityPageByCommodityTypeVoSink.add(commodityPageByCommodityTypeVo);
  }

  // ----------------------------------------------------------------------------------------------------------------------------
  
  // 进入商家时，必须初始化此值
  String commodityKey = 'COMMODITY_INFO';
  // 进入商家时，必须初始化此值
  setCommodityKey(int shopId) {
    commodityKey = '${commodityKey}_$shopId';
    getCommodityInfoVos();
  }

  // 购物车商品列表
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
  // 结算时，获取选中的商品列表
  BehaviorSubject<Map<String, dynamic>> _settlementCommodityInfoVoListController = BehaviorSubject<Map<String, dynamic>>();
  Sink<Map<String, dynamic>> get _settlementCommodityInfoVoListSink => _settlementCommodityInfoVoListController.sink;
  Stream<Map<String, dynamic>> get settlementCommodityInfoVoListStream => _settlementCommodityInfoVoListController.stream;
  bool _isAllChecked = false;                   // 是否全选
  int _allSelectedCount = 0;                    // 选中的物品数量
  double _allSelectedPrice = 0.0;               // 选中物品的全部价格
  String _shoppingCarStringList = '[]';         // 用于持久化
  List<CommodityInfoVo> _commodityInfoVos = []; // 购物车物品列表
  getCommodityInfoVos() {
    PreferenceUtils.instance.getString(key: commodityKey, defaultValue: '[]').then((value) {
      _shoppingCarStringList = value;
      _commodityInfoVos.clear();
      _commodityInfoVos.addAll(_shoppingCarStringList == '[]' ? [] : CommodityInfoVo.fromJsonList(json.decode(_shoppingCarStringList)));
      _commodityInfoVoListSink.add(_commodityInfoVos);
      _allInfoStateCheck();
    });
  }

  /// 数量，全选状态修改封装
  void _allInfoStateCheck() {
    // _allShoppingCartCount = 0;
    _allSelectedCount = 0;
    _allSelectedPrice = 0.0;
    _isAllChecked = true;

    _commodityInfoVos.forEach((e) {
      // _allShoppingCartCount += e.count; // 全部数量
      if (!e.isCheck) {
        _isAllChecked = false; // 如果一个未选中，则全选为 false
      } else {
        _allSelectedCount += e.count;
        _allSelectedPrice += e.count * e.price;
      }
    });
    _allPriceSink.add(_allSelectedPrice);
    _allCommodityCountSink.add(_allSelectedCount);
    _isAllCheckSink.add(_isAllChecked);
  }

  /// 保存物品到购物车
  saveCommodityToShoppingCar({@required id, @required name, @required count, @required price, @required cover}) {
    List<dynamic> carts = _shoppingCarStringList == '[]' ? [] : json.decode(_shoppingCarStringList);
    var included = false;
    if (carts.isNotEmpty) {
      carts.forEach((cart) {
        // 不是空列表的情况下，判断是否已经存在该物品，存在则添加，并设置状态位
        if (cart['id'] == id) {
          cart['count'] += count;
          included = true;
        }
      });
    }

    // 不存在该商品的时候则全部加入到列表
    if (!included) {
      carts.add({
        'id': id,
        'name': name,
        'count': count,
        'price': price,
        'cover': cover,
        'isCheck': true,
        'delFlag': 0
      });
    }
    showToast('加入购物车成功');
    _notifyChanges(carts);
  }

  /// 更新购物车状态封装方法
  _notifyChanges(List carts) {
    PreferenceUtils.instance.saveString(key: commodityKey, value: json.encode(carts));
    _shoppingCarStringList = json.encode(carts);
    _commodityInfoVos.clear();
    _commodityInfoVos.addAll(carts.isEmpty ? [] : CommodityInfoVo.fromJsonList(carts));
    _commodityInfoVoListSink.add(_commodityInfoVos);
    _allInfoStateCheck();
  }

  /// 增加/减少商品数量
  increaseOrReduceOperation({@required int id, @required bool isIncrease}) {
    List<dynamic> carts = json.decode(_shoppingCarStringList);
    // 已经存在的情况下才增加减少，修改数量值
    carts.forEach((cart) {
      if (cart['id'] == id) {
        if (isIncrease) {
          cart['count'] += 1;
        } else {
          cart['count'] -= 1;
        }
      }
    });
    _notifyChanges(carts);
  }

  /// 移除购物车内的某个商品
  removeCarts({@required int id}) {
    List<dynamic> carts = _shoppingCarStringList == '[]' ? [] : json.decode(_shoppingCarStringList);
    if (carts.isNotEmpty) {
      carts.removeWhere((e) => e['id'] == id);
    }
    _notifyChanges(carts);
  }

  /// 修改特定商品在购物车的选中状态
  changeCartState({@required int id, @required bool checked}) {
    List<dynamic> carts = _shoppingCarStringList == '[]' ? [] : json.decode(_shoppingCarStringList);
    if (carts.isNotEmpty) {
      carts.forEach((cart) {
        if (cart['id'] == id) {
          cart['isCheck'] = checked;
        }
      });
    }
    _notifyChanges(carts);
  }

  /// 全选状态修改
  allCheckStateChange(bool checkState) {
    List<dynamic> carts = _shoppingCarStringList == '[]' ? [] : json.decode(_shoppingCarStringList);
    if (carts.isNotEmpty) {
      carts.forEach((cart) {
        if(cart['delFlag'] != 1) {
          cart['isCheck'] = checkState; // 所有状态跟随全选修改
        }
      });
    }
    _notifyChanges(carts);
  }

  // 获取购物车商品列表最新价格
  getCommodityNewestPrice() async {
    await getCommodityInfoVos();
    List<dynamic> carts = _shoppingCarStringList == '[]' ? [] : json.decode(_shoppingCarStringList);
    if (carts.length > 0) {
      List<int> listId = [];
      carts.forEach((item) {
        listId.add(item['id']);
      });
      var formData = {
        'id': listId
      };
      await requestPost('getCommodityNewestPrice', formData: formData).then((val) {
        CommodityShopingCarVo commodityShopingCarVo = CommodityShopingCarVo.fromJson(val);
        commodityShopingCarVo.data.forEach((item) {
          for(int j = 0; j < carts.length; j++) {
            if (carts[j]['id'] == item.id) {
              carts[j]['price'] = item.price;
              if (item.delFlag == 1) {
                carts[j]['delFlag'] = item.delFlag;
                carts[j]['isCheck'] = false;
              } else {
                carts[j]['delFlag'] = item.delFlag;
              }
              break;
            }
          }
        });
      });
    }
    await _notifyChanges(carts);
  }

  // 获取选中的购物车商品
  getShopingCarCommoditysByIsCheckFormTrue() {
    List<dynamic> tempCommodityInfoVos = _shoppingCarStringList == '[]' ? [] : json.decode(_shoppingCarStringList);
    List<CommodityInfoVo> commodityInfoVos = CommodityInfoVo.fromJsonList(tempCommodityInfoVos);
    List<CommodityInfoVo> newCommodityInfoVos = [];
    int count = 0;
    double pricr = 0.0;
    Map<String, dynamic> map = Map<String, dynamic>();
    commodityInfoVos.forEach((item) {
      if (item.isCheck) {
        newCommodityInfoVos.add(item);
        count += item.count;
        pricr += item.count * item.price;
      }
    });
    map.addAll(
      {
        'list': newCommodityInfoVos,
        'count': count,
        'price': pricr
      }
    );
    _settlementCommodityInfoVoListSink.add(map);    
  }
  // ----------------------------------------------------------------------------------------------------------------------------
  List<int> _ids = [];
  /// 微信支付
  wxPay(BuildContext context, int addressId, int storeId, List list) {
    var map = {};
    // LinkedHashMap map = new LinkedHashMap();
    for(int i = 0; i < list.length; i++) {
      map['${list[i].id}'] = list[i].count;
      _ids.add(list[i].id);
    }
    getToken().then((token) {
      Map<String, dynamic> formData = {
        'addressId': addressId,
        'idAndCount': map,
        "storeId": storeId
      };
      requestPost('wxPay', formData: formData, context: context, token: token).then((val) {
        UnifiedOrderVo unifiedOrderVo = UnifiedOrderVo.fromJson(val);
        if (unifiedOrderVo.code == '200') {
          double _timeStamp = (DateUtil.getNowDateMs()) / 1000;
          int temp = int.parse(_timeStamp.toStringAsFixed(0));
          fluwx.pay(
            appId: unifiedOrderVo.data.appid.toString(),
            partnerId: unifiedOrderVo.data.mchId.toString(),
            prepayId: unifiedOrderVo.data.prepayId.toString(),
            packageValue: 'Sign=WXPay',
            nonceStr: unifiedOrderVo.data.nonceStr.toString(),
            timeStamp: unifiedOrderVo.data.sign,
            sign: temp.toString(),
            signType: '',
            extData: ''
          );
        } else {
          showToast('下单异常');
        }
      });
    });
  }

  /// 监听微信支付状态
  wxPayListen (BuildContext context) {
    getCommodityInfoVos();
    fluwx.responseFromPayment.listen((data) {
      if (data.errCode == 0) {
        showToast('支付成功');
        _ids.forEach((id) {
          removeCarts(id: id);
        });
        Navigator.pop(context);
      } else if (data.errCode == -2) {
        showToast('取消支付');
      } else if (data.errCode == -1) {
        showToast('支付异常');
      }
    });
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
    _settlementCommodityInfoVoListController.close();
  }
}