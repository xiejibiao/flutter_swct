import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_shopingcar_bottom.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_shopingcar_item.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';

class ShopPagesShopPageShopingcar extends StatelessWidget {
  final int id;
  ShopPagesShopPageShopingcar(
    this.id
  );
  @override
  Widget build(BuildContext context) {
    final ShopPagesBloc _bloc = BlocProvider.of<ShopPagesBloc>(context);
    _bloc.setCommodityKey(id);
    _bloc.getCommodityNewestPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: StreamBuilder(
        stream: _bloc.commodityInfoVoListStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            List<CommodityInfoVo> commodityInfoVoList = sanpshop.data;
            return Container(
              width: ScreenUtil().setWidth(750),
              child: Stack(
                children: <Widget>[
                  ListView.builder(
                    itemCount: commodityInfoVoList.length,
                    itemBuilder: (context, index) {
                      return ShopPagesShopPageShopingcarItem(commodityInfoVoList[index]);
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: ShopPagesShopPageShopingcarBottom(),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}