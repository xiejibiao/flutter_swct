import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';

class ShopPagesShopPageShopingcarCount extends StatelessWidget {
  final CommodityInfoVo commodityInfoVo;
  ShopPagesShopPageShopingcarCount(
    this.commodityInfoVo
  );
  @override
  Widget build(BuildContext context) {
    final ShopPagesBloc _bloc = BlocProvider.of<ShopPagesBloc>(context);
    return Container(
      width: ScreenUtil().setWidth(165),
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black12)
      ),
      child: Row(
        children: <Widget>[
          _reduceBtn(_bloc),
          _countArea(),
          _addBtn(_bloc)
        ],
      ),
    );
  }

  Widget _reduceBtn(ShopPagesBloc bloc) {
    return InkWell(
      onTap: () {
        bloc.increaseOrReduceOperation(id: commodityInfoVo.id, isIncrease: false);
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: commodityInfoVo.count > 1 ? Colors.white : Colors.black12,
          border: Border(
            right: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: commodityInfoVo.count > 1 ? Text('-') : Text(''),
      ),
    );
  }

  Widget _addBtn(ShopPagesBloc bloc) {
    return InkWell(
      onTap: () {
        bloc.increaseOrReduceOperation(id: commodityInfoVo.id, isIncrease: true);
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: Text('+'),
      ),
    );
  }

  Widget _countArea() {
    return Container(
      width: ScreenUtil().setWidth(70),
      height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('${commodityInfoVo.count}'),
    );
  }
}