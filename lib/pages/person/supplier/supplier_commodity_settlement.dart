import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sujian_select/flutter_select.dart';
import 'package:flutter_sujian_select/select_item.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_receiving_address_bloc.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/supplier_page_shoppingCar_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/person/person_info_receiving_address_add.dart';
import 'package:flutter_swcy/pages/person/person_info_receiving_address_page.dart';
import 'package:flutter_swcy/vo/person/receiving_address_vo.dart';
import 'package:flutter_swcy/vo/person/save_receiving_address_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';
import 'package:oktoast/oktoast.dart';

class SupplierCommoditySettlement extends StatelessWidget {
  final SupplierPageShoppingCarBloc _bloc;
  final String supplierName;
  SupplierCommoditySettlement(
    this._bloc,
    this.supplierName
  );
  @override
  Widget build(BuildContext context) {
    final PersonInfoReceivingAddressBloc _personInfoReceivingAddressBloc = BlocProvider.of<PersonInfoReceivingAddressBloc>(context);
    final ShareShopPageBloc _shareShopPageBloc = BlocProvider.of<ShareShopPageBloc>(context);
    _personInfoReceivingAddressBloc.getReceivingAddressListByUId(context);
    _shareShopPageBloc.getMyStorePage(context, pageSize: 100);
    _bloc.getCheckTrueSupplierCommoditys();
    ReceivingAddress receivingAddress;
    return Scaffold(
      appBar: AppBar(
        title: Text('结算'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: ScreenUtil().setWidth(750),
          child: Column(
            children: <Widget>[
              // 地址
              StreamBuilder(
                stream: _personInfoReceivingAddressBloc.receivingAddressVoStream,
                builder: (context, sanpshop) {
                  if (!sanpshop.hasData) {
                    return Container();
                  } else {
                    ReceivingAddressVo receivingAddressVo = sanpshop.data;
                    if (receivingAddressVo.data.length > 0) {
                      return StreamBuilder(
                        stream: _personInfoReceivingAddressBloc.receivingAddressIndexStream,
                        initialData: 0,
                        builder: (context, sanpshop) {
                          receivingAddress = receivingAddressVo.data[sanpshop.data];
                          return _buildAddressCard(receivingAddressVo.data[sanpshop.data], context, _personInfoReceivingAddressBloc);
                        },
                      );
                    } else {
                      return _buildAddAddressCard(context, _personInfoReceivingAddressBloc);
                    }
                  }
                },
              ),
              // 选择购买共享店
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context1){
                      return _buildSelectedShareStore(context, _shareShopPageBloc);
                    }
                  );
                },
                child: Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    width: ScreenUtil().setWidth(750),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              ImageIcon(
                                AssetImage('assets/image_icon/icon_shop.png'),
                                color: Colors.blue,
                              ),
                              SizedBox(width: ScreenUtil().setWidth(10)),
                              Text(
                                '共享店',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(32)
                                ),
                              )
                            ],
                          ),
                        ),
                        StreamBuilder(
                          stream: _shareShopPageBloc.myStorePageVoStream,
                          builder: (context, sanpshop) {
                            if (sanpshop.hasData) {
                              MyStorePageVo myStorePageVo = sanpshop.data;
                              _bloc.setMyStorePageItem(myStorePageVo.data.list[0]);
                              return StreamBuilder(
                                stream: _bloc.myStorePageVoStream,
                                builder: (context, sanpshop) {
                                  if (sanpshop.hasData) {
                                    MyStorePageItem myStorePageItem = sanpshop.data;
                                    return ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(myStorePageItem.photo),
                                      ),
                                      title: Text('${myStorePageItem.storeName}'),
                                      trailing: Icon(
                                        Icons.chevron_right,
                                        size: 38,
                                      ),
                                    );
                                  } else {
                                    return ListTile(
                                      title: Text('请选择购买门店'),
                                      trailing: Icon(
                                        Icons.chevron_right,
                                        size: 38,
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              return ListTile(
                                title: Text('请选择购买门店'),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  size: 38,
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // 供应商与商品商品
              StreamBuilder(
                stream: _bloc.tempCommodityInfoVoListStream,
                builder: (context, sanpshop) {
                  if (sanpshop.hasData) {
                    return _buildSupplierAndCommodityInfoVoList(sanpshop.data);
                  } else {
                    return Container();
                  }
                },
              ),
              // 支付方式
              _buildPayType()
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setHeight(90),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StreamBuilder(
                initialData: 0.0,
                stream: _bloc.allPriceStream,
                builder: (context, sanpshop) {
                  return Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      '￥${sanpshop.data}', 
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: ScreenUtil().setSp(36),
                      ),
                    ),
                  );
                },
              ),
              InkWell(
                onTap: () {
                  if (receivingAddress == null) {
                    showToast('请添加收货地址');
                    return;
                  }
                  _bloc.supplierWxPayListen(context);
                  _bloc.supplierUnifiedOrderWxPay(context, receivingAddress.id);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10.0),
                  width: ScreenUtil().setWidth(180),
                  height: ScreenUtil().setHeight(70),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red
                    ),
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3.0)
                  ),
                  child: Text(
                    '提交订单',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 默认获取第一个收货地址
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

  /// 支付方式
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

  /// 商家以及商品列表
  Widget _buildSupplierAndCommodityInfoVoList(List<CommodityInfoVo> commodityInfoVos) {
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
                  AssetImage('assets/image_icon/icon_supplier.png'),
                  color: Colors.blue,
                ),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Text(
                  supplierName,
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          commodityInfoVos[index].cover,
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setWidth(100),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(commodityInfoVos[index].name),
                          Text("商品单价： ￥${commodityInfoVos[index].price}"),
                        ],
                      ),
                      Text("数量： ${commodityInfoVos[index].count}"),
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

  /// 暂无收货地址时
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
            if (val != null) {
              SaveReceivingAddressData saveReceivingAddressData = val;
              personInfoReceivingAddressBloc.updateReceivingAddressList(saveReceivingAddressData);
            }
          });
        },
      ),
    );
  }

  /// 行业选择器
  Widget _buildSelectedShareStore(BuildContext context, ShareShopPageBloc _shareShopPageBloc) {
    return StreamBuilder(
      stream: _shareShopPageBloc.myStorePageVoStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return Container(
            height: ScreenUtil().setHeight(450),
            child: showLoading(),
          );
        } else {
          MyStorePageVo _myStorePageVo = sanpshop.data;
          return Container(
            height: ScreenUtil().setHeight(450),
            child: SingleChildScrollView(
              child: SelectGroup<int>(
                index: 0,
                direction: SelectDirection.vertical,
                space: EdgeInsets.all(10),
                selectColor: Colors.blue,
                items: _myStorePageVo.data.list.map((item) {
                  return SelectItem(label: item.storeName, value: item.id);
                }).toList(),
                onSingleSelect: (int index){
                  _bloc.setMyStorePageItem(_myStorePageVo.data.list[index]);
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }
      },
    );
  }
}

