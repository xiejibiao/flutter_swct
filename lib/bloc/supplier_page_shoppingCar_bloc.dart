import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/dialog_router.dart';
import 'package:flutter_swcy/common/loading_dialog.dart';
import 'package:flutter_swcy/common/preference_utils.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';
import 'package:flutter_swcy/vo/supplier/supplier_commodity_latest_price_vo.dart';
import 'package:flutter_swcy/vo/unified_order_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class SupplierPageShoppingCarBloc extends BlocBase {

  /// 供应商缓存key
  String _supplierKEY = 'SUPPLIERKEY_';
  /// 供应商Id
  String _supplierId;
  /// 是否全选
  bool _isAllChecked = false;     
  /// 选中的物品数量               
  int _allSelectedCount = 0;
  /// 选中物品的全部价格    
  double _allSelectedPrice = 0.0;               
  /// 用于持久化
  String _shoppingCarStringList = '[]';
  /// 购物车物品列表
  List<CommodityInfoVo> _commodityInfoVos = [];

  /// 购物车物品列表(已勾选)
  List<CommodityInfoVo> _tempCommodityInfoVos = [];

  /// 所选共享商家
  MyStorePageItem _myStorePageItem;

  BehaviorSubject<MyStorePageItem> _myStorePageVoController = BehaviorSubject<MyStorePageItem>();
  Sink<MyStorePageItem> get _myStorePageVotSink => _myStorePageVoController.sink;
  /// 所选共享商家
  Stream<MyStorePageItem> get myStorePageVoStream => _myStorePageVoController.stream;

  BehaviorSubject<List<CommodityInfoVo>> _tempCommodityInfoVoListController = BehaviorSubject<List<CommodityInfoVo>>();
  Sink<List<CommodityInfoVo>> get _tempCommodityInfoVoListSink => _tempCommodityInfoVoListController.sink;
  /// 购物车物品列表(已勾选)
  Stream<List<CommodityInfoVo>> get tempCommodityInfoVoListStream => _tempCommodityInfoVoListController.stream;
  
  BehaviorSubject<List<CommodityInfoVo>> _commodityInfoVoListController = BehaviorSubject<List<CommodityInfoVo>>();
  Sink<List<CommodityInfoVo>> get _commodityInfoVoListSink => _commodityInfoVoListController.sink;
  /// 购物车商品列表
  Stream<List<CommodityInfoVo>> get commodityInfoVoListStream => _commodityInfoVoListController.stream;
  
  BehaviorSubject<double> _allPriceController = BehaviorSubject<double>();
  Sink<double> get _allPriceSink => _allPriceController.sink;
  /// 持久化购物车商品价格
  Stream<double> get allPriceStream => _allPriceController.stream;
  
  BehaviorSubject<int> _allCommodityCountController = BehaviorSubject<int>();
  Sink<int> get _allCommodityCountSink => _allCommodityCountController.sink;
  /// 持久化购物车数量
  Stream<int> get allCommodityCountStream => _allCommodityCountController.stream;
  
  BehaviorSubject<bool> _isAllCheckController = BehaviorSubject<bool>();
  Sink<bool> get _isAllCheckSink => _isAllCheckController.sink;
  /// 是否全选
  Stream<bool> get isAllCheckStream => _isAllCheckController.stream;
  
  /// 初始化供应商缓存Key
  initSupplierKEY (String supplierKey) {
    _supplierKEY = '${_supplierKEY}_$supplierKey';
    _supplierId = supplierKey;
    getSupplierCommodityStr();
  }

  /// 获取缓存订单
  getSupplierCommodityStr() {
    PreferenceUtils.instance.getString(key: _supplierKEY, defaultValue: '[]').then((val) {
      _shoppingCarStringList = val;
      _commodityInfoVos.clear();
      _commodityInfoVos.addAll(_shoppingCarStringList == '[]' ? [] : CommodityInfoVo.fromJsonList(json.decode(_shoppingCarStringList)));
      _commodityInfoVoListSink.add(_commodityInfoVos);
      _allInfoStateCheck();
    });
  }

  /// 保存物品到购物车
  saveCommodityToShoppingCar({
                              @required id, 
                              @required name, 
                              @required count, 
                              @required price, 
                              @required cover
                            }) {
      
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
    PreferenceUtils.instance.saveString(key: _supplierKEY, value: json.encode(carts));
    _shoppingCarStringList = json.encode(carts);
    _commodityInfoVos.clear();
    _commodityInfoVos.addAll(carts.isEmpty ? [] : CommodityInfoVo.fromJsonList(carts));
    _commodityInfoVoListSink.add(_commodityInfoVos);
    _allInfoStateCheck();
  }

  /// 数量，全选状态修改封装
  void _allInfoStateCheck() {
    _allSelectedCount = 0;
    _allSelectedPrice = 0.0;
    _isAllChecked = true;

    _commodityInfoVos.forEach((e) {
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

  /// 获取已勾选的商品
  getCheckTrueSupplierCommoditys() {
    _tempCommodityInfoVos.clear();
    _commodityInfoVos.forEach((item) {
      if (item.isCheck) {
        _tempCommodityInfoVos.add(item);
      }
    });
    _tempCommodityInfoVoListSink.add(_tempCommodityInfoVos);
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
  getSupplierCommodityLatestPrice() async {
    List<dynamic> carts = _shoppingCarStringList == '[]' ? [] : json.decode(_shoppingCarStringList);
    if (carts.length > 0) {
      List<int> listId = [];
      carts.forEach((item) {
        listId.add(item['id']);
      });
      var formData = {
        'id': listId
      };
      await requestPost('getSupplierCommodityLatestPrice', formData: formData).then((val) {
        SupplierCommodityLatestPriceVo supplierCommodityLatestPriceVo = SupplierCommodityLatestPriceVo.fromJson(val);
        supplierCommodityLatestPriceVo.data.forEach((item) {
          for(int j = 0; j < carts.length; j++) {
            if (carts[j]['id'] == item.id) {
              carts[j]['price'] = item.retailPrice;
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

  /// 监听微信支付状态
  supplierWxPayListen (BuildContext context) {
    // getCommodityInfoVos();
    fluwx.responseFromPayment.listen((data) {
      if (data.errCode == 0) {
        showToast('支付成功');
        _tempCommodityInfoVos.forEach((item) {
          removeCarts(id: item.id);
        });
        Navigator.pop(context);
      } else if (data.errCode == -2) {
        showToast('取消支付');
      } else if (data.errCode == -1) {
        showToast('支付异常');
      }
    });
  }

  /// 供应商统一下单
  supplierUnifiedOrderWxPay(BuildContext context, int addressId) {
    Navigator.of(context).push(DialogRouter(LoadingDialog()));
    getToken().then((token) {
      var tempIdAndCount = {};
      _tempCommodityInfoVos.forEach((item) {
        tempIdAndCount['${item.id}'] = item.count;
      });
      var formData = {
        'addressId': addressId,
        'idAndCount': tempIdAndCount,
        'storeId': _myStorePageItem.id,
        'supplierId': _supplierId
      };
      requestPost('supplierUnifiedOrderWxPay', context: context, formData: formData, token: token).then((val){
        Navigator.pop(context);
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

  /// 设置所选商家
  setMyStorePageItem (MyStorePageItem myStorePageItem) {
    _myStorePageItem = myStorePageItem;
    _myStorePageVotSink.add(_myStorePageItem);
  }

  @override
  void dispose() {
    _commodityInfoVoListController.close();
    _allPriceController.close();
    _allCommodityCountController.close();
    _isAllCheckController.close();
    _tempCommodityInfoVoListController.close();
    _myStorePageVoController.close();
  }
}