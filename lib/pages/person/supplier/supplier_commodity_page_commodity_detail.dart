import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SupplierCommodityPageCommodityDetail extends StatelessWidget {
  final String detail;
  SupplierCommodityPageCommodityDetail(
    this.detail
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品详情'),
      ),
      body: Html(
        data: detail,
      ),
    );
  }
}