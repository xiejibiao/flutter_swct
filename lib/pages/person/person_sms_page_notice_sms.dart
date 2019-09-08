import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/vo/person/sms_vo.dart';


class PersonSmsPageNoticeSms extends StatefulWidget {
  _PersonSmsPageNoticeSmsState createState() => _PersonSmsPageNoticeSmsState();
}

class _PersonSmsPageNoticeSmsState extends State<PersonSmsPageNoticeSms> {
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
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
                    itemCount: _bloc.noticeSmsVo.data.list.length,
                    itemBuilder: (context, index) {
                      return _buildItem(_bloc.noticeSmsVo.data.list[index]);
                    },
                  ),
                  _bloc.noticeSmsIsEnd ? TheEndBaseline() : Text('')
                ],
              ),
              loadMore: () {
                return _bloc.getnoticeMessageLoadMore(context);
              },
            );
          }
        } else {
          return showLoading();
        }
      },
    );
  }

  Widget _buildItem (Sms sms) {
    return Card(
      child: ListTile(
        onTap: () {
          print('个人消息，点击了：${sms.id}');
        },
        title: Text(sms.title),
        subtitle: Text(DateUtil.getDateStrByMs(sms.createTime)),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildStatusText(sms.hadRead)
          ],
        ),
        trailing: Text('阅读量：${sms.readingVolume}'),
      ),
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