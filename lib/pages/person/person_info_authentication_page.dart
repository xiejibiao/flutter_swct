import 'package:flutter/material.dart';
import 'person_info_authentication_page_already.dart';
import 'person_info_authentication_page_not.dart';

class PersonInfoAuthenticationPage extends StatelessWidget {
  final bool authentication; // 0 未认证， 1 已认证
  PersonInfoAuthenticationPage(
    this.authentication
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('实名认证'),
      ),
      body: authentication ? PersonInfoAuthenticationPageAlready() : PersonInfoAuthenticationPageNot(),
    );
  }
}