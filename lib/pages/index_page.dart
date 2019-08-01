import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/pages/home_page.dart';
import 'package:flutter_swcy/pages/shop_page.dart';
import 'package:flutter_swcy/pages/order_page.dart';
import 'package:flutter_swcy/pages/person_page.dart';
import 'package:flutter_swcy/provide/index_page_provide.dart';
import 'package:provide/provide.dart';

class IndexPage extends StatelessWidget {
  // 底部导航
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/image_icon/icon_home.png')),
      title: Text('首页')
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/image_icon/icon_shop.png')),
      title: Text('商家')
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/image_icon/icon_order.png')),
      title: Text('订单')
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/image_icon/icon_person.png')),
      title: Text('我的')
    ),
  ];

  // 底部导航页
  final List<Widget> bottomTabView = [
    HomePage(),
    ShopPage(),
    OrderPage(),
    PersonPage()
  ];

  
  @override
  Widget build(BuildContext context) {
    return Provide<IndexPageProvide>(
      builder: (context, child, indexPageProvide) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
          body: IndexedStack(
            index: indexPageProvide.currentIndex,
            children: bottomTabView,
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedFontSize: ScreenUtil().setSp(26),
            unselectedFontSize: ScreenUtil().setSp(26),
            items: bottomTabs,
            type: BottomNavigationBarType.fixed,
            currentIndex: indexPageProvide.currentIndex,
            onTap: (index) {
              indexPageProvide.bottomNavigationBarIndex(index);
            },
          ),
        );
      },
    );
  }
}