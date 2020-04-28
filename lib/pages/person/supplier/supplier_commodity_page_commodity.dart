import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/supplier_commodity_page_bloc.dart';
import 'package:flutter_swcy/bloc/supplier_page_shoppingCar_bloc.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_commodity_page_commodity_detail.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';
import 'package:flutter_swcy/vo/supplier/supplier_commodity_page_vo.dart';

class SupplierCommodityPageCommodity extends StatelessWidget {
  final List<SupplierCommodityPageVoData> _listSupplierCommodityPageVoData;
  final SupplierCommodityPageBloc _bloc;
  final SupplierPageShoppingCarBloc _supplierPageShoppingCarBloc;
  final bool isPurchase;
  SupplierCommodityPageCommodity(
    this._listSupplierCommodityPageVoData,
    this._bloc,
    this._supplierPageShoppingCarBloc,
    this.isPurchase
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildLeftNavigationListItem(),
          Expanded(child: _buildRightCommodityListItem())
        ],
      ),
    );
  }

  /// 左侧导航栏
  Widget _buildLeftNavigationListItem () {
    return Container(
      alignment: Alignment.centerRight,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(80),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey[300]
          )
        )
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
                  width: ScreenUtil().setWidth(_calculationWidth( _listSupplierCommodityPageVoData.length)),
                  alignment: Alignment.center,
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

  double _calculationWidth(int itemLength) {
    double width;
    if (itemLength == 0) {
      width = 750;
    } else {
      width = itemLength >= 4 ? 200 : 750 / itemLength;width = itemLength >= 4 ? 200 : 750 / itemLength;
    }
    return width;
  }

  /// 右侧商品列表
  Widget _buildRightCommodityListItem () {
    return StreamBuilder(
      initialData: 0,
      stream: _bloc.leftIndexStream,
      builder: (context, sanpshop) {
        return _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list.length == 0 ?
                Container(
                  width: ScreenUtil().setWidth(750),
                  child: ShopPageSearchDefaultPage(),
                ) :
                Container(
                  width: ScreenUtil().setWidth(750),
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
                                  height: ScreenUtil().setWidth(200),
                                  width: ScreenUtil().setWidth(750),
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
                                        width: ScreenUtil().setWidth(565),
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
                                            // Text(
                                            //   '型号：${_listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].model}',
                                            //   style: TextStyle(
                                            //     color: Colors.grey,
                                            //     fontSize: ScreenUtil().setSp(28)
                                            //   ),
                                            // ),
                                            Text(
                                              '规格：${_listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].specs}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: ScreenUtil().setSp(28)
                                              ),  
                                            ),
                                            _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].notes == null || _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].notes == '' ? 
                                              Container() :
                                              Text(
                                                '注：${_listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].notes}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: ScreenUtil().setSp(28)
                                                ),  
                                              ),
                                            Container(
                                              width: ScreenUtil().setWidth(565),
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
                                                  isPurchase ? StreamBuilder(
                                                    stream: _supplierPageShoppingCarBloc.commodityInfoVoListStream,
                                                    builder: (context, cleanOrAddSanpshop) {
                                                      if (cleanOrAddSanpshop.hasData && cleanOrAddSanpshop.data.length > 0) {
                                                        return _buildCleanOrAddSupingCarItem(
                                                                                              context, 
                                                                                              _supplierPageShoppingCarBloc, 
                                                                                              cleanOrAddSanpshop.data, 
                                                                                              _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].id, 
                                                                                              _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index]);
                                                      } else {
                                                        return _buildAddSuppingCarItem(
                                                          id: _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].id,
                                                          name: _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].name,
                                                          count: 1,
                                                          price: _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].retailPrice,
                                                          cover: _listSupplierCommodityPageVoData[sanpshop.data].lgmnPage.list[index].cover
                                                        );
                                                      }
                                                    }
                                                  ) : Container()
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

  /// 取消购买或加入购物车按钮
  Widget _buildCleanOrAddSupingCarItem(BuildContext context, SupplierPageShoppingCarBloc bloc, List<CommodityInfoVo> commodityInfoVos, int id, SupplierCommodityInfoVo commodityList) {
    Widget _widget;
    for (int i = 0; i < commodityInfoVos.length; i++) {
      if (commodityInfoVos[i].id == id) {
        _widget = InkWell(
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
                    bloc.removeCarts(id: id);
                  },
                  negativeText: '取消',
                  positiveText: '确认',
                );
              }
            );
          },
          child: Container(
            width: ScreenUtil().setWidth(160),
            height: ScreenUtil().setHeight(45),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(25, 190, 104, 1.0),
              border: Border.all(
                color: Color.fromRGBO(25, 190, 104, 1.0),
              ),
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Text(
              '取消',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          )
        );
        break;
      } else {
        _widget = _buildAddSuppingCarItem(
          id: commodityList.id,
          name: commodityList.name,
          price: commodityList.retailPrice,
          cover: commodityList.cover,
          count: 1
        );
      }
    }
    return _widget;
  }

  Widget _buildAddSuppingCarItem({
      @required id, 
      @required name, 
      @required count, 
      @required price, 
      @required cover}
  ) {
    return InkWell(
      onTap: () {
        _supplierPageShoppingCarBloc.saveCommodityToShoppingCar(
          id: id,
          name: name,
          count: 1,
          price: price,
          cover: cover
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(45),
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
    );
  }
}