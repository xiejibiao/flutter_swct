import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/vo/supplier/supplier_order_page_vo.dart';

class SupplierPageOrderDetails extends StatelessWidget {
  final SupplierOrderPageVoList _supplierOrderPageVoList;
  SupplierPageOrderDetails(
    this._supplierOrderPageVoList
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '共享店',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(32)
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            _supplierOrderPageVoList.storeInfoVo.photo,
                            width: ScreenUtil().setWidth(100),
                            height: ScreenUtil().setWidth(100),
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(_supplierOrderPageVoList.storeInfoVo.storeName),
                        trailing: RichText(
                          text: TextSpan(
                            text: '总价格: ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: '￥${_supplierOrderPageVoList.money}',
                                style: TextStyle(color: Colors.red),
                              )
                            ]
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '供应商',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(32)
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            _supplierOrderPageVoList.supplierInfoVo.photo,
                            width: ScreenUtil().setWidth(100),
                            height: ScreenUtil().setWidth(100),
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(_supplierOrderPageVoList.supplierInfoVo.name),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '收货地址',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(32)
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text('收件人: ${_supplierOrderPageVoList.receivingAddressVo.receiverName}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('联系电话: ${_supplierOrderPageVoList.receivingAddressVo.receiverPhone}'),
                            Text('收货地址: ${_supplierOrderPageVoList.receivingAddressVo.provinceName}${_supplierOrderPageVoList.receivingAddressVo.cityName}${_supplierOrderPageVoList.receivingAddressVo.areaName}${_supplierOrderPageVoList.receivingAddressVo.address}'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Text(
                      '商品明细',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(32)
                      )  
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _supplierOrderPageVoList.supplierOrderDetailInfoVos.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(750),
                          height: ScreenUtil().setHeight(120),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                _supplierOrderPageVoList.supplierOrderDetailInfoVos[index].cover,
                                width: ScreenUtil().setWidth(100),
                                height: ScreenUtil().setWidth(100),
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(_supplierOrderPageVoList.supplierOrderDetailInfoVos[index].commodityName),
                            subtitle: Text('商品单价: ￥${_supplierOrderPageVoList.supplierOrderDetailInfoVos[index].price}'),
                            trailing: Text('数量: * ${_supplierOrderPageVoList.supplierOrderDetailInfoVos[index].num}'),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.all(10.0),
              width: ScreenUtil().setWidth(750),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getStatusStr(_supplierOrderPageVoList.status),
                  Text('支付时间  ' + DateUtil.getDateStrByMs(_supplierOrderPageVoList.payTime)),
                  Text('支付方式  ${_supplierOrderPageVoList.payChannel}'),
                  Text('交易单号  ${_supplierOrderPageVoList.payNum}'),
                  Text('订单编号  ${_supplierOrderPageVoList.id}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getStatusStr (int status) {
    Widget _widget;
    switch (status) {
      case 1:
        _widget = _buildStatusContainer('assets/image_icon/icon_money1.png', Color(0xFF2B8CF0), '已支付');
        break;
      case 2:
        _widget = _buildStatusContainer('assets/image_icon/icon_to_be_shipped.png', Color(0xFF2B8CF0), '待发货');
        break;
      case 3:
        _widget = _buildStatusContainer('assets/image_icon/icon_received_goods.png', Color(0xFF2B8CF0), '已发货');
        break;
      case 4:
        _widget = _buildStatusContainer('assets/image_icon/icon_shipped.png', Color(0xFF19BE6B), '已收货');
        break;
      case 5:
        _widget = _buildStatusContainer('assets/image_icon/icon_to_be_confirmed.png', Color(0xFFFF9900), '申请退货');
        break;
      default:
        _widget = _buildStatusContainer('assets/image_icon/icon_return_goods.png', Color(0xFF19BE6B), '退货成功');
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