import 'package:flutter/material.dart';
import 'package:flutter_swcy/pages/shop/shop_page_shop_list_item.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class ShopPageGridViewItem extends StatelessWidget {
  final List<ShopData> _shopDataList;
  ShopPageGridViewItem(
    this._shopDataList
  );

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.9
      ),
      itemCount: _shopDataList.length,
      itemBuilder: (context, index) {
        return ShopPageShopListItem(_shopDataList[index]);
      },
    );
  }
}