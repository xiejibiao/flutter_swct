import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/common/order_default_image.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/order/order_item.dart';

class OrderPage extends StatelessWidget {
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
              return EasyRefresh.custom(
                header: BallPulseHeader(),
                footer: BallPulseFooter(
                  enableHapticFeedback: true,
                  enableInfiniteLoad: false
                ),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                        return OrderItem(_bloc.orderPageVo.data.list[index]);
                      },
                      childCount: _bloc.orderPageVo.data.list.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _bloc.isEnd ? TheEndBaseline() : Container(),
                  )
                ],
                onLoad: () async {
                  await _bloc.loadMoreOrderPage(context);
                },
                onRefresh: () async {
                  await _bloc.getOrderPage(context, true);
                },
              );
            }
          }
        },
      ),
    );
  }
}