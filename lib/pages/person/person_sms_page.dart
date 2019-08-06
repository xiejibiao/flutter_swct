import 'package:flutter/material.dart';
import 'package:flutter_swcy/pages/person/person_sms_page_my_sms.dart';
import 'package:flutter_swcy/pages/person/person_sms_page_notice_sms.dart';

class PersonSmsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('消息'),
          bottom: TabBar(
            unselectedLabelColor: Colors.black38,
            indicatorColor: Colors.amber[100],
            indicatorWeight: 2.0,
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PersonSmsPageMySms(),
            PersonSmsPageNoticeSms()
          ],
        ),
      ),
    );
  }

  final List<Tab> _tabs = [
    Tab(
      child: Text(
        '个人消息',
        style: TextStyle (
          fontSize: 16.0,
          color: Colors.black
        ),
      ),
    ),
    Tab(
      child: Text(
        '通知公告',
        style: TextStyle (
          fontSize: 16.0,
          color: Colors.black
        ),
      ),
    )
  ];
}