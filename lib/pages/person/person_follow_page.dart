import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_follow_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/shop/shop_page_grid_view_item.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class PersonFollowPage extends StatelessWidget {
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    final PersonFollowPageBloc _bloc = BlocProvider.of<PersonFollowPageBloc>(context);
    _bloc.getMyFollowPage(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的关注'),
      ),
      body: StreamBuilder(
        stream: _bloc.shopDataStream,
        builder: (context, sanpshop) {
          if(sanpshop.hasData) {
            List<ShopData> list = sanpshop.data;
            if (list.length <= 0) {
              return ShopPageSearchDefaultPage();
            } else {
              return EasyRefresh(
                  refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    bgColor: Colors.blue[200],
                    textColor: Colors.white,
                    moreInfoColor: Colors.white,
                    showMore: true,
                    loadingText: '加载中...',
                    moreInfo: '上次加载 %T',
                    noMoreText: '加载完成...',
                    loadReadyText: '松手加载...',
                    loadText: '上拉加载更多...',
                  ),
                  child: ListView(
                    children: <Widget>[
                      ShopPageGridViewItem(list),
                      StreamBuilder(
                        initialData: false,
                        stream: _bloc.isEndStream,
                        builder: (context, sanpshop) {
                          if (sanpshop.data) {
                            return TheEndBaseline();
                          } else {
                            return Text('');
                          }
                        },
                      )
                    ],
                  ),
                  loadMore: () {
                    return _bloc.loadMoreMyFollowPage(context);
                  },
                );
            }
          } else {
            return showLoading();
          }
        },
      ),
    );
  }
}