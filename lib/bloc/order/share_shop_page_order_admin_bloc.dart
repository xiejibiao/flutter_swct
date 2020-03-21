import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/order/get_order_page_by_storeId_vo.dart';
import 'package:flutter_swcy/vo/order/get_shop_order_detail_by_orderId_vo.dart';
import 'package:flutter_swcy/vo/supplier/league_store_order_page_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/subjects.dart';

class ShareShopPageOrderAdminBloc extends BlocBase {
  int _pageNumber = 0, _pageSize = 10;

  GetOrderPageByStoreIdVo _getOrderPageByStoreIdVo;
  BehaviorSubject<GetOrderPageByStoreIdVo> _getOrderPageByStoreIdVoController = BehaviorSubject<GetOrderPageByStoreIdVo>();
  Sink<GetOrderPageByStoreIdVo> get _getOrderPageByStoreIdVoSink => _getOrderPageByStoreIdVoController.sink;
  Stream<GetOrderPageByStoreIdVo> get getOrderPageByStoreIdVoStream => _getOrderPageByStoreIdVoController.stream;
  bool isEnd = false;

  GetShopOrderDetailByOrderIdVo _getShopOrderDetailByOrderIdVo;
  BehaviorSubject<GetShopOrderDetailByOrderIdVo> _getShopOrderDetailByOrderIdVoController = BehaviorSubject<GetShopOrderDetailByOrderIdVo>();
  Sink<GetShopOrderDetailByOrderIdVo> get _getShopOrderDetailByOrderIdVoSink => _getShopOrderDetailByOrderIdVoController.sink;
  Stream<GetShopOrderDetailByOrderIdVo> get getShopOrderDetailByOrderIdVoStream => _getShopOrderDetailByOrderIdVoController.stream;

  /// 获取订单列表
  getOrderPageByShopId(int storeId, BuildContext context) {
    getToken().then((token) {
      _pageNumber = 0;
      var formData = {
        'pageNumber': _pageNumber,
        'pageSize': _pageSize,
        'storeId': storeId
      };
      _postAPI(token, context, formData).then((val) {
        if (val.code == '200') {
          _getOrderPageByStoreIdVo = val;
          _setIsEnd(val.data.totalPage);
          _getOrderPageByStoreIdVoSink.add(_getOrderPageByStoreIdVo);
        }
      });
    });
  }

  /// 订单列表加载更多
  loadMoreGetOrderPageByShopId(int storeId, BuildContext context) {
    if (!isEnd) {
      getToken().then((token) {
        _pageNumber++;
        var formData = {
          'pageNumber': _pageNumber,
          'pageSize': _pageSize,
          'storeId': storeId
        };
        _postAPI(token, context, formData).then((val) {
          if (val.code == '200') {
            _getOrderPageByStoreIdVo.data.list.addAll(val.data.list);
            _setIsEnd(val.data.totalPage);
            _getOrderPageByStoreIdVoSink.add(_getOrderPageByStoreIdVo);
          }
        });
      });
    }
  }

  /// API
  Future<GetOrderPageByStoreIdVo> _postAPI(String token, BuildContext context, var formData) {
    return requestPost('getOrderPageByShopId', token: token, context: context, formData: formData).then((val) {
      GetOrderPageByStoreIdVo getOrderPageByStoreIdVo = GetOrderPageByStoreIdVo.fromJson(val);
      if (getOrderPageByStoreIdVo.code != '200') {
        if (getOrderPageByStoreIdVo.code == '206') {
          showToast('此门店不属于此账号');
        } else {
          showToast(getOrderPageByStoreIdVo.message);
        }
      }
      return getOrderPageByStoreIdVo;
    });
  }

  _setIsEnd(int totalPage) {
    if (totalPage == _pageNumber + 1) {
      isEnd = true;
    } else {
      isEnd = false;
    }
  }

  /// 获取订单详情
  getShopOrderDetailByOrderId(String orderId, BuildContext context) {
    getToken().then((token) {
      var formData = {
        'orderId': orderId
      };
      requestPost('getShopOrderDetailByOrderId', context: context, formData: formData, token: token).then((val) {
        _getShopOrderDetailByOrderIdVo = GetShopOrderDetailByOrderIdVo.fromJson(val);
        if (_getShopOrderDetailByOrderIdVo.code != '200') {
          showToast(_getShopOrderDetailByOrderIdVo.message);
        } else {
          _getShopOrderDetailByOrderIdVoSink.add(_getShopOrderDetailByOrderIdVo);
        }
      });
    });
  }

