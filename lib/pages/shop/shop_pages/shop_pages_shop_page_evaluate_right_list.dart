import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate_details.dart';
import 'package:flutter_swcy/vo/shop/commodity_page_by_commodity_type_vo.dart';

class ShopPagesShopPageEvaluateRightList extends StatelessWidget {
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    final ShopPagesBloc _bloc = BlocProvider.of<ShopPagesBloc>(context);
    return Container(
      width: ScreenUtil().setWidth(570),
      child: StreamBuilder(
        stream: _bloc.commodityPageByCommodityTypeVoStream,
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
                        return _buildGoodsItem(commodityPageByCommodityTypeVo.data.list[index], context, _bloc);
                      }
                    ),
                    StreamBuilder(
                      initialData: false,
                      stream: _bloc.isTheEndStream,
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
                  _bloc.loadMoreCommodityPageByCommodityTypeId();
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildGoodsItem (CommodityList commodityList, BuildContext context, ShopPagesBloc bloc) {
    return InkWell(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => ShopPagesShopPageEvaluateDetails(commodityList.detail)));
      },
      child: Container(
        height: ScreenUtil().setHeight(200),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: _buildGoodsItemRow(commodityList, bloc),
          ),
        ),
      ),
    );
  }

  Widget _buildGoodsItemRow(CommodityList commodityList, ShopPagesBloc bloc) {
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
          child: _buildGoodsItemGoodsMessage(commodityList, bloc),
        )
      ],
    );
  }

  Widget _buildGoodsItemGoodsMessage(CommodityList commodityList, ShopPagesBloc bloc) {
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
            _addShopingcar(commodityList, bloc)
          ],
        )
      ],
    );
  }

  Widget _addShopingcar(CommodityList commodityList, ShopPagesBloc bloc) {
    return InkWell(
      onTap: () async {
        await bloc.saveCommodity(commodityList.id, commodityList.name, 1, commodityList.price, commodityList.cover);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255,218,68, 1.0),
          border: Border.all(
            color: Color.fromRGBO(255,218,68, 1.0)
          ),
          borderRadius: BorderRadius.circular(20.0)
        ),
        child: Text('加入购物车'),
      ),
    );
  }
}