import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/order_default_image.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/vo/person/store_flowing_vo.dart';

class PersonAssetsPageFlowing extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    _bloc.getStoreFlowing(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('共享店收益')
      ),
      body: StreamBuilder(
        stream: _bloc.storeFlowingVoStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            StoreFlowingVo storeFlowingVo = sanpshop.data;
            if (storeFlowingVo.data.list.length == 0) {
              return OrderDefaultImage();
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
                        return Card(
                          child: ListTile(
                            title: Text('支付单号：${storeFlowingVo.data.list[index].payNo}'),
                            subtitle: Text(DateUtil.getDateStrByMs(storeFlowingVo.data.list[index].createTime)),
                            trailing: Text('${storeFlowingVo.data.list[index].payeeMoney}'),
                          )
                        );
                      },
                      childCount: storeFlowingVo.data.list.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _bloc.isEnd ? TheEndBaseline() : Container(),
                  )
                ],
                onLoad: () async {
                  await _bloc.loadStoreFlowing(context);
                },
                onRefresh: () async {
                  await _bloc.getStoreFlowing(context);
                },
              );
            }
          }
      })
    );
  }
}