import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/person/person_sms_page_detail.dart';

class PersonSmsPageMySms extends StatefulWidget {
  _PersonSmsPageMySmsState createState() => _PersonSmsPageMySmsState();
}

class _PersonSmsPageMySmsState extends State<PersonSmsPageMySms> {
  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    _bloc.getMyMessage(context);
    return StreamBuilder(
      stream: _bloc.mySmsVoStream,
      builder: (context, sanpshop) {
        if (sanpshop.hasData) {
          if (_bloc.mySmsVo.data.list.length == 0) {
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
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => PersonSmsPageDetail(_bloc.mySmsVo.data.list[index].content)));
                          },
                          title: Text(_bloc.mySmsVo.data.list[index].title),
                          subtitle: Text(DateUtil.getDateStrByMs(_bloc.mySmsVo.data.list[index].createTime)),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _buildStatusText(_bloc.mySmsVo.data.list[index].hadRead)
                            ],
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                      );
                    },
                    childCount: _bloc.mySmsVo.data.list.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _bloc.noticeSmsIsEnd ? TheEndBaseline() : Container(),
                )
              ],
              onLoad: () async {
                await _bloc.getMyMessageLoadMore(context);
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