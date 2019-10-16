import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page.dart';
import 'package:flutter_swcy/vo/shop/news_get_page_store_vo.dart';

class StorePageListItem extends StatelessWidget {
  final StoreMap storeMap;
  StorePageListItem(
    this.storeMap
  );
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverSafeArea(
          sliver: SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverListItem(storeMap.list),
          ),
        )
      ],
    );
  }
}

class SliverListItem extends StatelessWidget {
  final List<StoreItem> _list;
  SliverListItem(
    this._list
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
                          _list[index].photo,
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
                              _list[index].storeName,
                              style: TextStyle(fontSize: ScreenUtil().setSp(60), color: Colors.white),
                            ),
                            _list[index].juli == null ? 
                              Text('') :
                              Text(
                                '${_list[index].juli / 1000} 公里',
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
              Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShopPagesBloc(), child: ShopPagesShopPage(_list[index].storeName, _list[index].id))));
            },
          );
        },
        childCount: _list.length,
      ),
    );
  }
}