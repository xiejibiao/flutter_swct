import 'package:flutter/material.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_details.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate.dart';

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

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.star_border, color: Colors.black),
          Text('收藏', style: TextStyle(color: Colors.black))
        ],
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
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.shopping_cart, color: Colors.black),
          Text('购物车', style: TextStyle(color: Colors.black))
        ],
      ),
      title: Container()
    ),
    BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(25.0)
        ),
        child: Text(
          '立即购买',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      title: Container()
    )
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            ShopPagesShopPageEvaluate(id),
            ShopPagesShopPageDetails(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: _bottomNavigationBarItems,
        ),
      ),
    );
  }
}