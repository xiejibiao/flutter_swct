import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate_left_navi.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate_right_list.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShopPagesShopPageEvaluate extends StatefulWidget {
  final int id;
  ShopPagesShopPageEvaluate(
    this.id
  );
  _ShopPagesShopPageEvaluateState createState() => _ShopPagesShopPageEvaluateState();
}

class _ShopPagesShopPageEvaluateState extends State<ShopPagesShopPageEvaluate> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final ShopPagesBloc _bloc = BlocProvider.of<ShopPagesBloc>(context);
    _bloc.getShopTypeAndEssentialMessage(context, widget.id);
    return StreamBuilder(
      stream: _bloc.shopTypeAndEssentialMessageVoStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return showLoading();
        } else {
          ShopTypeAndEssentialMessageVo shopTypeAndEssentialMessageVo = sanpshop.data;
          if (shopTypeAndEssentialMessageVo.data.commodityTypeList.length == 0) {
            return ShopPageSearchDefaultPage();
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ShopPagesShopPageEvaluateLeftNavi(_bloc, shopTypeAndEssentialMessageVo.data.commodityTypeList),
                ShopPagesShopPageEvaluateRightList(_bloc)
              ],
            );
          }
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}