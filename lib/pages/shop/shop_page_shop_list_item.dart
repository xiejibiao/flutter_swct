import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class ShopPageShopListItem extends StatelessWidget {
  final ShopData shopData;
  ShopPageShopListItem(
    this.shopData
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShopPagesBloc(), child: ShopPagesShopPage(shopData.name, shopData.id))));
      },
      child: Card(
        elevation: 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.network(
              shopData.photo,
              width: MediaQuery.of(context).size.width,
              height: 110.0,
              fit: BoxFit.cover,
            ),
            Text(shopData.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: Text('${shopData.juli / 1000} 公里'),
                )
              ],
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}