import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/order/order_item.dart';
import 'package:flutter_swcy/vo/order/order_vo.dart';

class OrderPage extends StatelessWidget {
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    final OrderPageBloc _bloc = BlocProvider.of<OrderPageBloc>(context);
    _bloc.getOrderPage(context);
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
              return Center(
                child: ImageIcon(AssetImage('assets/image_icon/icon_order.png')),
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
                child: ListView(
                  children: <Widget>[
                    _orderList(_bloc.orderPageVo.data.list.length, _bloc.orderPageVo.data.list),
                    _bloc.isEnd ? TheEndBaseline() : Text('')
                  ],
                ),
                loadMore: () {
                  _bloc.loadMoreOrderPage(context);
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