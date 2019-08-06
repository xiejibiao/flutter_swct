import 'package:flutter/material.dart';

class PersonAchievementPageHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Column(
          children: <Widget>[
            _buildItem('assets/image_icon/icon_achievement.png', '总业绩', 25000),
            _buildItem('assets/image_icon/icon_share.png', '总分享业绩', 100000),
            _buildItem('assets/image_icon/icon_create.png', '总创业业绩', 150000)
          ],
        ),
      ),
    );
  }

  Widget _buildItem (iconPath, title, sum) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 32.0,
      ),
      title: Text(title),
      trailing: Text('$sum'),
    );
  }
}