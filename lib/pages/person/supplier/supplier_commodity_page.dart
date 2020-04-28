import 'package:amap_base/amap_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/supplier_commodity_page_bloc.dart';
import 'package:flutter_swcy/bloc/supplier_page_shoppingCar_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_commodity_page_commodity.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_commodity_page_detail.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_page_shoppingCar.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/supplier/get_supplier_page_vo.dart';
import 'package:flutter_swcy/vo/supplier/supplier_commodity_page_vo.dart';
import 'package:url_launcher/url_launcher.dart';

class SupplierCommodityPage extends StatelessWidget {
  final SupplierInfoVo supplierInfoVo;
  final String storeId;
  final bool isPurchase;
  SupplierCommodityPage(
    this.supplierInfoVo,
    this.storeId,
    this.isPurchase
  );

  final List<Tab> _tabs = [
    Tab(
      child: Text(
        '商品',
        style: TextStyle (
          fontSize: 16.0,
          color: Colors.black
        )
      ),
    ),
    Tab(
      child: Text(
        '详情',
        style: TextStyle (
          fontSize: 16.0,
          color: Colors.black
        )
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final SupplierCommodityPageBloc _bloc = BlocProvider.of<SupplierCommodityPageBloc>(context);
    final SupplierPageShoppingCarBloc _supplierPageShoppingCarBloc = BlocProvider.of<SupplierPageShoppingCarBloc>(context);
    _bloc.getSupplierCommodityPage(supplierInfoVo.id);
    _supplierPageShoppingCarBloc.initSupplierKEY('${supplierInfoVo.id}', storeId);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('供应商详情'),
          bottom: TabBar(
            tabs: _tabs,
          ),
        ),
        body: StreamBuilder(
          stream: _bloc.listSubplierPageVoStream,
          builder: (context, sanpshop) {
            if (!sanpshop.hasData) {
              return showLoading();
            } else {
              List<SupplierCommodityPageVoData> _listSupplierCommodityPageVoData = sanpshop.data;
              if (_listSupplierCommodityPageVoData.length == 0) {
                return ShopPageSearchDefaultPage();
              } else {
                return TabBarView(
                  children: <Widget>[
                    SupplierCommodityPageCommodity(_listSupplierCommodityPageVoData, _bloc, _supplierPageShoppingCarBloc, isPurchase),
                    // SupplierCommodityPageCommodity(_listSupplierCommodityPageVoData, _bloc),
                    SupplierCommodityPageDetail(supplierInfoVo.description)
                  ],
                );
              }
            }
          },
        ),
        bottomNavigationBar: isPurchase ? BottomNavigationBar(
          unselectedItemColor: Colors.blue,
          unselectedFontSize: 14,
          items: [
            BottomNavigationBarItem(
              title: Column(
                children: <Widget>[
                  ImageIcon(
                    AssetImage('assets/image_icon/icon_receiving_address.png'),
                    color: Colors.blue,
                  ),
                  Text(
                    '导航',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28)
                    )
                  )
                ],
              ),
              icon: Container()
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.phone, color: Colors.blue),
                  Text('联系供应商', style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(28)))
                ],
              ),
              title: Container()
            ),
            BottomNavigationBarItem(
              title: Stack(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(375),
                    child: Column(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/image_icon/icon_shopping_car.png'),
                          color: Colors.blue,
                        ),
                        Text(
                          '购物车',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28)
                          ),
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                    initialData: 0,
                    stream: _supplierPageShoppingCarBloc.allCommodityCountStream,
                    builder: (context, sanpshop) {
                      return Positioned(
                        top: 0,
                        right: 50,
                        child: Text(
                          '${sanpshop.data}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenUtil().setSp(34)
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              icon: Container()
            )
          ],
          onTap: (index) {
            if (index == 0) {
              _supplierAMapNavi();
            } else if (index == 1) {
              _dial(supplierInfoVo.phone);
            } else {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => SupplierPageShoppingCar(_supplierPageShoppingCarBloc, supplierInfoVo.name, int.parse(storeId), supplierInfoVo.id)));
            }
          },
        ) : null
      ),
    );
  }

  _supplierAMapNavi() {
    double lat = double.parse(supplierInfoVo.lat);
    double lng = double.parse(supplierInfoVo.lng);
    AMapNavi().startNavi(lat: lat, lon: lng, naviType: AMapNavi.drive);
  }

  /// 拨打电话
  _dial(String phone) async {
    var url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '供应商填写电话错误 $url';
    }
  }
}