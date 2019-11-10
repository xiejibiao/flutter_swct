import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/order/share_shop_page_order_admin_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/vo/order/get_shop_order_detail_by_orderId_vo.dart';

class ShareShopPageOrderAdminDetail extends StatelessWidget {
  final ShareShopPageOrderAdminBloc _bloc;
  final String _orderId;
  ShareShopPageOrderAdminDetail(
    this._bloc,
    this._orderId
  );
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _bloc.getShopOrderDetailByOrderId(_orderId, context);
    return Scaffold(
      appBar: AppBar(
        title: Text('共享店订单详情'),
      ),
      body: StreamBuilder(
        stream: _bloc.getShopOrderDetailByOrderIdVoStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            GetShopOrderDetailByOrderIdVo getShopOrderDetailByOrderIdVo = sanpshop.data;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  /// 昵称头像，收货信息
                  Card(
                    child: Container(
                      width: ScreenUtil().setWidth(750),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: ScreenUtil().setWidth(25),
                                  color: Colors.grey[200]
                                )
                              )
                            ),
                            width: ScreenUtil().setWidth(750),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 42,
                                  backgroundImage: NetworkImage(getShopOrderDetailByOrderIdVo.data.avatar),
                                ),
                                Text(
                                  getShopOrderDetailByOrderIdVo.data.nikeName,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(42)
                                  ),
                                )
                              ],
                            )
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('收货人信息', style: TextStyle(fontSize: ScreenUtil().setSp(36))),
                                Text('收  货  人  ${getShopOrderDetailByOrderIdVo.data.receivingAddressVo.receiverName}'),
                                Text('预留电话  ${getShopOrderDetailByOrderIdVo.data.receivingAddressVo.receiverPhone}'),
                                Text('省  市  区  ${getShopOrderDetailByOrderIdVo.data.receivingAddressVo.provinceName}${getShopOrderDetailByOrderIdVo.data.receivingAddressVo.cityName}${getShopOrderDetailByOrderIdVo.data.receivingAddressVo.areaName}'),
                                Text('详细地址  ${getShopOrderDetailByOrderIdVo.data.receivingAddressVo.address}')
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  /// 商品了列表
                  Stack(
                    children: <Widget>[
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(top: 10.0),
                          width: ScreenUtil().setWidth(750),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text('商品列表', style: TextStyle(fontSize: ScreenUtil().setSp(36))),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: getShopOrderDetailByOrderIdVo.data.orderDetailListVos.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: 
                                        Border(
                                          bottom: (index + 1) == getShopOrderDetailByOrderIdVo.data.orderDetailListVos.length ?
                                            BorderSide.none :
                                            BorderSide(
                                              color: Colors.grey
                                            )
                                        )
                                    ),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          getShopOrderDetailByOrderIdVo.data.orderDetailListVos[index].cover,
                                          width: ScreenUtil().setWidth(110),
                                          height: ScreenUtil().setWidth(110),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(getShopOrderDetailByOrderIdVo.data.orderDetailListVos[index].commodityName),
                                      subtitle: Text('${getShopOrderDetailByOrderIdVo.data.orderDetailListVos[index].price}'),
                                      trailing: Text('x ${getShopOrderDetailByOrderIdVo.data.orderDetailListVos[index].num}'),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: _getStatusIcon(getShopOrderDetailByOrderIdVo.data.orderEssentialInfoVo.status),
                      )
                    ],
                  ),
                  /// 发货 / 确认订单按钮
                  getShopOrderDetailByOrderIdVo.data.orderEssentialInfoVo.status == 1 || getShopOrderDetailByOrderIdVo.data.orderEssentialInfoVo.status == 2 ?
                    _getStatusButton(getShopOrderDetailByOrderIdVo.data.orderEssentialInfoVo.status, context, _bloc):
                    Container()
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _getStatusIcon (int status) {
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

  Widget _getStatusButton(int status, BuildContext context, ShareShopPageOrderAdminBloc _bloc) {
    Widget _widget;
    switch (status) {
      case 1:
          _widget = _buildStatusButtonContainer(Color(0xFFFF9900), '确认订单', context, 1, _bloc);
        break;
      default:
         _widget = _buildStatusButtonContainer(Color(0xFF3399FF), '发货', context, 2, _bloc);
    }
    return _widget;
  }

  Widget _buildStatusButtonContainer(Color color, String title, BuildContext context, int status, ShareShopPageOrderAdminBloc _bloc) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(
          color: color
        )
      ),
      child: InkWell(
        onTap: () => status == 1 ? _bloc.confirmationOfOrder(_orderId, context) : _showConfirmShipmentModel(context, _bloc),
        child: Container(
          alignment: Alignment.center,
          height: ScreenUtil().setHeight(65),
          child: Text(title, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  _showConfirmShipmentModel(BuildContext context, ShareShopPageOrderAdminBloc _bloc) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setHeight(400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(750),
                height: ScreenUtil().setHeight(50),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: ScreenUtil().setWidth(1)
                    )
                  )
                ),
                child: Text(
                  '发货确认',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36)
                  ),
                )
              ),
              Card(
                child: Container(
                  height: ScreenUtil().setHeight(300),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: '物流单号/物流方式'
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _bloc.confirmShipment(_orderId, _controller.text, context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: ScreenUtil().setHeight(65),
                          width: ScreenUtil().setWidth(700),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(32.0)
                          ),
                          child: Text(
                            '确认发货',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      )
                    ],
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