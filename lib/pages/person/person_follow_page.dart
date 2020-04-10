import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_follow_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/shop/shop_page_grid_view_item.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class PersonFollowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersonFollowPageBloc _bloc = BlocProvider.of<PersonFollowPageBloc>(context);
    _bloc.getMyFollowPage(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
      ),
      body: StreamBuilder(
        stream: _bloc.shopDataStream,
        builder: (context, sanpshop) {
          if(sanpshop.hasData) {
            List<ShopData> list = sanpshop.data;
            if (list.length <= 0) {
              return ShopPageSearchDefaultPage();
            } else {
              return EasyRefresh.custom(
                footer: BallPulseFooter(
                  enableHapticFeedback: true,
                  enableInfiniteLoad: false
                ),
                slivers: <Widget>[
                  ShopPageGridViewItem(list),
                  SliverToBoxAdapter(
                    child: StreamBuilder(
                      initialData: false,
                      stream: _bloc.isEndStream,
                      builder: (context, sanpshop) {
                        if (sanpshop.data) {
                          return TheEndBaseline();
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
                onLoad: () async {
                  await _bloc.loadMoreMyFollowPage(context);
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