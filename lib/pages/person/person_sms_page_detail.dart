import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';

class PersonSmsPageDetail extends StatelessWidget {
  final String content;
  final bool isPersonSms;
  PersonSmsPageDetail(
    this.content,
    this.isPersonSms
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isPersonSms ? Text('消息详情') : Text('盟店详情'),
      ),
      body: content != null ? 
            Html(
              data: content,
            ) :
            ShopPageSearchDefaultPage()
    );
  }
}