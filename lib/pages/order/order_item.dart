import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order/order_details_bloc.dart';
import 'package:flutter_swcy/bloc/order_page_bloc.dart';
import 'package:flutter_swcy/pages/order/order_details_page.dart';
import 'package:flutter_swcy/vo/order/order_vo.dart';

class OrderItem extends StatelessWidget {
  final OrderVo orderVo;
  OrderItem(
    this.orderVo
  );

  @override
  Widget build(BuildContext context) {
    final OrderPageBloc _bloc = BlocProvider.of<OrderPageBloc>(context);
    return InkWell(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.topLeft,
          width: ScreenUtil().setWidth(750),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300])
                  )
                ),
                width: ScreenUtil().setWidth(730),
                height: ScreenUtil().setHeight(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ImageIcon(AssetImage('assets/image_icon/icon_shop.png'), color: Colors.blue),
                        Text(orderVo.storeName, style: TextStyle(fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w400))
                      ],
                    ),
                    _showStatus(_bloc, orderVo.status, context)
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      orderVo.imageUrl,
                      fit: BoxFit.cover,
                      width: ScreenUtil().setWidth(110),  
                      height: ScreenUtil().setWidth(110),  
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('总价：${orderVo.money}', style: TextStyle(fontSize: ScreenUtil().setSp(26))),
                        Text('收货地址：${orderVo.address}', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey)),
                        Text('下单时间：${DateUtil.getDateStrByMs(orderVo.orderTime)}', style: TextStyle(color: Colors.grey))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(child: OrderDetailsPage(orderVo.id), bloc: OrderDetailsBloc())));
      },
    );
  }

  Widget _showStatus(OrderPageBloc bloc, int status, BuildContext context) {
    Widget _widget;
    switch (status) {
      case 1:
        _widget = Container(
                    child: Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/image_icon/icon_to_be_confirmed.png'),
                          size: 28,
                          color: Color(0xFFFF9900)
                        ),
                        Text('待确认', style: TextStyle(color: Colors.grey[600]))
                      ],
                    ),
                  );
        break;
      case 2:
        _widget = Container(
                    child: Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/image_icon/icon_to_be_shipped.png'),
                          size: 28,
                          color: Color(0xFF3399FF)
                        ),
                        Text('待发货', style: TextStyle(color: Colors.grey[600]))
                      ],
                    ),
                  );
        break;
      case 3:
        _widget = InkWell(
                    onTap: () {
                      bloc.confirmReceipt(orderVo.id, context);
                    },
                    highlightColor: Colors.white,
                    splashColor: Colors.white,
                    child: Container(
                      child: Text('确认收货', style: TextStyle(color: Colors.white)),
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(150),
                      decoration: BoxDecoration(
                        color: Color(0xFF00CC66),
                        border: Border.all(
                          color: Color(0xFF00CC66)
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                    ),
                  );
        break;
      default:
        _widget = Container(
                    child: Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/image_icon/icon_shipped.png'),
                          size: 28,
                          color: Color(0xFF00CC66)
                        ),
                        Text('已收货', style: TextStyle(color: Colors.grey[600]),)
                      ],
                    ),
                  );
    }
    return _widget;
  }
}