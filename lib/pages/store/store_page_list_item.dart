import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page.dart';
import 'package:flutter_swcy/vo/shop/news_get_page_store_vo.dart';
import 'package:oktoast/oktoast.dart';

class StorePageListItem extends StatelessWidget {
  final StoreMap storeMap;
  StorePageListItem(this.storeMap);
  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      sliver: SliverPadding(
        padding: EdgeInsets.all(8.0),
        sliver: SliverListItem(storeMap.list),
      ),
    );
  }
}

// class SliverListItem extends StatelessWidget {
//   final List<StoreItem> _list;
//   SliverListItem(
//     this._list
//   );
//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate((context, index) {
//           return InkWell(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 22.0),
//               child: Material(
//                 type: MaterialType.card,
//                 borderRadius: BorderRadius.circular(12.0),
//                 elevation: 14.0,
//                 shadowColor: Colors.grey.withOpacity(0.5),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12.0),
//                   child: Stack(
//                     children: <Widget>[
//                       AspectRatio(
//                         aspectRatio: 1 / 1,
//                         child: Image.network(
//                           _list[index].photo,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Positioned(
//                         top: 32.0,
//                         left: 32.0,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               _list[index].storeName,
//                               style: TextStyle(
//                                 fontSize: ScreenUtil().setSp(60),
//                                 color: Colors.white
//                               ),
//                             ),
//                             _list[index].juli == null
//                                 ? Text('')
//                                 : Text(
//                                     '${_list[index].juli / 1000} 公里',
//                                     style: TextStyle(
//                                         fontSize: ScreenUtil().setSp(32),
//                                         color: Colors.white),
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             onTap: () {
//               Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShopPagesBloc(), child: ShopPagesShopPage(_list[index].storeName, _list[index].id))));
//             },
//           );
//         },
//         childCount: _list.length,
//       ),
//     );
//   }
// }

class SliverListItem extends StatelessWidget {
  final List<StoreItem> list;
  SliverListItem(
    this.list
  );
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
          return InkWell(
            child: Container(
              height: ScreenUtil().setHeight(220),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          list[index].photo,
                          fit: BoxFit.cover,
                          height: ScreenUtil().setWidth(200),
                          width: ScreenUtil().setWidth(200),
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      Container(
                        width: ScreenUtil().setWidth(300),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              list[index].storeName,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(34),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            list[index].brief == null ? 
                              Text('') : 
                              Text(
                                list[index].brief,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(26),
                                  color: Colors.grey
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            list[index].status == 1 ? 
                              Stack(
                                children: <Widget> [
                                  Positioned(
                                    child: Text(
                                      '${list[index].starCode}',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: ScreenUtil().setSp(32)
                                      )
                                    ),
                                    top: 0,
                                    right: 15,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: ScreenUtil().setWidth(100),
                                    child: ImageIcon(
                                      AssetImage(
                                        'assets/image_icon/icon_store_share.png',
                                      ),
                                      size: 25,
                                      color: Colors.blue,
                                    ),
                                  )
                                ]
                              ) :
                              Container()
                          ]
                        )
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          list[index].juli == null
                                  ? Text('')
                                  : Text(
                                      '${list[index].juli / 1000} 公里',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(26),
                                          color: Colors.grey,
                                        ),
                                    )
                        ],
                      )
                    ]
                  ),
                )
              ),
            ),
            onTap: list[index].status == 1 ? 
              () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShopPagesBloc(), child: ShopPagesShopPage(list[index].storeName, list[index].id))));
              } : 
              () {
                showToast('共享店未审核或已被暂停营业');
              },
          );
        },
        childCount: list.length,
      ),
    );
  }
}