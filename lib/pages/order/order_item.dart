import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order/order_details_bloc.dart';
import 'package:flutter_swcy/pages/order/order_details_page.dart';
import 'package:flutter_swcy/vo/order/order_vo.dart';

class OrderItem extends StatelessWidget {
  final OrderVo orderVo;
  OrderItem(
    this.orderVo
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: InkWell(
          highlightColor: Colors.white,
          splashColor: Colors.white,
          child: Column(
            children: <Widget>[
              _orderTitleRow(),
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))
                )
              ),
              _orderMsgRow(),
              _orderButtonRow()
            ],
          ),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(child: OrderDetailsPage(orderVo.id), bloc: OrderDetailsBloc())));
          },
        ),
      ),
    );
  }

  // 商家名称行
  Padding _orderTitleRow () {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('${orderVo.storeName}'),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            child: Text(getStatusStr(orderVo.status)),
          )
        ],
      ),
    );
  }

  // 订单信息行
  Container _orderMsgRow () {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            orderVo.imageUrl,
            width: 55.0,
            height: 55.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('下单时间: ' + DateUtil.getDateStrByMs(orderVo.orderTime)),
                Text('总价: ￥${orderVo.money}')
              ],
            ),
          )
        ],
      ),
    );
  }

  // 正在显示的按钮
  List<Widget> getButtonByStatus () {
    List<Widget> _buttonList = [];
    switch (orderVo.status) {
      // 未支付
      case 0:
        _buttonList..add(_payButton())..add(_cancelOrderButton());
        return _buttonList;
        break;
      // 已支付
      case 1:
        _buttonList.add(_buildStatuasContainer('待发货'));
        return _buttonList;
        break;
      // 代发货
      case 2:
        _buttonList.add(_buildStatuasContainer('已发货'));
        return _buttonList;
        break;
      // 已发货
      case 3:
        _buttonList..add(_receivingButton())..add(_logisticsButton());
        return _buttonList;
        break;
      // 待收货
      case 4:
        _buttonList.add(_buildStatuasContainer('已收货'));
        return _buttonList;
        break;
      default:
        _buttonList.add(_returnButton());
        return _buttonList;
    }
  }

  // 查看物流按钮
  InkWell _logisticsButton () {
    return InkWell(
      onTap: () {
        print('查看物流按钮 ${orderVo.storeName}');
      },
      highlightColor: Colors.white,
      splashColor: Colors.white,
      child: Container(
        child: Text('查看物流'),
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFBBBBBB)
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
      ),
    );
  }

  // 确认收货按钮
  InkWell _receivingButton () {
    return InkWell(
      onTap: () {
        print('确认收货 ${orderVo.storeName}');
      },
      highlightColor: Colors.white,
      splashColor: Colors.white,
      child: Container(
        child: Text('确认收货'),
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFBBBBBB)
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
      ),
    );
  }

  // 取消订单按钮
  InkWell _cancelOrderButton () {
    return InkWell(
      onTap: () {
        print('取消订单按钮 ${orderVo.storeName}');
      },
      highlightColor: Colors.white,
      splashColor: Colors.white,
      child: Container(
        child: Text('取消订单'),
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFBBBBBB)
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
      ),
    );
  }

  // 申请退货按钮(未做退货流程)
  InkWell _returnButton () {
    return InkWell(
      onTap: () {
        print('申请退货按钮 ${orderVo.storeName}');
      },
      highlightColor: Colors.white,
      splashColor: Colors.white,
      child: Container(
        child: Text('申请退货'),
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFBBBBBB)
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
      ),
    );
  }

  // 支付按钮
  InkWell _payButton () {
    return InkWell(
      onTap: () {
        print('支付按钮 ${orderVo.storeName}');
      },
      highlightColor: Colors.white,
      splashColor: Colors.white,
      child: Container(
        child: Text('支付'),
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFBBBBBB)
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
      ),
    );
  }

  // 按钮行
  Row _orderButtonRow () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: getButtonByStatus(),
    );
  }

  // 按钮样式
  Container _buildStatuasContainer (String title) {
    return Container(
      child: Text(title),
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFBBBBBB)
        ),
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
    );
  }

  // 状态文字
  String getStatusStr (int status) {
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