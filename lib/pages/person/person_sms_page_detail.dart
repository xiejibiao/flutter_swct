import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PersonSmsPageDetail extends StatelessWidget {
  final String content;
  PersonSmsPageDetail(
    this.content
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息详情'),
      ),
      body: Html(
        data: content,
      ),
    );
  }
}