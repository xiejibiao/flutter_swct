import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/order/order_details_vo.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailsBloc extends BlocBase {

  BehaviorSubject<OrderDetailsVo> _orderDetailsController = BehaviorSubject<OrderDetailsVo>();
  Sink<OrderDetailsVo> get _orderDetailsink => _orderDetailsController.sink;
  Stream<OrderDetailsVo> get orderDetailsStream => _orderDetailsController.stream;

  getOrderDetailById(String id, BuildContext context) {
    return getToken().then((token) async {
      var formData = {
        'orderId': id
      };
      return await requestPost('getOrderDetailById', token: token, context: context, formData: formData).then((val) {
        OrderDetailsVo orderDetailsVo = OrderDetailsVo.fromJson(val);
        _orderDetailsink.add(orderDetailsVo);
        return orderDetailsVo;
      });
    });
  }

  @override
  void dispose() {
    _orderDetailsController.close();
  }
}