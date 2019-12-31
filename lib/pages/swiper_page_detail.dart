import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SwiperPageDetail extends StatelessWidget {
  final String content;
  SwiperPageDetail(
    this.content
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('广告详情'),
      ),
      body: Html(
        data: content,
      ),
    );
  }
}