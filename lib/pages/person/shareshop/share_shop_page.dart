import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_commodity_admin_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_add.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_authentication.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_commodity_admin.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_commodity_detail.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';

class ShareShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShareShopPageBloc _bloc = BlocProvider.of<ShareShopPageBloc>(context);
    final ShopPagesBloc _shopPagesBloc = BlocProvider.of<ShopPagesBloc>(context);
    final ShareShopPageCommodityAdminBloc _shareShopPageCommodityAdminBloc = BlocProvider.of<ShareShopPageCommodityAdminBloc>(context);
    _bloc.getMyStorePage(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的共享店'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, size: 32),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(child: ShareShopPageAdd(_bloc, null), bloc: ShareShopPageBloc())));
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _bloc.myStorePageVoStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            MyStorePageVo myStorePageVo = sanpshop.data;
            if (myStorePageVo.data.list.length <= 0) {
              return ShopPageSearchDefaultPage(); 
            } else {
              return EasyRefresh.custom(
                header: BallPulseHeader(),
                footer: BallPulseFooter(
                  enableHapticFeedback: true,
                  enableInfiniteLoad: false
                ),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                        return _buildStoreItem(myStorePageVo.data.list[index], _bloc, _shopPagesBloc, _shareShopPageCommodityAdminBloc, context);
                      },
                      childCount: myStorePageVo.data.list.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _bloc.isEnd ? TheEndBaseline() : Container(),
                  )
                ],
                onLoad: () async {
                  await _bloc.getMyStorePageLoadMore(context);
                },
                onRefresh: () async {
                  await _bloc.getMyStorePage(context);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildStoreItem(MyStorePageItem myStorePageItem, ShareShopPageBloc bloc, ShopPagesBloc shopPagesBloc, ShareShopPageCommodityAdminBloc shareShopPageCommodityAdminBloc, BuildContext context) {
    return InkWell(
      onTap: () {
        shareShopPageCommodityAdminBloc.getItems(myStorePageItem.description);
        Navigator.push(context, CupertinoPageRoute(builder: (context) => ShareShopPageCommodityDetail(myStorePageItem.description, myStorePageItem.id, shareShopPageCommodityAdminBloc, shopPagesBloc, true, bloc)));
      },
      onLongPress: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(child: ShareShopPageAdd(bloc, myStorePageItem), bloc: ShareShopPageBloc()))).then((data) {
          if (data != null) {
            bloc.resetStoreItem(data.data);
          }
        });
      },
      child: Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setHeight(200),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    myStorePageItem.photo,
                    fit: BoxFit.fill,
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setWidth(200),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(70),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(myStorePageItem.storeName),
                          Text(myStorePageItem.isChecked == 1 ? '持证上线' : '无证照上线')
                        ],
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(445),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          myStorePageItem.type == 1 ? 
                            ImageIcon(AssetImage('assets/image_icon/icon_league_store.png'), color: Colors.blue) :
                            ImageIcon(AssetImage('assets/image_icon/icon_shop.png'), color: Colors.blue), 
                          _buildButtom(myStorePageItem.isChecked, TextUtil.isEmpty(myStorePageItem.licenseCode) ? false : true, context, myStorePageItem, bloc, shopPagesBloc)
                        ]
                      )
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 审核状态、是否申请认证
  Widget _buildButtom(int status, bool isAuthentication, BuildContext context, MyStorePageItem myStorePageItem, ShareShopPageBloc bloc, ShopPagesBloc shopPagesBloc) {
    if (isAuthentication) {
      switch (status) {
        /// 审核中
        case 0:
          return _buildAuditInProgressButtom();
          break;
        /// 产品上架
        case 1:
          return _buildProductsOnShelvesButtom(context, myStorePageItem, shopPagesBloc);
          break;
        /// 审核失败
        default:
         return _buildAuditFailureButtom(myStorePageItem, context, bloc);
      }
    } else {
      return _buildAuthenticationButtom(context, myStorePageItem.id, bloc);
    }
  }

  /// 审核中
  Widget _buildAuditInProgressButtom() {
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(180),
      child: ImageIcon(AssetImage('assets/image_icon/icon_audit_in_progress.png'), size: 50, color: Colors.blue),
    );
  }

  /// 产品上架
  Widget _buildProductsOnShelvesButtom(BuildContext context, MyStorePageItem myStorePageItem, ShopPagesBloc bloc) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(180),
        height: ScreenUtil().setHeight(50),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue[300]
        ),
        child: Text('产品与订单', style: TextStyle(color: Colors.white)),
      ),
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => ShareShopPageCommodityAdmin(myStorePageItem, bloc)));
      },
    );
  }

  /// 审核失败
  Widget _buildAuditFailureButtom(MyStorePageItem myStorePageItem, BuildContext context, ShareShopPageBloc bloc) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(180),
        height: ScreenUtil().setHeight(50),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300]
        ),
        child: Text(
          '审核失败',
          style: TextStyle(
            color: Colors.red
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return MessageDialog(
              widget: Text(TextUtil.isEmpty(myStorePageItem.reason) ? '' : myStorePageItem.reason, style: TextStyle(fontSize: ScreenUtil().setSp(32))),
              onCloseEvent: () {
                Navigator.pop(context);
              },
              onPositivePressEvent: () {
                Navigator.pop(context);
                Navigator.push(context, CupertinoPageRoute(builder:( context) => BlocProvider(bloc: ShareShopPageBloc(), child: ShareShopPageAuthentication(id: myStorePageItem.id, bloc: bloc))));
              },
              negativeText: '取消',
              positiveText: '重新认证',
            );
          }
        );
      },
    );
  }

  /// 认证
  Widget _buildAuthenticationButtom(BuildContext context, int id, ShareShopPageBloc bloc) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(180),
        height: ScreenUtil().setHeight(50),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(8),
          color: Colors.green[500]
        ),
        child: Text('认证', style: TextStyle(color: Colors.white)),
      ),
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder:( context) => BlocProvider(bloc: ShareShopPageBloc(), child: ShareShopPageAuthentication(id: id, bloc: bloc))));
      },
    );
  }
} 