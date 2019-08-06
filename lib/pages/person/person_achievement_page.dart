import 'package:flutter/material.dart';
import 'package:flutter_swcy/pages/person/person_achievement_page_head.dart';
import 'package:flutter_swcy/pages/person/person_achievement_page_list.dart';

class PersonAchievementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的业绩'),
      ),
      body: Column(
        children: <Widget>[
          PersonAchievementPageHead(),
          PersonAchievementPageList()
        ],
      ),
    );
  }
}