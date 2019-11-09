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
              _getStatusStr(orderPageVo.status),
              Text('支付时间  ' + DateUtil.getDateStrByMs(orderPageVo.payTime)),
              Text('支付方式  ${orderPageVo.payChannel}'),
              Text('交易单号  ${orderPageVo.payNum}'),
              Text('订单编号  ${orderPageVo.id}'),
              Text('收货地址  ${orderPageVo.address}', overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
      )
    );
  }
  
  Widget _getStatusStr (int status) {
    Widget _widget;
    switch (status) {
      case 1:
        _widget = _buildStatusContainer('assets/image_icon/icon_to_be_confirmed.png', Color(0xFFFF9900), '待确认');
        break;
      case 2:
        _widget = _buildStatusContainer('assets/image_icon/icon_to_be_shipped.png', Color(0xFF3399FF), '待发货');
        break;
      case 3:
        _widget = _buildStatusContainer('assets/image_icon/icon_to_be_confirmed.png', Color(0xFFFF9900), '待收货');
        break;
      default:
        _widget = _buildStatusContainer('assets/image_icon/icon_shipped.png', Color(0xFF00CC66), '已收货');
    }
    return _widget;
  }

  Widget _buildStatusContainer(String iconPath, Color color, String msg) {
    return Container(
            child: Row(
              children: <Widget>[
                Text('当前状态 '),
                ImageIcon(
                  AssetImage(iconPath),
                  size: 28,
                  color: color
                ),
                Text(msg, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          );
  }
}