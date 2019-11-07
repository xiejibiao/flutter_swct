import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/vo/order/order_details_vo.dart';

class OrderDetailsHand extends StatelessWidget {
  final OrderPageVo orderPageVo;
  OrderDetailsHand(
    this.orderPageVo
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    orderPageVo.imageUrl,
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setWidth(200),
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Text(
                  orderPageVo.storeName,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(44)
                  ),
                ),
              ],
            ),
            Text(
              '${orderPageVo.money}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(32)
              ),
            ),
          ],
        ),
      ),
    );
  }
}