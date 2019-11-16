import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';

class ShopPagesShopPageShopingcarCount extends StatelessWidget {
  final CommodityInfoVo commodityInfoVo;
  final ShopPagesBloc shopPagesBloc;
  ShopPagesShopPageShopingcarCount(
    {
      @required this.commodityInfoVo,
      @required this.shopPagesBloc
    }
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(165),
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black12)
      ),
      child: Row(
        children: <Widget>[
          _reduceBtn(shopPagesBloc),
          _countArea(),
          _addBtn(shopPagesBloc)
        ],
      ),
    );
  }

  Widget _reduceBtn(ShopPagesBloc bloc) {
    return InkWell(
      onTap: () {
        if (commodityInfoVo.count > 1) {
          bloc.increaseOrReduceOperation(id: commodityInfoVo.id, isIncrease: false);
        }
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
        if (commodityInfoVo.delFlag != 1) {
          bloc.increaseOrReduceOperation(id: commodityInfoVo.id, isIncrease: true);
        }
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