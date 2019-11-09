import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/common/order_default_image.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/order/order_item.dart';
import 'package:flutter_swcy/vo/order/order_vo.dart';

class OrderPage extends StatelessWidget {
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  final GlobalKey<RefreshHeaderState> _refreshHeaderStateKey = GlobalKey<RefreshHeaderState>();
  @override
  Widget build(BuildContext context) {
    final OrderPageBloc _bloc = BlocProvider.of<OrderPageBloc>(context);
    _bloc.getOrderPage(context, false);
    return Scaffold(
      appBar: AppBar(
        title: Text('订单'),
      ),
      body: StreamBuilder(
        stream: _bloc.orderPageStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            if (_bloc.orderPageVo.data.list.length == 0) {
              return InkWell(
                onTap: () {
                  _bloc.getOrderPage(context, true);
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OrderDefaultImage(),
                      Text('点击刷新', style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              );
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
                refreshHeader: ClassicsHeader(
                  key: _refreshHeaderStateKey,
                  bgColor: Colors.blue[200],
                  textColor: Colors.white,
                  moreInfoColor: Colors.white,
                  showMore: true,
                  moreInfo: '上次刷新 %T',
                  refreshText: '加载中...',
                  refreshReadyText: '松手刷新...',
                  refreshingText: '刷新完成...',
                  refreshedText: '刷新完成...',
                ),
                child: ListView(
                  children: <Widget>[
                    _orderList(_bloc.orderPageVo.data.list.length, _bloc.orderPageVo.data.list),
                    _bloc.isEnd ? TheEndBaseline() : Text('')
                  ],
                ),
                loadMore: () {
                  return _bloc.loadMoreOrderPage(context);
                },
                onRefresh: () {
                  return _bloc.getOrderPage(context, true);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _orderList(int length, List<OrderVo> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: length,
      itemBuilder: (context, index) {
        return OrderItem(list[index]);
      },
    );
  }
}