import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/vo/person/person_team_list_vo.dart';

class PersonTeamPageList extends StatelessWidget {
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    _bloc.getMyTeam(context);
    return Expanded(
      child: StreamBuilder(
        stream: _bloc.personTeamListVoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _bloc.personTeamListVo.data.list.length,
                    itemBuilder: (context, index) {
                      return _buildItem(_bloc.personTeamListVo.data.list[index]);
                    },
                  ),
                  _bloc.myTeamIsEnd ? TheEndBaseline() : Text('')
                ],
              ),
              loadMore: () {
                return _bloc.getMyTeamLoadMore(context);
              },
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircleAvatar(
              radius: 28.0,
              backgroundImage: NetworkImage('${personTeamList.avatar}')
            ),
            Text('${personTeamList.nikeName}', style: TextStyle(fontSize: ScreenUtil().setSp(28))),
            Text('${personTeamList.phone}'),
            Text('${personTeamList.achievement}'),
          ],
        ),
      ),
    );
  }
}