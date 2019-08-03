import 'package:flutter/material.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/vo/order/order_details_vo.dart';

class OrderDetailsMsg extends StatelessWidget {
  final OrderPageVo orderPageVo;
  OrderDetailsMsg(
    this.orderPageVo
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setHeight(300),
      width: ScreenUtil().setWidth(750),
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('当前状态  ' + _getStatusStr(orderPageVo.status)),
              Text('支付时间  ' + DateUtil.getDateStrByMs(orderPageVo.payTime)),
              Text('支付方式  ${orderPageVo.payChannel}'),
              Text('交易单号  ${orderPageVo.payNum}'),
              Text('订单编号  ${orderPageVo.id}')
            ],
          ),
        ),
      )
    );
  }

  String _getStatusStr (int status) {
    switch (status) {
      // 未支付
      case 0:
        return '未支付';
        break;
      // 已支付
      case 1:
        return '已支付';
        break;
      // 代发货
      case 2:
        return '代发货';
        break;
      // 已发货
      case 3:
        return '已发货';
        break;
      // 待收货
      case 4:
        return '待收货';
        break;
      default:
        return '申请退货';
    }
  }
}