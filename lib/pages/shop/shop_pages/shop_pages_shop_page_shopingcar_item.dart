import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_shopingcar_count.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';

class ShopPagesShopPageShopingcarItem extends StatelessWidget {
  final CommodityInfoVo commodityInfoVo;
  final ShopPagesBloc shopPagesBloc;
  ShopPagesShopPageShopingcarItem(
    {
      @required this.commodityInfoVo,
      @required this.shopPagesBloc
    }
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          decoration: BoxDecoration(
            color: commodityInfoVo.delFlag == 1 ? Colors.grey[200] : Colors.white,
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.black12),
            )
          ),
          child: Row(
            children: <Widget>[
              _commodityCheckBt(shopPagesBloc),
              _commodityCover(),
              _commodityName(),
              _commodityPrice(shopPagesBloc, context)
            ],
          ),
        ),
        commodityInfoVo.delFlag == 1 ?
          Positioned(
            top: 0,
            right: 0,
            child: ImageIcon(AssetImage('assets/image_icon/icon_Invalid.png'), size: 60),
          ) :
          Container()
      ],
    );
  }

  // 复选按钮
  Widget _commodityCheckBt(ShopPagesBloc bloc) {
    return Container(
      child: Checkbox(
        value: commodityInfoVo.isCheck,
        activeColor: Colors.blue,
        onChanged: (val) {
          if (commodityInfoVo.delFlag != 1) {
            bloc.changeCartState(id: commodityInfoVo.id, checked: val);
          }
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
          ShopPagesShopPageShopingcarCount(commodityInfoVo: commodityInfoVo, shopPagesBloc: shopPagesBloc)
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
                      widget: Text('确定要删除这1种商品吗？', style: TextStyle(fontSize: ScreenUtil().setSp(32))),
                      onCloseEvent: () {
                        Navigator.pop(context);
                      },
                      onPositivePressEvent: () {
                        Navigator.pop(context);
                        bloc.removeCarts(id: commodityInfoVo.id);
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