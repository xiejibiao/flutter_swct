import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonPageItemButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Wrap(
        spacing: 3,
        children: <Widget>[
          _item(context, Icons.attach_money, '我的资产', null),
          _item(context, Icons.group, '我的团队', null),
          _item(context, Icons.store, '我的盟店', null),
          _item(context, Icons.star, '收藏', null),
          _item(context, Icons.textsms, '消息', null),
          _item(context, Icons.insert_chart, '我的业绩', null),
          _item(context, Icons.sms_failed, '意见与建议', null),
          _item(context, Icons.store, '我的实体店', null),
          _item(context, Icons.extension, '关于', null),
        ],
      ),
    );
  }

  Widget _item (BuildContext context, IconData icon, String title, Widget path) {
    return Container(
      width: ScreenUtil().setWidth(230),
      height: ScreenUtil().setHeight(180),
      child: InkWell(
        highlightColor: Colors.grey[100],
        splashColor: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Icon(icon, size: 40.0, color: Colors.blue),
            Text(title, style: TextStyle( fontSize: ScreenUtil().setSp(26), color: Colors.black54))
          ],
        ),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => path));
        },
      ),
    );
  }
}