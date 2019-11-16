import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/supplier_page_order_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/order_default_image.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_page_order_detail.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/supplier/supplier_order_page_vo.dart';

class SupplierPageOrder extends StatefulWidget {
  @override
  _SupplierPageOrderState createState() => _SupplierPageOrderState();
}

class _SupplierPageOrderState extends State<SupplierPageOrder> {
  final TextEditingController _controller = TextEditingController();
  SupplierPageOrderBloc _bloc;
  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SupplierPageOrderBloc>(context);
      _bloc.getSupplierOrderPage(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('订单'),
      ),
      body: StreamBuilder(
        stream: _bloc.supplierOrderPageVoStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            SupplierOrderPageVo supplierOrderPageVo = sanpshop.data;
            if (supplierOrderPageVo.data.list.length == 0) {
              return InkWell(
                onTap: () {
                  _bloc.getSupplierOrderPage(context);
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OrderDefaultImage(),
                      Text('点击刷新', style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              );
            } else {
              return EasyRefresh.custom(
                header: BallPulseHeader(),
                footer: BallPulseFooter(
                  enableHapticFeedback: true,
                  enableInfiniteLoad: false
                ),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                        return _buildItem(supplierOrderPageVo.data.list[index], _bloc, context);
                      },
                      childCount: supplierOrderPageVo.data.list.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: (supplierOrderPageVo.data.pageNumber + 1) == supplierOrderPageVo.data.totalPage ? TheEndBaseline() : Container(),
                  )
                ],
                onLoad: () async {
                  await _bloc.loadMoreSupplierOrderPage(context);
                },
                onRefresh: () async {
                  await _bloc.getSupplierOrderPage(context);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildItem(SupplierOrderPageVoList supplierOrderPageVoList, SupplierPageOrderBloc bloc, BuildContext context) {
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
                        ImageIcon(AssetImage('assets/image_icon/icon_supplier.png'), color: Colors.blue),
                        Text(supplierOrderPageVoList.supplierInfoVo.name, style: TextStyle(fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w400))
                      ],
                    ),
                    Row(
                      children: _statusWidgets(supplierOrderPageVoList.status, supplierOrderPageVoList.id, context, bloc),
                    )
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      supplierOrderPageVoList.supplierInfoVo.photo,
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
                        Text('总价：${supplierOrderPageVoList.money}', style: TextStyle(fontSize: ScreenUtil().setSp(26))),
                        Text('收货地址：${supplierOrderPageVoList.receivingAddressVo.provinceName}${supplierOrderPageVoList.receivingAddressVo.cityName}${supplierOrderPageVoList.receivingAddressVo.areaName}${supplierOrderPageVoList.receivingAddressVo.address}', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey)),
                        Text('下单时间：${DateUtil.getDateStrByMs(supplierOrderPageVoList.orderTime)}', style: TextStyle(color: Colors.grey))
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
        Navigator.push(context, CupertinoPageRoute(builder: (context) => SupplierPageOrderDetails(supplierOrderPageVoList)));
      },
    );
  }

  List<Widget> _statusWidgets(int status, String id, BuildContext context, SupplierPageOrderBloc bloc) {
    List<Widget> _widgets = [];
    switch (status) {
      case 1:
        Widget _windget = Container(
                            child: Row(
                              children: <Widget>[
                                ImageIcon(
                                  AssetImage('assets/image_icon/icon_money1.png'),
                                  size: 28,
                                  color: Color(0xFF2B8CF0)
                                ),
                                Text('已支付', style: TextStyle(color: Colors.grey[600]))
                              ],
                            ),
                          );
        _widgets.add(_windget);
        break;
      case 2:
        Widget _windget = Container(
                            child: Row(
                              children: <Widget>[
                                ImageIcon(
                                  AssetImage('assets/image_icon/icon_to_be_shipped.png'),
                                  size: 28,
                                  color: Color(0xFF2B8CF0)
                                ),
                                Text('待发货', style: TextStyle(color: Colors.grey[600]))
                              ],
                            ),
                          );
        _widgets.add(_windget);
        break;
      case 3:
        Widget _applyForReturn = InkWell(
                                  onTap: () {
                                    _controller.text = '';
                                    _applyForReturnFun(context, bloc, id);
                                  },
                                  highlightColor: Colors.white,
                                  splashColor: Colors.white,
                                  child: Container(
                                    child: Text('申请退货', style: TextStyle(color: Colors.white)),
                                    alignment: Alignment.center,
                                    width: ScreenUtil().setWidth(150),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF9900),
                                      border: Border.all(
                                        color: Color(0xFFFF9900)
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                                    ),
                                  ),
                                );

        Widget _confirmReceipt = InkWell(
                                  onTap: () {
                                    bloc.supplierOrderConfirmReceipt(id, context);
                                  },
                                  highlightColor: Colors.white,
                                  splashColor: Colors.white,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.0),
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
        _widgets.add(_applyForReturn);
        _widgets.add(_confirmReceipt);
        break;
      case 4:
        Widget _windget = Container(
                            child: Row(
                              children: <Widget>[
                                ImageIcon(
                                  AssetImage('assets/image_icon/icon_shipped.png'),
                                  size: 28,
                                  color: Color(0xFF19BE6B)
                                ),
                                Text('已收货', style: TextStyle(color: Colors.grey[600]))
                              ],
                            ),
                          );
        _widgets.add(_windget);
        break;
      case 5:
         Widget _windget = Container(
                            child: Row(
                              children: <Widget>[
                                ImageIcon(
                                  AssetImage('assets/image_icon/icon_to_be_confirmed.png'),
                                  size: 28,
                                  color: Color(0xFFFF9900)
                                ),
                                Text('申请退货', style: TextStyle(color: Colors.grey[600]))
                              ],
                            ),
                          );
        _widgets.add(_windget);
        break;
      default:
       Widget _windget = Container(
                            child: Row(
                              children: <Widget>[
                                ImageIcon(
                                  AssetImage('assets/image_icon/icon_return_goods.png'),
                                  size: 28,
                                  color: Color(0xFF19BE6B)
                                ),
                                Text('退货成功', style: TextStyle(color: Colors.grey[600]))
                              ],
                            ),
                          );
        _widgets.add(_windget);
    }
    return _widgets;
  }

  _applyForReturnFun(BuildContext context, SupplierPageOrderBloc bloc, String id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          width: ScreenUtil().setWidth(700),
          height: ScreenUtil().setHeight(400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setWidth(700),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]
                    )
                  )
                ),
                child: Text(
                  '申请退货',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(32)
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey[200]
                  )
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: '请输入退货原因'
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              InkWell(
                onTap: () {
                  bloc.applyForReturn(id, context, _controller.text);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(70),
                  width: ScreenUtil().setWidth(680),
                  decoration: BoxDecoration(
                    color: Color(0xFF2B8CF0),
                    borderRadius: BorderRadius.circular(70)
                  ),
                  child: Text(
                    '确认退货',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}