import 'package:flutter/material.dart';
import 'package:flutter_swcy/pages/person/person_team_page_head.dart';
import 'package:flutter_swcy/pages/person/person_team_page_list.dart';
class PersonTeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('我的团队'),
        ),
        body: Column(
          children: <Widget>[
            PersonTeamPageHead(),
            PersonTeamPageList()
          ],
        ),
      )
    );
  }
}
