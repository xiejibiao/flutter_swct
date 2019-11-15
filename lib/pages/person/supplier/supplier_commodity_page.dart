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

class SupplierCommodityPage extends StatelessWidget {
  final SupplierInfoVo supplierInfoVo;
  SupplierCommodityPage(
    this.supplierInfoVo
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
    _supplierPageShoppingCarBloc.initSupplierKEY('${supplierInfoVo.id}');
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
                    SupplierCommodityPageCommodity(_listSupplierCommodityPageVoData, _bloc, _supplierPageShoppingCarBloc),
                    SupplierCommodityPageDetail(supplierInfoVo.description)
                  ],
                );
              }
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
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
                        right: 70,
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
            } else {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => SupplierPageShoppingCar(_supplierPageShoppingCarBloc, supplierInfoVo.name)));
            }
          },
        ),
      ),
    );
  }

  _supplierAMapNavi() {
    double lat = double.parse(supplierInfoVo.lat);
    double lng = double.parse(supplierInfoVo.lng);
    AMapNavi().startNavi(lat: lat, lon: lng, naviType: AMapNavi.drive);
  }
}