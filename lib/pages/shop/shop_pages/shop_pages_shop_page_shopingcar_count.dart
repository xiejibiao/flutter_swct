import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          _countArea(shopPagesBloc),
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

  Widget _countArea(ShopPagesBloc bloc) {
    return Container(
      width: ScreenUtil().setWidth(70),
      height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: TextField(
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: '${commodityInfoVo.count}',
            selection: TextSelection.fromPosition(
              TextPosition(
                affinity: TextAffinity.downstream,
                offset: '${commodityInfoVo.count}'.length
              )
            )
          ),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        obscureText: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 0)
        ),
        onChanged: (val) {
          // if (val != '') {
            RegExp exp = RegExp('^\\d{1,4}\$');
            if (exp.hasMatch(val)) {
              bloc.editCount(id: commodityInfoVo.id, count: int.parse(val));
            } else {
              bloc.editCount(id: commodityInfoVo.id, count: int.parse(val.substring(0, 4)));
            }
          // } else {
          //   bloc.editCount(id: commodityInfoVo.id, count: 1);
          // }
        },
      ),
    );
  }
}