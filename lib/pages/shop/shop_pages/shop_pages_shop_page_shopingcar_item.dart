import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_shopingcar_count.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';

class ShopPagesShopPageShopingcarItem extends StatelessWidget {
  final CommodityInfoVo commodityInfoVo;
  ShopPagesShopPageShopingcarItem(
    this.commodityInfoVo
  );

  @override
  Widget build(BuildContext context) {
    final ShopPagesBloc _bloc = BlocProvider.of<ShopPagesBloc>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        )
      ),
      child: Row(
        children: <Widget>[
          _commodityCheckBt(_bloc),
          _commodityCover(),
          _commodityName(),
          _commodityPrice(_bloc, context)
        ],
      ),
    );
  }

  // 复选按钮
  Widget _commodityCheckBt(ShopPagesBloc bloc) {
    return Container(
      child: Checkbox(
        value: commodityInfoVo.isCheck,
        activeColor: Colors.blue,
        onChanged: (val) {
          commodityInfoVo.isCheck = val;
          bloc.changeCheckState(commodityInfoVo);
        },
      ),
    );
  }

  // 商品图片
  Widget _commodityCover() {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26)
      ),
      child: Image.network(commodityInfoVo.cover),
    );
  }

  // 商品名称
  Widget _commodityName() {
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(commodityInfoVo.name),
          ShopPagesShopPageShopingcarCount(commodityInfoVo)
        ],
      ),
    );
  }

  // 商品价格
  Widget _commodityPrice(ShopPagesBloc bloc, BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(130),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('￥${commodityInfoVo.price}'),
          Container(
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return MessageDialog(
                      message: '确定要删除这1种商品吗？',
                      onCloseEvent: () {
                        Navigator.pop(context);
                      },
                      onPositivePressEvent: () {
                        Navigator.pop(context);
                        bloc.deleteOneCommodity(commodityInfoVo.id);
                      },
                      negativeText: '取消',
                      positiveText: '确认',
                    );
                  }
                );
              },
              child: Icon(
                Icons.delete_forever,
                color: Colors.black38,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}