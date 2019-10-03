import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
// import 'package:flutter_swcy/pages/shop/shop_page_shop_list_item.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class ShopPageGridViewItem extends StatelessWidget {
  final List<ShopData> _shopDataList;
  ShopPageGridViewItem(
    this._shopDataList
  );

  @override
  Widget build(BuildContext context) {
    // return GridView.builder(
    //   shrinkWrap: true,
    //   physics: new NeverScrollableScrollPhysics(),
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     mainAxisSpacing: 10.0,
    //     crossAxisSpacing: 10.0,
    //     childAspectRatio: 0.9
    //   ),
    //   itemCount: _shopDataList.length,
    //   itemBuilder: (context, index) {
        // return ShopPageShopListItem(_shopDataList[index]);
    //   },
    // );
    return CustomScrollView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverSafeArea(
          sliver: SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverListItem(_shopDataList),
          ),
        )
      ],
    );
  }
}

class SliverListItem extends StatelessWidget {
  final List<ShopData> _shopDataList;
  SliverListItem(
    this._shopDataList
  );
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return InkWell(
            child: Padding(
              padding: EdgeInsets.only(bottom: 22.0),
              child: Material(
                type: MaterialType.card,
                borderRadius: BorderRadius.circular(12.0),
                elevation: 14.0,
                shadowColor: Colors.grey.withOpacity(0.5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          _shopDataList[index].photo,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 32.0,
                        left: 32.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _shopDataList[index].storeName,
                              style: TextStyle(fontSize: ScreenUtil().setSp(60), color: Colors.white),
                            ),
                            _shopDataList[index].juli == null ? 
                              Text('') :
                              Text(
                                '${_shopDataList[index].juli / 1000} 公里',
                                style: TextStyle(fontSize: ScreenUtil().setSp(32), color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShopPagesBloc(), child: ShopPagesShopPage(_shopDataList[index].storeName, _shopDataList[index].id))));
            },
          );
        },
        childCount: _shopDataList.length,
      ),
    );
  }
}