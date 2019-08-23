import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ShopPagesShopPageEvaluateDetails extends StatelessWidget {
  final String details;
  ShopPagesShopPageEvaluateDetails(
    this.details
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品详情'),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: details,
        ),
      ),
    );
  }
}