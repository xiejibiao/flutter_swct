import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/commodity_detail_util.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShopPagesShopPageDetails extends StatelessWidget {
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
            if (shopTypeAndEssentialMessageVo.data.swcyStoreEntity.type == 1) {
              return Html(data: shopTypeAndEssentialMessageVo.data.swcyStoreEntity.description);
            } else {
              if (TextUtil.isEmpty(shopTypeAndEssentialMessageVo.data.swcyStoreEntity.description)) {
                return ShopPageSearchDefaultPage();
              } else {
                List<Widget> _detailWidgets = [];
                if (TextUtil.isEmpty(shopTypeAndEssentialMessageVo.data.swcyStoreEntity.description)) {
                  _detailWidgets.add(ShopPageSearchDefaultPage());
                } else {
                  _detailWidgets = getDetailWidgets(details: shopTypeAndEssentialMessageVo.data.swcyStoreEntity.description);
                }
                return SingleChildScrollView(
                  child: Column(
                    children: _detailWidgets,
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}