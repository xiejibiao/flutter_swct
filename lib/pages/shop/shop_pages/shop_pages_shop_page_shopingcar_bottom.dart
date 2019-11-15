import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_receiving_address_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_shopingcar_settlement.dart';
import 'package:oktoast/oktoast.dart';

class ShopPagesShopPageShopingcarBottom extends StatelessWidget {
  final int id;
  final String shopName;
  final ShopPagesBloc shopPagesBloc;
  ShopPagesShopPageShopingcarBottom(
    {
      @required this.id,
      @required this.shopName,
      @required this.shopPagesBloc
    }
  );
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setHeight(90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(200),
              child: Row(
                children: <Widget>[
                  StreamBuilder(
                    stream: shopPagesBloc.isAllCheckStream,
                    initialData: true,
                    builder: (context, sanpshop) {
                      return Checkbox(
                        value: sanpshop.data,
                        onChanged: (val) {
                          shopPagesBloc.allCheckStateChange(val);
                        },
                      );
                    },
                  ),
                  Text(
                    '全选',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: Colors.blue
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(340),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '合计：',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: Colors.blue
                    ),
                  ),
                  StreamBuilder(
                    initialData: 0.0,
                    stream: shopPagesBloc.allPriceStream,
                    builder: (context, sanpshop) {
                      return Text(
                        '￥${sanpshop.data}', 
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            StreamBuilder(
              initialData: 0,
              stream: shopPagesBloc.allCommodityCountStream,
              builder: (context, sanpshop) {
                return Container(
                  width: ScreenUtil().setWidth(210),
                  padding: EdgeInsets.only(left: 10.0),
                  child: InkWell(
                    onTap: () async {
                      if (sanpshop.data == 0) {
                        showToast('请条挑选商品后再结算哦~~');
                      } else {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(child: ShopPagesShopPageShopingcarSettlement(id: id, shopName: shopName, shopPagesBloc: shopPagesBloc), bloc: PersonInfoReceivingAddressBloc())));
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 10),
                      width: ScreenUtil().setWidth(210),
                      height: ScreenUtil().setHeight(70),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red
                        ),
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3.0)
                      ),
                      child: Text(
                        '结算:(${sanpshop.data})',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}