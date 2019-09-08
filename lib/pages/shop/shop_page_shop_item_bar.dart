import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/pages/shop/shop_page_shop_list.dart';
import 'package:flutter_swcy/service/service_method.dart';
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

class _ShopPageShopItemBarState extends State<ShopPageShopItemBar> {
  ShopListVo shopListVo;
  int _pageNumber = 0;
  int _pageSize = 10;
  var _futureBuilderFuture;
  // 商家列表
  _getPageStore(int industryId, latitude, longitude, pageNumber, pageSize) async {
    var formData = {
      'industryId': industryId,
      'lat': latitude,
      'lng': longitude,
      'pageNumber': pageNumber,
      'pageSize': pageSize
    };
    var response = await requestPost('getPageStore', formData: formData);
    ShopListVo shopListVo = ShopListVo.fromJson(response);
    return shopListVo;
  }

  @override
  void initState() {
    super.initState();
    shopListVo = null;
    _futureBuilderFuture = _getPageStore(widget.industryId, widget.latitude, widget.longitude, _pageNumber, _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    final ShopPageBloc _bloc = BlocProvider.of<ShopPageBloc>(context);
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, sanpshop) {
        if (sanpshop.hasData) {
          shopListVo = sanpshop.data;
          if (shopListVo.data.list.length == 0) {
            return ShopPageSearchDefaultPage();
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
}