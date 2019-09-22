import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate_left_navi.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate_right_list.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShopPagesShopPageEvaluate extends StatefulWidget {
  final List<CommodityTypeList> commodityTypeList;
  final int id;
  ShopPagesShopPageEvaluate(
    this.commodityTypeList,
    this.id,
    this.bloc
  );
  final ShopPagesBloc bloc;
  _ShopPagesShopPageEvaluateState createState() => _ShopPagesShopPageEvaluateState();
}

class _ShopPagesShopPageEvaluateState extends State<ShopPagesShopPageEvaluate> {
  @override
  Widget build(BuildContext context) {
    return widget.commodityTypeList.length == 0 ? 
              ShopPageSearchDefaultPage() : 
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ShopPagesShopPageEvaluateLeftNavi(widget.commodityTypeList, widget.id, widget.bloc),
                  ShopPagesShopPageEvaluateRightList(widget.bloc)
                ],
              );
  }
}
