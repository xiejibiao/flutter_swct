import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/common/commodity_detail_util.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';

class ShopPagesShopPageEvaluateDetails extends StatelessWidget {
  final String details;
  ShopPagesShopPageEvaluateDetails(
    this.details
  );
  @override
  Widget build(BuildContext context) {
    List<Widget> _detailWidgets = TextUtil.isEmpty(details) ? [] : getDetailWidgets(details: details);
    return Scaffold(
      appBar: AppBar(
        title: Text('商品详情'),
      ),
      body: TextUtil.isEmpty(details) ? 
            ShopPageSearchDefaultPage() :
            SingleChildScrollView(
              child: Column(
                children: _detailWidgets,
              ),
            ),
    );
  }
}