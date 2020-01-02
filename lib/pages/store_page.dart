import 'package:amap_base/amap_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/store_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search.dart';
import 'package:flutter_swcy/pages/store/store_page_list.dart';
import 'package:flutter_swcy/vo/shop/news_get_page_store_vo.dart';

class StorePage extends StatefulWidget {
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with TickerProviderStateMixin {
  TabController _tabController;
  PageController mPageController = PageController(initialPage: 0);
  var isPageCanChanged = true;

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {//判断是哪一个切换
      isPageCanChanged = false;
      await mPageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);//等待pageview切换完毕,再释放pageivew监听
      isPageCanChanged = true;
    } else {
      _tabController.animateTo(index);//切换Tabbar
      _index = index;
    }
  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final StorePageBloc _storePageBloc = BlocProvider.of<StorePageBloc>(context);
    _storePageBloc.initAMapLocation();
    _storePageBloc.getLocation();
    return StreamBuilder(
      stream: _storePageBloc.locationStream,
      builder: (context, locationSanpshop) {
        if (!locationSanpshop.hasData) {
          return showLoading();
        } else {
          return StreamBuilder(
            stream: _storePageBloc.newsGetPageStoreVoStream,
            builder: (context, newsGetPageStoreVoSanpshop) {
              if (!newsGetPageStoreVoSanpshop.hasData) {
                return showLoading();
              } else {
                NewsGetPageStoreVo newsGetPageStoreVo = newsGetPageStoreVoSanpshop.data;
                _tabController = TabController(
                  length: newsGetPageStoreVo.data.length,
                  initialIndex: _index,
                  vsync: this
                );
                return Scaffold(
                  appBar: AppBar(
                    title: Text('商家'),
                    actions: _buildActions(context, locationSanpshop.data),
                    elevation: 0,
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        color: Colors.blue,
                        height: ScreenUtil().setHeight(76),
                        width: ScreenUtil().setWidth(750),
                        alignment: Alignment.center,
                        child: TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.amber[100],
                          controller: _tabController,
                          labelStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(32)
                          ),
                          tabs: newsGetPageStoreVo.data.map((item) {
                            return Tab(text: '${item.swcyIndustryEntity.name}');
                          }).toList(),
                          onTap: (index) {
                            if (_tabController.indexIsChanging) {//判断TabBar是否切换
                              onPageChange(_tabController.index, p: mPageController);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          itemCount: newsGetPageStoreVo.data.length,
                          onPageChanged: (index) {
                            if (isPageCanChanged) {//由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
                              onPageChange(index);
                            }
                          },
                          controller: mPageController,
                          itemBuilder: (BuildContext context, int index) {
                            return StorePageList(newsGetPageStoreVo.data[index].newsGetPageStoreDto, newsGetPageStoreVo.data[index].storeMap, newsGetPageStoreVo.data[index].swcyIndustryEntity.id);
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  /// 跳转搜索商品，定位Icon
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