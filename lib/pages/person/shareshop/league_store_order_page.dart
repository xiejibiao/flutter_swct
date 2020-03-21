import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/order/share_shop_page_order_admin_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/common/order_default_image.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/vo/supplier/league_store_order_page_vo.dart';

class LeagueStoreOrderPage extends StatelessWidget {
  final int storeId;
  LeagueStoreOrderPage(
    this.storeId
  );
  @override
  Widget build(BuildContext context) {
    final ShareShopPageOrderAdminBloc _bloc = BlocProvider.of<ShareShopPageOrderAdminBloc>(context);
    _bloc.getLeagueStoreOrderPage(storeId, context);
    return Scaffold(
      appBar: AppBar(
        title: Text('盟店进货')
      ),
      body: StreamBuilder(
        stream: _bloc.leagueStoreOrderPageVoStream,
        builder: (context, sanpshot) {
          if (sanpshot.hasData) {
            LeagueStoreOrderPageVo leagueStoreOrderPageVo = sanpshot.data;
            if (leagueStoreOrderPageVo.data.list.length <= 0) {
              return OrderDefaultImage();
            } else {
              return EasyRefresh.custom(
                footer: BallPulseFooter(
                  enableHapticFeedback: true,
                  enableInfiniteLoad: false
                ),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          padding: EdgeInsets.only(top: 10),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0)
                            )
                          ),
                          width: ScreenUtil().setWidth(750),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('下单时间：${DateUtil.getDateStrByMs(leagueStoreOrderPageVo.data.list[index].orderTime)}', style: TextStyle(color: Colors.grey)),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: leagueStoreOrderPageVo.data.list[index].list.length,
                                itemBuilder: (context, listViewIndex) {
                                  return Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.network(
                                              leagueStoreOrderPageVo.data.list[index].list[listViewIndex].cover,
                                              width: ScreenUtil().setWidth(100),
                                              height: ScreenUtil().setWidth(100),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(leagueStoreOrderPageVo.data.list[index].list[listViewIndex].commodityName),
                                              Text("商品单价： ￥${leagueStoreOrderPageVo.data.list[index].list[listViewIndex].price}"),
                                            ],
                                          ),
                                          Text("数量： ￥${leagueStoreOrderPageVo.data.list[index].list[listViewIndex].num}"),
                                        ],
                                      ),
                                    )
                                  );
                                }
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: ScreenUtil().setWidth(750),
                                child: _buildItemButtom(leagueStoreOrderPageVo.data.list[index].status, leagueStoreOrderPageVo.data.list[index].id, context, _bloc)
                              )
                            ]
                          )
                        );
                      },
                      childCount: leagueStoreOrderPageVo.data.list.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: (leagueStoreOrderPageVo.data.pageNumber + 1) == leagueStoreOrderPageVo.data.totalPage ? TheEndBaseline() : Container(),
                  )
                ],
                onLoad: () async {
                  await _bloc.onLoadLeagueStoreOrderPage(storeId, context);
                }
              );
            }
          } else {
            return showLoading();
          }
        }
      ),
    );
  }

  Widget _buildItemButtom(int status, String id, BuildContext context, ShareShopPageOrderAdminBloc bloc) {
    if (status == 2) {
      return _buildStatusContainer('assets/image_icon/icon_to_be_confirmed.png', Color(0xFFFF9900), '待发货');
    } else if (status == 3) {
      return InkWell(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return MessageDialog(
                widget: Text('确定已收到商品？', style: TextStyle(fontSize: ScreenUtil().setSp(32))),
                onCloseEvent: () {
                  Navigator.pop(context);
                },
                onPositivePressEvent: () {
                  Navigator.pop(context);
                  bloc.leagueStoreOrderConfirmReceipt(id, context);
                },
                negativeText: '取消',
                positiveText: '确认',
              );
            }
          );
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(180),
          height: ScreenUtil().setHeight(55),
          child: Text(
            '确认收货',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color(0xFF3399FF)
          ),
        )
      );
    } else {
      return _buildStatusContainer('assets/image_icon/icon_shipped.png', Color(0xFF00CC66), '已收货');
    }
  }

  Widget _buildStatusContainer(String iconPath, Color color, String msg) {
    return Container(
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ImageIcon(
                  AssetImage(iconPath),
                  size: 28,
                  color: color
                ),
                Text(msg, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          );
  }
}