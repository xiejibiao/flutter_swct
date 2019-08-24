import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search.dart';
import 'package:flutter_swcy/pages/shop/shop_page_shop_item_bar.dart';

class ShopPage extends StatefulWidget {
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin{
  TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  var currentPage = 0;
  var isPageCanChanged = true;
  var tabBarList = [];

  @override
  void initState() { 
    super.initState();
    initTabData();
  }

  initTabData() {
    ShopPageBloc().getStoreIndustryListFromCache().then((data) {
      tabBarList = data;
      mTabController = TabController(
        length: data.length,
        vsync: this,
      );
      mTabController.addListener(() {//TabBar的监听
        if (mTabController.indexIsChanging) {//判断TabBar是否切换
          onPageChange(mTabController.index, p: mPageController);
        }
      });
    });
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {//判断是哪一个切换
      isPageCanChanged = false;
      await mPageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);//等待pageview切换完毕,再释放pageivew监听
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index);//切换Tabbar
    }
  }


  @override
  Widget build(BuildContext context) {
    final ShopPageBloc _bloc = BlocProvider.of<ShopPageBloc>(context);
    _bloc.initAMapLocation();
    _bloc.getLocation();
    return StreamBuilder(
      stream: _bloc.locationStream,
      builder: (context, sanpshop) {
        if (sanpshop.hasData) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('商家'),
              actions: _buildActions(context, _bloc.location),
            ),
            body: Column(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: 38.0,
                  child: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.amber[100],
                    controller: mTabController,
                    labelStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(32)
                    ),
                    tabs: tabBarList.map((item) {
                      return Tab(
                        text: item.name,
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: tabBarList.length,
                    onPageChanged: (index) {
                      if (isPageCanChanged) {//由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
                        onPageChange(index);
                      }
                    },
                    controller: mPageController,
                    itemBuilder: (BuildContext context, int index) {
                      return ShopPageShopItemBar(tabBarList[index].id, '${_bloc.location.latitude}', '${_bloc.location.longitude}');
                    },
                  ),
                )
              ],
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
}