import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/vo/order/order_details_vo.dart';

class OrderDetailsList extends StatelessWidget {
  final List<OrderDetailListVo> orderDetailListVo;
  OrderDetailsList(
    this.orderDetailListVo
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _getOrderList(),
    );
  }

  List<Widget> _getOrderList () {
    List<Widget> detailsListWidget = [];
    orderDetailListVo.forEach((item) {
      detailsListWidget.add(_bulidOrderCard(item));
    });
    return detailsListWidget;
  }

  _bulidOrderCard (OrderDetailListVo orderDetailListVo) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.network(
              orderDetailListVo.cover,
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setHeight(100),
              fit: BoxFit.fill,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(orderDetailListVo.commodityName),
                Text("商品单价： ￥${orderDetailListVo.price}"),
              ],
            ),
            Text("数量： ￥${orderDetailListVo.num}"),
          ],
        ),
      )
    );
  }

}