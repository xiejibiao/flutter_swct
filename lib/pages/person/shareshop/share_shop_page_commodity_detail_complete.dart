import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_commodity_admin_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/commodity_detail_util.dart';

class ShareShopPageCommodityDetailComplete extends StatelessWidget {
  final List<dynamic> items;
  final int id;
  final ShopPagesBloc shopPagesBloc;
  final ShareShopPageBloc shareShopPageBloc;
  final bool isStore;
  ShareShopPageCommodityDetailComplete(
    this.items, 
    this.id,
    this.shopPagesBloc,
    this.isStore,
    this.shareShopPageBloc
  );

  @override
  Widget build(BuildContext context) {
    final ShareShopPageCommodityAdminBloc _bloc = BlocProvider.of<ShareShopPageCommodityAdminBloc>(context);
    List<Widget> _detailWidgets = getDetailWidgets(detailsList: items);
    return Scaffold(
      appBar: AppBar(
        title: Text('预览详情'),
        actions: <Widget>[
          IconButton(
            icon: Text('保存'),
            onPressed: () {
              String detial = json.encode(items);
              if (isStore) {
                _bloc.editStoreDescription(context, detial, id, shareShopPageBloc);
              } else {
                _bloc.editCommodityDetail(context, detial, id, shopPagesBloc);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _detailWidgets,
        ),
      ),
    );
  }
}