import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_commodity_admin_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShareShopPageCommodityAdmin extends StatelessWidget {
  final int id;
  ShareShopPageCommodityAdmin(
    this.id
  );
  @override
  Widget build(BuildContext context) {
    final ShareShopPageCommodityAdminBloc _bloc = BlocProvider.of<ShareShopPageCommodityAdminBloc>(context);
    final ShopPagesBloc _shopPagesBloc = BlocProvider.of<ShopPagesBloc>(context);
    _shopPagesBloc.getShopTypeAndEssentialMessage(context, id);
    return Scaffold(
      appBar: AppBar(
        title: Text('商品管理'),
      ),
      body: Container(
        width: ScreenUtil().setWidth(750),
        child: StreamBuilder(
          stream: _shopPagesBloc.shopTypeAndEssentialMessageVoStream,
          builder: (context, sanpshop) {
            if (sanpshop.hasData) {
              ShopTypeAndEssentialMessageVo shopTypeAndEssentialMessageVo = sanpshop.data;
              return ShopPagesShopPageEvaluate(shopTypeAndEssentialMessageVo.data.commodityTypeList, id);
            } else {
              return showLoading();
            }
          },
        ),
      ),
    );
  }
}