import 'package:flutter/material.dart';
import 'package:flutter_swcy/common/commodity_detail_util.dart';

class ShopPagesShopPageEvaluateDetails extends StatelessWidget {
  final String details;
  ShopPagesShopPageEvaluateDetails(
    this.details
  );
  @override
  Widget build(BuildContext context) {
    List<Widget> _detailWidgets = getDetailWidgets(details: details);
    return Scaffold(
      appBar: AppBar(
        title: Text('商品详情'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _detailWidgets,
        ),
      ),
    );
  }
}