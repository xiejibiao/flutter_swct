import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_commodity_admin_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate_left_navi.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate_right_list.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';
import 'package:flutter_swcy/vo/shop/news_get_page_store_vo.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShopPagesShopPageEvaluate extends StatefulWidget {
  final List<CommodityTypeList> commodityTypeList;
  final MyStorePageItem myStorePageItem; /// 我的共享店页面进入时，此参数不能为空
  final ShopPagesBloc bloc;
  final bool isAdmin;
  final StoreItem storeItem; /// 共享店页面进入时，此参数不能为空
  ShopPagesShopPageEvaluate(
    this.commodityTypeList,
    this.myStorePageItem,
    this.bloc,
    this.isAdmin,
    this.storeItem    
  );
  _ShopPagesShopPageEvaluateState createState() => _ShopPagesShopPageEvaluateState();
}

class _ShopPagesShopPageEvaluateState extends State<ShopPagesShopPageEvaluate> {
  @override
  Widget build(BuildContext context) {
    return !widget.isAdmin ? 
              widget.commodityTypeList.length == 0 ? 
              ShopPageSearchDefaultPage() : 
                Column(
                  children: <Widget>[
                    ShopPagesShopPageEvaluateLeftNavi(widget.commodityTypeList, widget.storeItem.id, widget.bloc, widget.isAdmin, widget.storeItem.type),
                    Expanded(
                      child: BlocProvider(bloc: ShareShopPageBloc(), child: BlocProvider(bloc: ShareShopPageCommodityAdminBloc(), child: ShopPagesShopPageEvaluateRightList(widget.bloc, widget.isAdmin, widget.commodityTypeList.length, widget.storeItem.type, widget.storeItem.id)))
                    )
                  ],
                ) : 
                Column(
                  children: <Widget>[
                    ShopPagesShopPageEvaluateLeftNavi(widget.commodityTypeList, widget.myStorePageItem.id, widget.bloc, widget.isAdmin, widget.myStorePageItem.type),
                    Expanded(
                      child: BlocProvider(bloc: ShareShopPageBloc(), child: BlocProvider(bloc: ShareShopPageCommodityAdminBloc(), child: ShopPagesShopPageEvaluateRightList(widget.bloc, widget.isAdmin, widget.commodityTypeList.length, widget.myStorePageItem.type, widget.myStorePageItem.id)))
                    )
                  ],
                );
  }
}