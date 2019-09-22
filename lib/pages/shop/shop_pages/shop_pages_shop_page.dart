import 'package:amap_base/amap_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_details.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_shopingcar.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShopPagesShopPage extends StatelessWidget {
  final String shopName;
  final int id;
  ShopPagesShopPage(
    this.shopName,
    this.id
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
    final ShopPagesBloc _bloc = BlocProvider.of<ShopPagesBloc>(context);
    _bloc.setCommodityKey(id);
    _bloc.getShopTypeAndEssentialMessage(context, id, false);
    return DefaultTabController(
      length: 2,
      child: StreamBuilder(
        stream: _bloc.shopTypeAndEssentialMessageVoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            ShopTypeAndEssentialMessageVo shopTypeAndEssentialMessageVo = sanpshop.data;
            return Scaffold(
              appBar: AppBar(
                title: Text(shopName),
                bottom: TabBar(
                  tabs: _tabs,
                  unselectedLabelColor: Colors.black38,
                  indicatorColor: Colors.amber[100],
                  indicatorWeight: 2.0,
                )
              ),
              body: TabBarView(
                children: [
                  ShopPagesShopPageEvaluate(shopTypeAndEssentialMessageVo.data.commodityTypeList, id, _bloc, false),
                  ShopPagesShopPageDetails(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: _getBottomNavigations(_bloc),
                onTap: (index) {
                  switch (index) {
                    case 0:
                      _bloc.followAndCleanFollow(id, context);
                      break;
                    case 1:
                      double lat = double.parse(shopTypeAndEssentialMessageVo.data.swcyStoreEntity.lat);
                      double lng = double.parse(shopTypeAndEssentialMessageVo.data.swcyStoreEntity.lng);
                      AMapNavi().startNavi(lat: lat, lon: lng, naviType: AMapNavi.drive);
                      break;
                    default:
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(child: ShopPagesShopPageShopingcar(id: id, shopName: shopName), bloc: ShopPagesBloc()))).then((val) {
                        _bloc.getCommodityInfoVos();
                      });
                  }
                },
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('商家详情'),
              ),
              body: showLoading(),
            );
          }
        },
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavigations (ShopPagesBloc bloc) {
    List<BottomNavigationBarItem> _bottomNavigationBarItems = [
      BottomNavigationBarItem(
        icon: StreamBuilder(
          stream: bloc.isFollowStream,
          initialData: false,
          builder: (context, sanpshop) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(sanpshop.data ? Icons.star : Icons.star_border, color: sanpshop.data ? Colors.red : Colors.black),
                Text(sanpshop.data ? '已收藏' : '收藏', style: TextStyle(color: Colors.black))
              ],
            );
          },
        ),
        title: Container()
      ),
      BottomNavigationBarItem(
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.place, color: Colors.black),
            Text('地图', style: TextStyle(color: Colors.black))
          ],
        ),
        title: Container()
      ),
      BottomNavigationBarItem(
        icon: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.shopping_cart, color: Colors.black),
                Text('购物车', style: TextStyle(color: Colors.black))
              ],
            ),
            StreamBuilder(
              initialData: 0,
              stream: bloc.allCommodityCountStream,
              builder: (context, sanpshop) {
                return Positioned(
                  top: 0,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Text(
                      '${sanpshop.data}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(22)
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        title: Container()
      )
    ];

    return _bottomNavigationBarItems;
  }
}