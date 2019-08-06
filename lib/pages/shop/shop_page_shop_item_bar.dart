import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_page_shop_list.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class ShopPageShopItemBar extends StatefulWidget {
  final int industryId;
  final String latitude;
  final String longitude;
  ShopPageShopItemBar(
    this.industryId,
    this.latitude,
    this.longitude
  );
  _ShopPageShopItemBarState createState() => _ShopPageShopItemBarState();
}

class _ShopPageShopItemBarState extends State<ShopPageShopItemBar> with AutomaticKeepAliveClientMixin {
  ShopListVo shopListVo;
  int _pageNumber = 0;
  int _pageSize = 10;

  @override
  Widget build(BuildContext context) {
    final ShopPageBloc _bloc = BlocProvider.of<ShopPageBloc>(context);
    return FutureBuilder(
      future: _bloc.getPageStore(widget.industryId, widget.latitude, widget.longitude, _pageNumber, _pageSize),
      builder: (context, sanpshop) {
        if (sanpshop.hasData) {
          shopListVo = sanpshop.data;
          if (shopListVo.data.list.length == 0) {
            return Center(
              child: ImageIcon(AssetImage('assets/image_icon/icon_defect.png'), size: 100, color: Colors.grey),
            );
          } else {
            return ShopPageShopList(shopListVo, widget.industryId, widget.latitude, widget.longitude, _bloc);
          }
        } else {
          return Center(
            child: showLoading(),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}