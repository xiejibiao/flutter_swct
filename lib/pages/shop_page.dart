import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search.dart';
import 'package:flutter_swcy/pages/shop/shop_page_shop_item_bar.dart';
import 'package:flutter_swcy/vo/shop/store_industry_list_vo.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShopPageBloc _bloc = BlocProvider.of<ShopPageBloc>(context);
    _bloc.initAMapLocation();
    _bloc.getLocation();
    _bloc.getStoreIndustryList();
    return StreamBuilder(
      stream: _bloc.locationStream,
      builder: (context, sanpshop) {
        if (sanpshop.hasData) {
          return DefaultTabController(
            length: _bloc.storeIndustryListVo.data.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text('商家'),
                actions: _buildActions(context, _bloc.location),
                bottom: _buildTabBarBottom(_bloc.storeIndustryListVo),
              ),
              body: TabBarView(
                children: _bloc.storeIndustryListVo.data.map((item) {
                  return ShopPageShopItemBar(item.id, '${_bloc.location.latitude}', '${_bloc.location.longitude}');
                }).toList(),
              ),
            ),
          );
        } else {
          return showLoading();
        }
      },
    );
  }

  List<Widget> _buildActions(BuildContext context, Location location) {
    List<Widget> widgets = [
      InkWell(
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => ShopPageSearch('${location.latitude}', '${location.longitude}')));
        },
        child: Padding(
          child: ImageIcon(AssetImage('assets/image_icon/icon_search.png'), size: 20),
          padding: EdgeInsets.only(left: 24, right: 24),
        ),
      ),
      InkWell(
        onTap: () {
          print('点击了定位~~');
        },
        child: Row(
          children: <Widget>[
            Text(location.city),
            Icon(Icons.pin_drop)
          ],
        ),
      )
    ];
    return widgets;
  }

  Widget _buildTabBarBottom(StoreIndustryListVo storeIndustryListVo) {
    return TabBar(
      isScrollable: true,
      labelStyle: TextStyle(
        fontSize: ScreenUtil().setSp(32),
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: ScreenUtil().setSp(32)
      ),
      tabs: storeIndustryListVo.data.map((data) {
        return Tab(text: '${data.name}');
      }).toList(),
    );
  }
}