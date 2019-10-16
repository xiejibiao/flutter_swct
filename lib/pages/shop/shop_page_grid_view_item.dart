import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/pages/store/store_page_list_item.dart';
import 'package:flutter_swcy/vo/shop/news_get_page_store_vo.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class ShopPageGridViewItem extends StatelessWidget {
  final List<ShopData> _shopDataList;
  ShopPageGridViewItem(
    this._shopDataList
  );

  @override
  Widget build(BuildContext context) {
    List<StoreItem> _list = StoreItem().getStoreItemListFormShopDataList(_shopDataList);
    return CustomScrollView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverSafeArea(
          sliver: SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverListItem(_list),
          ),
        )
      ],
    );
  }
}