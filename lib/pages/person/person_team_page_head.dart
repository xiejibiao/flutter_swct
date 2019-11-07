import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/vo/person/person_team_achievement_vo.dart';

class PersonTeamPageHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    _bloc.getMyTeamAchievement(context);
    return StreamBuilder(
      stream: _bloc.personTeamAchievementVoStream,
      builder: (context, sanpshop) {
        if (sanpshop.hasData) {
          PersonTeamAchievementVo personTeamAchievementVo = sanpshop.data;
          return Container(
            width: ScreenUtil().setWidth(750),
            child: Card(
              elevation: 5.0,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/image_icon/icon_team.png',
                      width: ScreenUtil().setWidth(140),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          _buildHeadTitle('我的团队', personTeamAchievementVo.data.teamSum),
                          _buildHeadTitle('团队业绩', personTeamAchievementVo.data.teamAchievement),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Text('');
        }
      },
    );
  }

  Widget _buildHeadTitle(String title, dynamic sum) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28)
        ),
      ),
      trailing: Text('$sum'),
    );
  }
}