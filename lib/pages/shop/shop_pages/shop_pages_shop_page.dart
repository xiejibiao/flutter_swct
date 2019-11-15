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
                unselectedItemColor: Colors.blue,
                unselectedFontSize: 14,
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
                      // Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(child: ShopPagesShopPageShopingcar(id: id, shopName: shopName), bloc: ShopPagesBloc()))).then((val) {
                      //   _bloc.getCommodityInfoVos();
                      // });
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => ShopPagesShopPageShopingcar(id: id, shopName: shopName, shopPagesBloc: _bloc)));
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(sanpshop.data ? Icons.star : Icons.star_border, color: sanpshop.data ? Colors.red : Colors.blue),
                Text(sanpshop.data ? '已收藏' : '收藏', style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(28)))
              ],
            );
          },
        ),
        title: Container()
      ),
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
              stream: bloc.allCommodityCountStream,
              builder: (context, sanpshop) {
                return Positioned(
                  top: 0,
                  right: 35,
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
    ];

    return _bottomNavigationBarItems;
  }
}