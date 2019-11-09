import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order/share_shop_page_order_admin_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/order_default_image.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/vo/order/get_order_page_by_storeId_vo.dart';

class ShareShopPageOrderAdmin extends StatelessWidget {
  final int shopId;
  ShareShopPageOrderAdmin(
    this.shopId
  );
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    final ShareShopPageOrderAdminBloc _bloc = BlocProvider.of<ShareShopPageOrderAdminBloc>(context);
    _bloc.getOrderPageByShopId(shopId, context);
    return Scaffold(
      appBar: AppBar(
        title: Text('订单管理'),
      ),
      body: StreamBuilder(
        stream: _bloc.getOrderPageByStoreIdVoStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            GetOrderPageByStoreIdVo getOrderPageByStoreIdVo = sanpshop.data;
            if (getOrderPageByStoreIdVo.data.list.length <= 0) {
              return OrderDefaultImage();
            } else {
              return EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.blue[200],
                  textColor: Colors.white,
                  moreInfoColor: Colors.white,
                  showMore: true,
                  loadingText: '加载中...',
                  moreInfo: '上次加载 %T',
                  noMoreText: '加载完成...',
                  loadReadyText: '松手加载...',
                  loadText: '上拉加载更多...',
                ),
                child: ListView(
                  children: <Widget>[
                    _shareShopOrderList(getOrderPageByStoreIdVo.data.list),
                    _bloc.isEnd ? TheEndBaseline() : Text('')
                  ],
                ),
                loadMore: () {
                  return _bloc.loadMoreGetOrderPageByShopId(shopId, context);
                }
              );
            }
          }
        },
      ),
    );
  }

  Widget _shareShopOrderList (List<DataItem> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            InkWell(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setHeight(130),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          list[index].avatar
                        ),
                        radius: 30,
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(list[index].nikeName),
                            Text(
                              '收货地址：${list[index].provinceName}${list[index].cityName}${list[index].areaName}${list[index].address}',
                              overflow: TextOverflow.ellipsis
                            ),
                            Text('下单时间：${DateUtil.getDateStrByMs(list[index].orderTime)}')
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              onTap: () {
                print('订单详情');
              },
            ),
            Positioned(
              top: 5,
              right: 10,
              child: _statusIcon(list[index].status),
            )
          ],
        );
      },
    );
  }

  Widget _statusIcon (int status) {
    Widget _widget;
    switch (status) {
      case 1:
        _widget = Row(
          children: <Widget>[
            Text('待确认'),
            ImageIcon(AssetImage('assets/image_icon/icon_to_be_confirmed.png'), color: Color(0xFFFF9900))
          ],
        );
        break;
      case 2:
        _widget = Row(
          children: <Widget>[
            Text('待发货'),
            ImageIcon(AssetImage('assets/image_icon/icon_to_be_shipped.png'), color: Color(0xFF3399FF))
          ],
        );
        break;
      case 3:
        _widget = Row(
          children: <Widget>[
            Text('已发货'),
            ImageIcon(AssetImage('assets/image_icon/icon_received_goods.png'), color: Color(0xFF3399FF))
          ],
        );
        break;
      default:
        _widget = Row(
          children: <Widget>[
            Text('已收货'),
            ImageIcon(AssetImage('assets/image_icon/icon_shipped.png'), color: Color(0xFF00CC66))
          ],
        );
    }
    return _widget;
  }
}