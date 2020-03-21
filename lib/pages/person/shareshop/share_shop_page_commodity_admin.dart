import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order/share_shop_page_order_admin_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/pages/person/shareshop/league_store_order_page.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_order_admin.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';
import 'package:oktoast/oktoast.dart';

class ShareShopPageCommodityAdmin extends StatefulWidget {
  final MyStorePageItem myStorePageItem;
  final ShopPagesBloc shopPagesBloc;
  ShareShopPageCommodityAdmin(
    this.myStorePageItem,
    this.shopPagesBloc
  );
  _ShareShopPageCommodityAdminState createState() => _ShareShopPageCommodityAdminState();
}

class _ShareShopPageCommodityAdminState extends State<ShareShopPageCommodityAdmin> {
  @override
  void initState() { 
    super.initState();
    widget.shopPagesBloc.getShopTypeAndEssentialMessage(context, widget.myStorePageItem.id, true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品管理'),
        actions: <Widget>[
          widget.myStorePageItem.type != 1 ?
            InkWell(
              child: Container(
                width: ScreenUtil().setWidth(100),
                alignment: Alignment.center,
                child: Text('添加盟店')
              ),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return MessageDialog(
                      widget: widget.myStorePageItem.type == 2 ? 
                                Text('已存在同类型盟店，确定继续添加盟店？', style: TextStyle(fontSize: ScreenUtil().setSp(32))) :
                                Text('确定添加盟店？', style: TextStyle(fontSize: ScreenUtil().setSp(32))),
                      onCloseEvent: () {
                        Navigator.pop(context);
                      },
                      onPositivePressEvent: () {
                        Navigator.pop(context);
                        widget.shopPagesBloc.createLeagueStore(widget.myStorePageItem.id, context).then((createLeagueStoreVo) {
                          if (createLeagueStoreVo.code == '200') {
                            showToast('创建盟店成功，请等待审核');
                          } else {
                            showToast('创建失败');
                          }
                        });
                      },
                      negativeText: '取消',
                      positiveText: '确认',
                    );
                  }
                );
              },
            ) :
            Container(),
          widget.myStorePageItem.type == 1 ?
            InkWell(
              child: Container(
                width: ScreenUtil().setWidth(100),
                alignment: Alignment.center,
                child: Text('进货')
              ),
              onTap: () {
                widget.shopPagesBloc.leagueStoreGetSupplier(widget.myStorePageItem.industryId, widget.myStorePageItem.id, context);
              },
            ) :
            Container(),
          widget.myStorePageItem.type == 1 ?
            InkWell(
              child: Container(
                width: ScreenUtil().setWidth(100),
                alignment: Alignment.center,
                child: Text('查看进货')
              ),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShareShopPageOrderAdminBloc(), child: LeagueStoreOrderPage(widget.myStorePageItem.id)))).then((data) {
                  widget.shopPagesBloc.getShopTypeAndEssentialMessage(context, widget.myStorePageItem.id, true);
                });
              },
            ) :
            Container(),
          IconButton(
            icon: ImageIcon(
              AssetImage('assets/image_icon/icon_order.png')
            ),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShareShopPageOrderAdminBloc(), child: ShareShopPageOrderAdmin(widget.myStorePageItem.id))));
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
              return ShopPagesShopPageEvaluate(shopTypeAndEssentialMessageVo.data.commodityTypeList, widget.myStorePageItem, widget.shopPagesBloc, true, null);
            } else {
              return showLoading();
            }
          },
        ),
      ),
    );
  }
}