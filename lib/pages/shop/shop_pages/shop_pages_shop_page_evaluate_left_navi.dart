import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShopPagesShopPageEvaluateLeftNavi extends StatelessWidget {
  final List<CommodityTypeList> commodityTypeList;
  ShopPagesShopPageEvaluateLeftNavi(
    this.commodityTypeList
  );
  @override
  Widget build(BuildContext context) {
    final ShopPagesBloc _bloc = BlocProvider.of<ShopPagesBloc>(context);
    return StreamBuilder(
      stream: _bloc.leftIndexStream,
      builder: (context, sanpshop) {
        return Container(
          width: ScreenUtil().setWidth(180),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1, color: Colors.black12)
            )
          ),
          child: ListView.builder(
            itemCount: commodityTypeList.length,
            itemBuilder: (context, index) {
              return _leftInkWellItem(index, commodityTypeList[index], _bloc);
            },
          ),
        );
      },
    );
  }

  Widget _leftInkWellItem (int index, CommodityTypeList commodityTypeList, ShopPagesBloc bloc) {
    bool isSelected = bloc.thisIndexIsSelected(index);
    return InkWell(
      onTap: () {
        bloc.setLeftIndex(index);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: Text(
          commodityTypeList.name,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28)
          ),
        ),
      ),
    );
  }
}