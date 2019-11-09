import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order/share_shop_page_order_admin_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_order_admin.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShareShopPageCommodityAdmin extends StatefulWidget {
  final int id;
  final ShopPagesBloc shopPagesBloc;
  ShareShopPageCommodityAdmin(
    this.id,
    this.shopPagesBloc
  );
  _ShareShopPageCommodityAdminState createState() => _ShareShopPageCommodityAdminState();
}

class _ShareShopPageCommodityAdminState extends State<ShareShopPageCommodityAdmin> {
  @override
  void initState() { 
    super.initState();
    widget.shopPagesBloc.getShopTypeAndEssentialMessage(context, widget.id, true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品管理'),
        actions: <Widget>[
          IconButton(
            icon: ImageIcon(
              AssetImage('assets/image_icon/icon_order.png')
            ),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShareShopPageOrderAdminBloc(), child: ShareShopPageOrderAdmin(widget.id))));
            },
          )
        ],
      ),
      body: Container(
        width: ScreenUtil().setWidth(750),
        child: StreamBuilder(
          stream: widget.shopPagesBloc.shopTypeAndEssentialMessageVoStream,
          builder: (context, sanpshop) {
            if (sanpshop.hasData) {
              ShopTypeAndEssentialMessageVo shopTypeAndEssentialMessageVo = sanpshop.data;
              return ShopPagesShopPageEvaluate(shopTypeAndEssentialMessageVo.data.commodityTypeList, widget.id, widget.shopPagesBloc, true);
            } else {
              return showLoading();
            }
          },
        ),
      ),
    );
  }
}