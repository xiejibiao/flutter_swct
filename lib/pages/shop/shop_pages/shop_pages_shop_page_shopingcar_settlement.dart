import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_receiving_address_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/person/person_info_receiving_address_add.dart';
import 'package:flutter_swcy/pages/person/person_info_receiving_address_page.dart';
import 'package:flutter_swcy/vo/person/receiving_address_vo.dart';
import 'package:flutter_swcy/vo/person/save_receiving_address_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';
import 'package:oktoast/oktoast.dart';

class ShopPagesShopPageShopingcarSettlement extends StatelessWidget {
  final int id;
  final String shopName;
  final ShopPagesBloc shopPagesBloc;
  ShopPagesShopPageShopingcarSettlement(
    {
      @required this.id,
      @required this.shopName,
      @required this.shopPagesBloc
    }
  );
  @override
  Widget build(BuildContext context) {
    final PersonInfoReceivingAddressBloc _bloc = BlocProvider.of<PersonInfoReceivingAddressBloc>(context);
    _bloc.getReceivingAddressListByUId(context);
    shopPagesBloc.getShopingCarCommoditysByIsCheckFormTrue();
    ReceivingAddress receivingAddress;
    return Scaffold(
      appBar: AppBar(
        title: Text('结算'),
      ),
      body: StreamBuilder(
        stream: _bloc.receivingAddressVoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            ReceivingAddressVo receivingAddressVo = sanpshop.data;
            if (receivingAddressVo.data.length > 0) {
              receivingAddress = receivingAddressVo.data[0];
            }
            return StreamBuilder(
              stream: shopPagesBloc.settlementCommodityInfoVoListStream,
              builder: (context, sanpshop) {
                if (sanpshop.hasData) {
                  Map<String, dynamic> map = sanpshop.data;
                  double price = map['price'];
                  return Stack(
                    children: <Widget>[
                      ListView(
                        children: <Widget>[
                          receivingAddressVo.data.length > 0 ? 
                            StreamBuilder(
                              initialData: 0,
                              stream: _bloc.receivingAddressIndexStream,
                              builder: (context, sanpshop) {
                                receivingAddress = receivingAddressVo.data[sanpshop.data];
                                return _buildAddressCard(receivingAddressVo.data[sanpshop.data], context, _bloc);
                              },
                            ) : _buildAddAddressCard(context, _bloc),
                          _buildShopAndCommodityInfoVoList(map['list']),
                          _buildPayType(),
                        ],
                      ),
                      _buildPriceAndPayButtom(price, shopPagesBloc, context, receivingAddress, id, map['list'])
                    ],
                  );
                } else {
                  return showLoading();
                }
              },
            );
          } else {
            return showLoading();
          }
        },
      )
    );
  }

  // 默认获取第一个收货地址
  Widget _buildAddressCard(ReceivingAddress receivingAddress, BuildContext context, PersonInfoReceivingAddressBloc personInfoReceivingAddressBloc) {
    return Card(
      child: ListTile(
        title: Row(
          children: <Widget>[
            SizedBox(
              child: Text(receivingAddress.receiverName),
              width: ScreenUtil().setWidth(150),
            ),
            Text(TextUtil.hideNumber(receivingAddress.receiverPhone)),
          ],
        ),
        subtitle: Text('${receivingAddress.provinceName}${receivingAddress.cityName}${receivingAddress.areaName}${receivingAddress.address}'),
        trailing: Icon(
          Icons.chevron_right,
          size: 38,
        ),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => PersonInfoReceivingAddressPage(personInfoReceivingAddressBloc: personInfoReceivingAddressBloc, isSelectedAddress: true)));
        },
      ),
    );
  }

  // 暂无收货地址时
  Widget _buildAddAddressCard(BuildContext context, PersonInfoReceivingAddressBloc personInfoReceivingAddressBloc) {
    return Card(
      child: ListTile(
        title: Text('请添加收货地址'),
        trailing: Icon(
          Icons.chevron_right,
          size: 38,
        ),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: PersonInfoReceivingAddressBloc(), child: PersonInfoReceivingAddress(null)))).then((val) {
            SaveReceivingAddressData saveReceivingAddressData = val;
            personInfoReceivingAddressBloc.updateReceivingAddressList(saveReceivingAddressData);
          });
        },
      ),
    );
  }

  // 商家以及商品列表
  Widget _buildShopAndCommodityInfoVoList(List<CommodityInfoVo> commodityInfoVos) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                ImageIcon(
                  AssetImage('assets/image_icon/icon_shop.png'),
                  color: Colors.blue,
                ),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Text(
                  shopName,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(32)
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: commodityInfoVos.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.network(
                        commodityInfoVos[index].cover,
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setWidth(100),
                        fit: BoxFit.fill,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(commodityInfoVos[index].name),
                          Text("商品单价： ￥${commodityInfoVos[index].price}"),
                        ],
                      ),
                      Text("数量： ￥${commodityInfoVos[index].count}"),
                    ],
                  ),
                )
              );
            },
          )
        ],
      ),
    );
  }

  // 支付方式
  Widget _buildPayType() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('支付方式'),
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ImageIcon(
                  AssetImage('assets/image_icon/icon_weixinPay.png'),
                  color: Colors.green,
                  size: 32,
                ),
              ],
            ),
            title: Text('微信支付'),
            subtitle: Text('微信安全支付'),
            trailing: Checkbox(
              value: true,
              checkColor: Colors.white,
              activeColor: Colors.blue,
              onChanged: (val) {},
            ),
          )
        ],
      ),
    );
  }

  // 支付金额，提交订单
  Widget _buildPriceAndPayButtom(double price, ShopPagesBloc shopPagesBloc, BuildContext context, ReceivingAddress receivingAddress, int storeId, List map) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: ScreenUtil().setWidth(750),
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                '￥$price',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                  color: Colors.red
                )
              ),
            ),
            InkWell(
              onTap: () {
                if (receivingAddress != null) {
                  shopPagesBloc.wxPayListen(context);
                  shopPagesBloc.wxPay(context, receivingAddress.id, storeId, map);
                } else {
                  showToast('请选择收货地址');
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: ScreenUtil().setHeight(90),
                width: ScreenUtil().setWidth(250),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Text(
                  '提交订单',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(28)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}