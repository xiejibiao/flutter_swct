import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/supplier_commodity_page_bloc.dart';
import 'package:flutter_swcy/bloc/supplier_page_shoppingCar_bloc.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_commodity_page.dart';
import 'package:flutter_swcy/vo/supplier/get_supplier_page_vo.dart';

// class SupplierPageListItem extends StatelessWidget {
//   final SupplierInfoVo supplierInfoVo;
//   SupplierPageListItem(this.supplierInfoVo);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Padding(
//         padding: EdgeInsets.only(bottom: 22.0),
//         child: Material(
//           type: MaterialType.card,
//           borderRadius: BorderRadius.circular(12.0),
//           elevation: 14.0,
//           shadowColor: Colors.grey.withOpacity(0.5),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12.0),
//             child: Stack(
//               children: <Widget>[
//                 AspectRatio(
//                   aspectRatio: 1 / 1,
//                   child: Image.network(
//                     supplierInfoVo.photo,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 32.0,
//                   left: 32.0,
//                   child: Row(
//                     children: <Widget>[
//                       CircleAvatar(
//                         radius: 36,
//                         backgroundImage: NetworkImage(supplierInfoVo.logo),
//                       ),
//                       Container(
//                         width: ScreenUtil().setWidth(550),
//                         child: Text(
//                           '${supplierInfoVo.name}',
//                           style: TextStyle(
//                             fontSize: ScreenUtil().setSp(60),
//                             color: Colors.white
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       )
//                     ]
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       onTap: () {
//         Navigator.push(
//           context, 
//           CupertinoPageRoute(
//             builder: (context) => BlocProvider(
//               bloc: SupplierCommodityPageBloc(), 
//               child: BlocProvider(bloc: SupplierPageShoppingCarBloc(), child: SupplierCommodityPage(supplierInfoVo)) 
//             )
//           )
//         );
//       },
//     );
//   }
// }

class SupplierPageListItem extends StatelessWidget {
  final SupplierInfoVo supplierInfoVo;
  SupplierPageListItem(this.supplierInfoVo);

  @override
  Widget build(BuildContext context) {
    // return InkWell(
    //   child: Padding(
    //     padding: EdgeInsets.only(bottom: 22.0),
    //     child: Material(
    //       type: MaterialType.card,
    //       borderRadius: BorderRadius.circular(12.0),
    //       elevation: 14.0,
    //       shadowColor: Colors.grey.withOpacity(0.5),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(12.0),
    //         child: Stack(
    //           children: <Widget>[
    //             AspectRatio(
    //               aspectRatio: 1 / 1,
    //               child: Image.network(
    //                 supplierInfoVo.photo,
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //             Positioned(
    //               top: 32.0,
    //               left: 32.0,
    //               child: Row(
    //                 children: <Widget>[
    //                   CircleAvatar(
    //                     radius: 36,
    //                     backgroundImage: NetworkImage(supplierInfoVo.logo),
    //                   ),
    //                   Container(
    //                     width: ScreenUtil().setWidth(550),
    //                     child: Text(
    //                       '${supplierInfoVo.name}',
    //                       style: TextStyle(
    //                         fontSize: ScreenUtil().setSp(60),
    //                         color: Colors.white
    //                       ),
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                   )
    //                 ]
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    //   onTap: () {
    //     Navigator.push(
    //       context, 
    //       CupertinoPageRoute(
    //         builder: (context) => BlocProvider(
    //           bloc: SupplierCommodityPageBloc(), 
    //           child: BlocProvider(bloc: SupplierPageShoppingCarBloc(), child: SupplierCommodityPage(supplierInfoVo)) 
    //         )
    //       )
    //     );
    //   },
    // );
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(200),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        supplierInfoVo.photo,
                        fit: BoxFit.fill,
                        height: ScreenUtil().setWidth(200),
                        width: ScreenUtil().setWidth(200),
                      ),
                    ),
                    Positioned(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(supplierInfoVo.logo),
                      ),
                      top: 5,
                      left: 5,
                    )
                  ],
                ),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Container(
                  width: ScreenUtil().setWidth(300),
                  child: Text(
                    supplierInfoVo.name,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(34),
                    ),
                    overflow: TextOverflow.fade,
                  )
                )
              ]
            ),
          )
        ),
      ),
      onTap: () {
        Navigator.push(
          context, 
          CupertinoPageRoute(
            builder: (context) => BlocProvider(
              bloc: SupplierCommodityPageBloc(), 
              child: BlocProvider(bloc: SupplierPageShoppingCarBloc(), child: SupplierCommodityPage(supplierInfoVo)) 
            )
          )
        );
      },
    );
  }
}