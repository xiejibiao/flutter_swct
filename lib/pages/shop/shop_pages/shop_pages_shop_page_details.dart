import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShopPagesShopPageDetails extends StatefulWidget {
  _ShopPagesShopPageDetailsState createState() => _ShopPagesShopPageDetailsState();
}

class _ShopPagesShopPageDetailsState extends State<ShopPagesShopPageDetails> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    final ShopPagesBloc _bloc = BlocProvider.of<ShopPagesBloc>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: _bloc.shopTypeAndEssentialMessageVoStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            ShopTypeAndEssentialMessageVo shopTypeAndEssentialMessageVo = sanpshop.data;
            if (shopTypeAndEssentialMessageVo.data.swcyStoreEntity.desc == '') {
              return ShopPageSearchDefaultPage();
            } else {
              return SingleChildScrollView(
                child: Html(
                  data: shopTypeAndEssentialMessageVo.data.swcyStoreEntity.desc,
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}