  /// 确认订单
  confirmationOfOrder(String orderId, BuildContext context) {
    getToken().then((token) {
      var formData = {
        'orderId': orderId
      };
      requestPost('confirmationOfOrder', formData: formData, token: token, context: context).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          _getShopOrderDetailByOrderIdVo.data.orderEssentialInfoVo.status = 2;
          _getOrderPageByStoreIdVo.data.list.forEach((item) {
            if (item.id == orderId) {
              item.status = 2;
            }
          });
          _getShopOrderDetailByOrderIdVoSink.add(_getShopOrderDetailByOrderIdVo);
          showToast('确认订单成功');
        } else if (commenVo.code == '209') {
          showToast('订单状态异常');
        } else {
          showToast(commenVo.message);
        }
      });
    });
  }

  /// 确认发货
  confirmShipment(String orderId, String logisticsNum, BuildContext context) {
    if (logisticsNum.isEmpty) {
      showToast('请输入物流方式，或物流单号');
      return;
    }
    getToken().then((token) {
      var formData = {
        'orderId': orderId,
        'logisticsNum': logisticsNum
      };
      requestPost('confirmShipment', formData: formData, token: token, context: context).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          _getShopOrderDetailByOrderIdVo.data.orderEssentialInfoVo.status = 3;
          _getOrderPageByStoreIdVo.data.list.forEach((item) {
            if (item.id == orderId) {
              item.status = 3;
            }
          });
          _getOrderPageByStoreIdVoSink.add(_getOrderPageByStoreIdVo);
          _getShopOrderDetailByOrderIdVoSink.add(_getShopOrderDetailByOrderIdVo);
          showToast('确认发货成功');
          Navigator.pop(context);
        } else if (commenVo.code == '209') {
          showToast('订单发货异常');
        } else {
          showToast(commenVo.message);
        }
      });
    });
  }

  int _leagueStoreOrderPageNumber = 0;
  int _leagueStoreOrderPageSize = 10;
  
  LeagueStoreOrderPageVo _leagueStoreOrderPageVo;
  BehaviorSubject<LeagueStoreOrderPageVo> _leagueStoreOrderPageVoController = BehaviorSubject<LeagueStoreOrderPageVo>();
  Sink<LeagueStoreOrderPageVo> get _leagueStoreOrderPageVoSink => _leagueStoreOrderPageVoController.sink;
  Stream<LeagueStoreOrderPageVo> get leagueStoreOrderPageVoStream => _leagueStoreOrderPageVoController.stream;
  getLeagueStoreOrderPage(int storeId, BuildContext context) {
    getToken().then((token) {
      _leagueStoreOrderPageNumber = 0;
      var formData = {
        "storeId": storeId,
        "pageNumber": _leagueStoreOrderPageNumber,
        "pageSize": _leagueStoreOrderPageSize
      };
      requestPost('getLeagueStoreOrderPage', token: token, context: context, formData: formData).then((val) {
        _leagueStoreOrderPageVo = null;
        _leagueStoreOrderPageVo = LeagueStoreOrderPageVo.fromJson(val);
        _leagueStoreOrderPageVoSink.add(_leagueStoreOrderPageVo);
      });
    });
  }

  onLoadLeagueStoreOrderPage(int storeId, BuildContext context) {
    if ((_leagueStoreOrderPageVo.data.pageNumber + 1) < _leagueStoreOrderPageVo.data.totalPage) {
      _leagueStoreOrderPageNumber++;
      getToken().then((token) {
        var formData = {
          "storeId": storeId,
          "pageNumber": _leagueStoreOrderPageNumber,
          "pageSize": _leagueStoreOrderPageSize
        };
        requestPost('getLeagueStoreOrderPage', token: token, context: context, formData: formData).then((val) {
          List<LeagueStoreOrderPageVoList> tempList = _leagueStoreOrderPageVo.data.list;
          _leagueStoreOrderPageVo = LeagueStoreOrderPageVo.fromJson(val);
          _leagueStoreOrderPageVo.data.list.insertAll(0, tempList);
          _leagueStoreOrderPageVoSink.add(_leagueStoreOrderPageVo);
        });
      });
    }
  }

  leagueStoreOrderConfirmReceipt(String id, BuildContext context) {
    getToken().then((token) {
      var formData = {
        "id": id
      };
      requestPost('leagueStoreOrderConfirmReceipt', token: token, context: context, formData: formData).then((val) {
        print(val);
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          _leagueStoreOrderPageVo.data.list.forEach((item) {
            if (item.id == id) {
              item.status = 4;
            }
          });
          _leagueStoreOrderPageVoSink.add(_leagueStoreOrderPageVo);
          showToast('收货成功');
        } else {
          showToast('收货异常');
        }
      });
    });
  }

  @override
  void dispose() {
    _getOrderPageByStoreIdVoController.close();
    _getShopOrderDetailByOrderIdVoController.close();
    _leagueStoreOrderPageVoController.close();
  }
}