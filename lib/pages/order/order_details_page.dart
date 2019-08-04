import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order/order_details_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/order/order_details_hand.dart';
import 'package:flutter_swcy/pages/order/order_details_list.dart';
import 'package:flutter_swcy/pages/order/order_details_msg.dart';
import 'package:flutter_swcy/vo/order/order_details_vo.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;
  OrderDetailsPage(
    this.orderId
  );
  @override
  Widget build(BuildContext context) {
    final OrderDetailsBloc _bloc = BlocProvider.of<OrderDetailsBloc>(context);
    _bloc.getOrderDetailById(orderId, context);
    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情'),
      ),
      body: StreamBuilder(
        stream: _bloc.orderDetailsStream,
        builder: (context, blocSanpshop) {
          if (blocSanpshop.hasData) {
            OrderDetailsVo orderDetailsVo = blocSanpshop.data;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  OrderDetailsHand(orderDetailsVo.data.orderPageVo),
                  OrderDetailsList(orderDetailsVo.data.orderDetailListVo),
                  OrderDetailsMsg(orderDetailsVo.data.orderPageVo)
                ],
              ),
            );
          } else {
            return showLoading();
          }
        },
      ),
    );
  }
}