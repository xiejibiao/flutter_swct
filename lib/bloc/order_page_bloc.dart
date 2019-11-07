import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/order/order_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class OrderPageBloc extends BlocBase {
  bool _isFirst = true;
  
  BehaviorSubject<OrderPageVo> _orderPageController = BehaviorSubject<OrderPageVo>();
  Sink<OrderPageVo> get _orderPageSink => _orderPageController.sink;
  Stream<OrderPageVo> get orderPageStream => _orderPageController.stream;
  
  BehaviorSubject<bool> _isEndController = BehaviorSubject<bool>();
  Sink<bool> get _isEndSink => _isEndController.sink;
  Stream<bool> get isEndStream => _isEndController.stream;

  OrderPageVo orderPageVo;
  int pageNumber = 0;
  int pageSize = 10;
  bool isEnd = false;
  
  getOrderPage(BuildContext context, bool isOnRefresh) async {
    if (isOnRefresh) {
      _isFirst = isOnRefresh;
    }
    if (_isFirst) {
      return await getToken().then((token) async {
        this.pageNumber = 0;
        var formData = {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        };
        var response = await requestPost('getOrderPage', token: token, formData: formData, context: context);
        OrderPageVo orderPageVo = OrderPageVo.fromJson(response);
        _orderPageSink.add(orderPageVo);
        setIsEnd(orderPageVo.data.totalPage);
        this.orderPageVo = orderPageVo;
        this._isFirst = false;
        return orderPageVo;
      });
    }
  }

  loadMoreOrderPage(BuildContext context) async {
    if (!isEnd) {
      return await getToken().then((token) async {
        this.pageNumber++;
        var formData = {
          'pageNumber': pageNumber,
          'pageSize': pageSize
        };
        await requestPost('getOrderPage', token: token, formData: formData, context: context).then((val){
          OrderPageVo orderPageVo = OrderPageVo.fromJson(val);
          setIsEnd(orderPageVo.data.totalPage);
          _orderPageSink.add(orderPageVo);
          this.orderPageVo.data.list.addAll(orderPageVo.data.list);
        });
      });
    }
  }

  setIsEnd(int totalPage) {
    if (totalPage == pageNumber + 1) {
      _isEndSink.add(true);
      isEnd = true;
    } else {
      _isEndSink.add(false);
      isEnd = false;
    }
  }

  /// 确认收货
  confirmReceipt(orderId) {
    var formData = {
      'orderId': orderId
    };
    getToken().then((token) {
      requestPost('confirmReceipt', formData: formData, token: token).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          orderPageVo.data.list.forEach((item) {
            if (item.id == orderId) {
              item.status = 4;
            }
          });
          _orderPageSink.add(orderPageVo);
          showToast('确认收货成功');
        } else {
          showToast('订单状态异常');
        }
      });
    });
  }

  @override
  void dispose() {
    _orderPageController.close();
    _isEndController.close();
  }
}