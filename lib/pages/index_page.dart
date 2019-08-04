import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/index_page_bloc.dart';
import 'package:flutter_swcy/pages/home_page.dart';
import 'package:flutter_swcy/pages/shop_page.dart';
import 'package:flutter_swcy/pages/order_page.dart';
import 'package:flutter_swcy/pages/person_page.dart';

class IndexPage extends StatelessWidget {
  // 底部导航
  final List<BottomNavigationBarItem> _bottomTabs = [
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
  final List<Widget> _bottomTabView = [
    HomePage(),
    ShopPage(),
    OrderPage(),
    PersonPage()
  ];

  
  @override
  Widget build(BuildContext context) {
    final IndexPageBloc _bloc = BlocProvider.of<IndexPageBloc>(context);
    return StreamBuilder(
      initialData: 0,
      stream: _bloc.indexPageStream,
      builder: (context, sanpshop) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
          body: IndexedStack(
            index: sanpshop.data,
            children: _bottomTabView,
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedFontSize: ScreenUtil().setSp(26),
            unselectedFontSize: ScreenUtil().setSp(26),
            items: _bottomTabs,
            type: BottomNavigationBarType.fixed,
            currentIndex: sanpshop.data,
            onTap: (index) {
              _bloc.thisCurrentIndex(index);
            },
          ),
        );
      },
    );
  }
}