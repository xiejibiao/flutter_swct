import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';


class PersonSmsPageNoticeSms extends StatefulWidget {
  _PersonSmsPageNoticeSmsState createState() => _PersonSmsPageNoticeSmsState();
}

class _PersonSmsPageNoticeSmsState extends State<PersonSmsPageNoticeSms> {
  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    _bloc.getnoticeMessage(context);
    return StreamBuilder(
      stream: _bloc.noticeSmsVoStream,
      builder: (context, sanpshop) {
        if (sanpshop.hasData) {
          if (_bloc.noticeSmsVo.data.list.length == 0) {
            return Center(
              child: ImageIcon(AssetImage('assets/image_icon/icon_message.png'), size: 200, color: Colors.grey),
            );
          } else {
            return EasyRefresh.custom(
              footer: BallPulseFooter(
                enableHapticFeedback: true,
                enableInfiniteLoad: false
              ),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            print('个人消息，点击了：${_bloc.noticeSmsVo.data.list[index].id}');
                          },
                          title: Text(_bloc.noticeSmsVo.data.list[index].title),
                          subtitle: Text(DateUtil.getDateStrByMs(_bloc.noticeSmsVo.data.list[index].createTime)),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _buildStatusText(_bloc.noticeSmsVo.data.list[index].hadRead)
                            ],
                          ),
                          trailing: Text('阅读量：${_bloc.noticeSmsVo.data.list[index].readingVolume}'),
                        ),
                      );
                    },
                    childCount: _bloc.noticeSmsVo.data.list.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _bloc.noticeSmsIsEnd ? TheEndBaseline() : Container(),
                )
              ],
              onLoad: () async {
                await _bloc.getnoticeMessageLoadMore(context);
              },
            );
          }
        } else {
          return showLoading();
        }
      },
    );
  }

  Text _buildStatusText (int status) {
    if (status == 0) {
      return Text(
        '未读',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16.0
        ),
      );
    }
    return Text(
      '已读',
      style: TextStyle(
        color: Colors.green,
        fontSize: 16.0
      ),
    );
  }
}