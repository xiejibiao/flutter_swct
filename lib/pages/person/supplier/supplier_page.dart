import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/supplier_page_bloc.dart';
import 'package:flutter_swcy/bloc/supplier_page_order_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_page_list.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_page_order.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/supplier/get_supplier_page_vo.dart';

class SupplierPage extends StatefulWidget {
  @override
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final SupplierPageBloc _bloc = BlocProvider.of<SupplierPageBloc>(context);
    _bloc.getSupplierPage();
    return StreamBuilder(
      stream: _bloc.listSubplierPageVoStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('供应商'),
            ),
            body: showLoading(),
          );
        } else {
          List<SupplierPageVo> _listSupplierPageVo = sanpshop.data;
          if (_listSupplierPageVo.length == 0) {
            return Scaffold(
              appBar: AppBar(
                title: Text('供应商'),
              ),
              body: ShopPageSearchDefaultPage(),
            );
          } else {
            _tabController = TabController(length: _listSupplierPageVo.length, vsync: this, initialIndex: 0);
            return Scaffold(
              appBar: AppBar(
                title: Text('供应商'),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: SupplierPageOrderBloc(), child: SupplierPageOrder())));
                    },
                    icon: ImageIcon(
                      AssetImage('assets/image_icon/icon_order.png')
                    ),
                  )
                ],
                bottom: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  indicatorColor: Colors.amber[100],
                  labelStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(32),
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(32)
                  ),
                  tabs: _listSupplierPageVo.map((item) {
                    return Tab(
                      child: Text(item.name),
                    );
                  }).toList(),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: _listSupplierPageVo.map((item) {
                  if (item.infoVoLgmnPage.list.length == 0) {
                    return ShopPageSearchDefaultPage();
                  } else {
                    return SupplierPageList(item.infoVoLgmnPage, item.id, _bloc);
                  }
                }).toList(),
              ),
            );
          }          
        }
      },
    );
  }
}