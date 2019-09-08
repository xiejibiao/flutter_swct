import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/my_widget.dart';
import 'package:flutter_swcy/pages/person/person_about_page.dart';
import 'package:flutter_swcy/pages/person/person_achievement_page.dart';
import 'package:flutter_swcy/pages/person/person_assets_page.dart';
import 'package:flutter_swcy/pages/person/person_complaints_page.dart';
import 'package:flutter_swcy/pages/person/person_sms_page.dart';
import 'package:flutter_swcy/pages/person/person_team_page.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page.dart';
import 'package:oktoast/oktoast.dart';

class PersonPageItemButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Wrap(
        spacing: 3,
        children: <Widget>[
          _item(context, Icons.attach_money, '我的资产', PersonAssetsPage()),
          _item(context, Icons.group, '我的团队', PersonTeamPage()),
          _item(context, Icons.store, '我的盟店', MyWidget()),
          // _item(context, Icons.store, '我的盟店', null),
          _item(context, Icons.star, '收藏', null),
          _item(context, Icons.textsms, '消息', PersonSmsPage()),
          _item(context, Icons.insert_chart, '我的业绩', PersonAchievementPage()),
          _item(context, Icons.sms_failed, '意见与建议', PersonComplaintsPage()),
          _item(context, Icons.store, '我的分享店', BlocProvider(bloc: ShareShopPageBloc(), child: ShareShopPage(),)),
          _item(context, Icons.extension, '关于', PersonAboutPage()),
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
          if (path == null) {
            showToast('请等待完善~~~~');
          } else {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => path));
          }
        },
      ),
    );
  }
}