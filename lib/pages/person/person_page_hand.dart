import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/pages/person/person_info_page.dart';
import 'package:flutter_swcy/vo/person/person_vo.dart';

class PersonPageHand extends StatelessWidget {
  final PersonVo personVo;
  PersonPageHand(
    this.personVo
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => PersonInfoPage()));
        },
        child: Card(
        elevation: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildAvatarAndNikeName(),
            _buildArrowRight()
          ],
        )
      ),
      ),
    );
  }

  // 头像与昵称信息
  Widget _buildAvatarAndNikeName () {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
      child: Row(
        children: <Widget>[
          _avatar(),
          SizedBox(width: ScreenUtil().setWidth(20)),
          _nikeName(),
        ],
      ),
    );
  }

  // 头像
  Widget _avatar () {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Image.network(
        personVo.data.lgmnUserInfo.avatar,
        height: ScreenUtil().setWidth(170),
        width: ScreenUtil().setWidth(170),
        fit: BoxFit.cover,
      ),
    );
  }

  // 昵称等信息
  Widget _nikeName () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(personVo.data.lgmnUserInfo.nikeName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(44)
          ),
        ),
        Text('团力级别: ${personVo.data.star}',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(32)
          ),
        ),
        Text('信用度: ${personVo.data.credit}',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(32)
          ),
        ),
      ],
    );
  }

  // 右箭头
  Widget _buildArrowRight () {
    return Padding(
      child: Icon(Icons.keyboard_arrow_right, size: 24.0),
      padding: EdgeInsets.all(10.0),
    );
  }
}