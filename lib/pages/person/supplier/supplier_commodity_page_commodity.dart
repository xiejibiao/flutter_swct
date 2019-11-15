import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/supplier_commodity_page_bloc.dart';
import 'package:flutter_swcy/bloc/supplier_page_shoppingCar_bloc.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_commodity_page_commodity_detail.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/supplier/supplier_commodity_page_vo.dart';

class SupplierCommodityPageCommodity extends StatelessWidget {
  final List<SupplierCommodityPageVoData> _listSupplierCommodityPageVoData;
  final SupplierCommodityPageBloc _bloc;
  final SupplierPageShoppingCarBloc _supplierPageShoppingCarBloc;
  SupplierCommodityPageCommodity(
    this._listSupplierCommodityPageVoData,
    this._bloc,
    this._supplierPageShoppingCarBloc
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildLeftNavigationListItem(),
          _buildRightCommodityListItem()
        ],
      ),
    );
  }

  /// 左侧导航栏
  Widget _buildLeftNavigationListItem () {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey[300]
          )
        )
      ),
      width: ScreenUtil().setWidth(180),
      child: ListView.builder(
        itemCount: _listSupplierCommodityPageVoData.length,
        itemBuilder: (context, index) {
          return StreamBuilder(
            initialData: 0,
            stream: _bloc.leftIndexStream,
            builder: (context, sanpshop) {
              return InkWell(
                onTap: () {
                  _bloc.changeLeftIndex(index);
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setHeight(100),
                  decoration: BoxDecoration(
                    color: index == sanpshop.data ? Colors.blue : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200]
                      )
                    )
                  ),
                  child: Text(
                    _listSupplierCommodityPageVoData[index].name,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(32)
                    ),
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 右侧商品列表
  Widget _buildRightCommodityListItem () {
    return StreamBuilder(
      initialData: 0,
      stream: _bloc.leftIndexStream,
      builder: (context, sanpshop) {
        return _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list.length == 0 ?
                Container(
                  width: ScreenUtil().setWidth(570),
                  child: ShopPageSearchDefaultPage(),
                ) :
                Container(
                  width: ScreenUtil().setWidth(570),
                  child: EasyRefresh.custom(
                    footer: BallPulseFooter(
                      enableHapticFeedback: true,
                      enableInfiniteLoad: false
                    ),
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, CupertinoPageRoute(builder: (context) => SupplierCommodityPageCommodityDetail(_listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].detail)));
                              },
                              child: Card(
                                child: Container(
                                  height: ScreenUtil().setWidth(190),
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].cover,
                                          width: ScreenUtil().setWidth(170),
                                          height: ScreenUtil().setWidth(170),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: ScreenUtil().setSp(32)
                                              ),
                                            ),
                                            Text(
                                              '型号：${_listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].model}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: ScreenUtil().setSp(28)
                                              ),
                                            ),
                                            Text(
                                              '规格：${_listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].specs}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: ScreenUtil().setSp(28)
                                              ),  
                                            ),
                                            Container(
                                              width: ScreenUtil().setWidth(360),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    width: ScreenUtil().setWidth(200),
                                                    child: Text(
                                                      '￥${_listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].retailPrice}',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: ScreenUtil().setSp(32)
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _supplierPageShoppingCarBloc.saveCommodityToShoppingCar(
                                                        id: _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].id,
                                                        name: _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].name,
                                                        count: 1,
                                                        price: _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].retailPrice,
                                                        cover: _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].cover
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.all(5.0),
                                                      width: ScreenUtil().setWidth(160),
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(255,218,68, 1.0),
                                                        border: Border.all(
                                                          color: Color.fromRGBO(255,218,68, 1.0)
                                                        ),
                                                        borderRadius: BorderRadius.circular(20.0)
                                                      ),
                                                      child: Text('加入购物车'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            );
                          },
                          childCount: _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: (_listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.pageNumber + 1) == _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.totalPage ? TheEndBaseline() : Container(),
                      )
                    ],
                    onLoad: () async {
                      await _bloc.loadMoreSupplierCommodityPage();
                    }
                  ),
                );
      },
    );
  }
}