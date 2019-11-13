import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/vo/person/person_team_list_vo.dart';

class PersonTeamPageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    _bloc.getMyTeam(context);
    return Expanded(
      child: StreamBuilder(
        stream: _bloc.personTeamListVoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            return EasyRefresh.custom(
                footer: BallPulseFooter(
                  enableHapticFeedback: true,
                  enableInfiniteLoad: false
                ),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                        return _buildItem(_bloc.personTeamListVo.data.list[index]);
                      },
                      childCount: _bloc.personTeamListVo.data.list.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _bloc.myTeamIsEnd ? TheEndBaseline() : Container(),
                  )
                ],
                onLoad: () async {
                  await _bloc.getMyTeamLoadMore(context);
                }
              );
          } else {
            return showLoading();
          }
        },
      ),
    );
  }

  Widget _buildItem (PersonTeamList personTeamList) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListTile(
          leading:  CircleAvatar(
            radius: 28.0,
            backgroundImage: NetworkImage('${personTeamList.avatar}')
          ),
          title: Text('${personTeamList.nikeName}'),
          subtitle: personTeamList.phone == null ? Container() : Text('${personTeamList.phone}'),
          trailing: Text('${personTeamList.achievement}'),
        ),
      ),
    );
  }
}