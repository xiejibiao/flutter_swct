import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_shopingcar_bottom.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_shopingcar_item.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';

class ShopPagesShopPageShopingcar extends StatelessWidget {
  final int id;
  final String shopName;
  final ShopPagesBloc shopPagesBloc;
  ShopPagesShopPageShopingcar(
    {
      @required this.id,
      @required this.shopName,
      @required this.shopPagesBloc
    }
  );
  @override
  Widget build(BuildContext context) {
    shopPagesBloc.getCommodityNewestPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: StreamBuilder(
        stream: shopPagesBloc.commodityInfoVoListStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            List<CommodityInfoVo> commodityInfoVoList = sanpshop.data;
            return Container(
              width: ScreenUtil().setWidth(750),
              child: Stack(
                children: <Widget>[
                  commodityInfoVoList.length > 0 ? 
                    ListView.builder(
                      itemCount: commodityInfoVoList.length,
                      itemBuilder: (context, index) {
                        return ShopPagesShopPageShopingcarItem(commodityInfoVo: commodityInfoVoList[index], shopPagesBloc: shopPagesBloc);
                      },
                    ) : ShopPageSearchDefaultPage(),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: ShopPagesShopPageShopingcarBottom(id: id, shopName: shopName, shopPagesBloc: shopPagesBloc),
    );
  }
}