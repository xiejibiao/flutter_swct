import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/shop/commodity_page_by_commodity_type_vo.dart';

class ShopPagesShopPageEvaluateRightList extends StatelessWidget {
  final ShopPagesBloc bloc;
  ShopPagesShopPageEvaluateRightList(
    this.bloc,
  );
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(570),
      child: StreamBuilder(
        stream: bloc.commodityPageByCommodityTypeVoControllerStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return Container(
              width: ScreenUtil().setWidth(570),
              child: showLoading(),
            );
          } else {
            CommodityPageByCommodityTypeVo commodityPageByCommodityTypeVo = sanpshop.data;
            if (commodityPageByCommodityTypeVo.data.list.length == 0) {
              return Container(
                width: ScreenUtil().setWidth(570),
                child: ShopPageSearchDefaultPage(),
              );
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: commodityPageByCommodityTypeVo.data.list.length,
                      itemBuilder: (context, index) {
                        return _buildGoodsItem(commodityPageByCommodityTypeVo.data.list[index]);
                      }
                    ),
                    StreamBuilder(
                      initialData: false,
                      stream: bloc.isTheEndStream,
                      builder: (context, sanpshop) {
                        if (sanpshop.data) {
                          return TheEndBaseline();
                        } else {
                          return Text('');
                        }
                      },
                    )
                  ],
                ),
                loadMore: () {
                  bloc.loadMoreCommodityPageByCommodityTypeId();
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildGoodsItem (CommodityList commodityList) {
    return Container(
      height: ScreenUtil().setHeight(200),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: _buildGoodsItemRow(commodityList),
        ),
      ),
    );
  }

  Widget _buildGoodsItemRow(CommodityList commodityList) {
    return Row(
      children: <Widget>[
        Image.network(
          commodityList.cover,
          width: ScreenUtil().setWidth(180),
          height: ScreenUtil().setWidth(180),
          fit: BoxFit.cover,
        ),
        SizedBox(width: ScreenUtil().setWidth(20.0)),
        Container(
          width: ScreenUtil().setWidth(335),
          child: _buildGoodsItemGoodsMessage(commodityList),
        )
      ],
    );
  }

  Widget _buildGoodsItemGoodsMessage(CommodityList commodityList) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(commodityList.name),
        Text('规格'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '￥${commodityList.price}',
              style: TextStyle(
                color: Colors.red,
                fontSize: ScreenUtil().setSp(28)
              ),
            ),
            _buildGoodsItemNumber()
          ],
        )
      ],
    );
  }

  Widget _buildGoodsItemNumber() {
    return Row(
      children: <Widget>[
        _buildMinus(),
        SizedBox(width: ScreenUtil().setWidth(10)),
        _buildNumber(),
        SizedBox(width: ScreenUtil().setWidth(10)),
        _buildPlus(),
      ],
    );
  }

  Widget _buildMinus() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(25)
        ),
        child: ImageIcon(
          AssetImage('assets/image_icon/icon_minus.png'),
          size: 15,
        ),
      ),
      onTap: () {
        print('点击减号');
      },
    );
  }

  Widget _buildPlus() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(25)
        ),
        child: ImageIcon(
          AssetImage('assets/image_icon/icon_plus.png'),
          size: 15,
        ),
      ),
      onTap: () {
        print('点击加号');
      },
    );
  }

  Widget _buildNumber() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Text('0'),
    );
  }
}