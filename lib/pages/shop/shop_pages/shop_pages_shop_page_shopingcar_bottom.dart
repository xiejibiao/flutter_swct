import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_receiving_address_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_shopingcar_settlement.dart';

class ShopPagesShopPageShopingcarBottom extends StatelessWidget {
  final int id;
  final String shopName;
  ShopPagesShopPageShopingcarBottom(
    {
      @required this.id,
      @required this.shopName,
    }
  );
  @override
  Widget build(BuildContext context) {
    final ShopPagesBloc _bloc = BlocProvider.of<ShopPagesBloc>(context);
    return Container(
      padding: EdgeInsets.all(5.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          _selectAllBtn(_bloc),
          _allPriceArea(_bloc),
          _goButtom(_bloc)
        ],
      ),
    );
  }

  Widget _selectAllBtn(ShopPagesBloc bloc) {
    return StreamBuilder(
      initialData: true,
      stream: bloc.isAllCheckStream,
      builder: (context, sanpshop) {
        return Container(
          width: ScreenUtil().setWidth(180),
          child: Row(
            children: <Widget>[
              Checkbox(
                value: sanpshop.data,
                activeColor: Colors.blue,
                onChanged: (val) {
                  bloc.allCheckStateChange(val);
                },
              ),
              Text('全选')
            ],
          ),
        );
      },
    );
  }

  Widget _allPriceArea(ShopPagesBloc bloc) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(110),
            child: Text(
              '合计:',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36)
              ),
            ),
          ),
          StreamBuilder(
            initialData: 0,
            stream: bloc.allPriceStream,
            builder: (context, sanpshop) {
              return Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(230),
                child: Text(
                  '￥${sanpshop.data}',
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    color: Colors.red
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _goButtom(ShopPagesBloc bloc) {
    return StreamBuilder(
      initialData: 0,
      stream: bloc.allCommodityCountStream,
      builder: (context, sanpshop) {
        return Container(
          width: ScreenUtil().setWidth(180),
          padding: EdgeInsets.only(left: 10.0),
          child: InkWell(
            onTap: () async {
              Navigator.push(
                context, 
                CupertinoPageRoute(
                  builder: (context) => 
                    BlocProvider(
                      child: BlocProvider(child: ShopPagesShopPageShopingcarSettlement(id: id, shopName: shopName,), bloc: PersonInfoReceivingAddressBloc()),
                      bloc: ShopPagesBloc(),
                    )
                  )
                );
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(3.0)
              ),
              child: Text(
                '结算(${sanpshop.data})',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}