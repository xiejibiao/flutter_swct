import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_commodity_admin_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_commodity_admin_add_edit.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_commodity_detail.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/pages/shop/shop_pages/shop_pages_shop_page_evaluate_details.dart';
import 'package:flutter_swcy/vo/shop/commodity_page_by_commodity_type_vo.dart';

class ShopPagesShopPageEvaluateRightList extends StatelessWidget {
  final ShopPagesBloc bloc;
  final bool isAdmin;
  final int commodityTypeListLength;
  ShopPagesShopPageEvaluateRightList(
    this.bloc,
    this.isAdmin,
    this.commodityTypeListLength
  );
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    final ShareShopPageBloc _shareShopPageBloc = BlocProvider.of<ShareShopPageBloc>(context);
    final ShareShopPageCommodityAdminBloc _shareShopPageCommodityAdminBloc = BlocProvider.of<ShareShopPageCommodityAdminBloc>(context);
    return Container(
      width: ScreenUtil().setWidth(570),
      child: StreamBuilder(
        stream: bloc.commodityPageByCommodityTypeVoStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return commodityTypeListLength > 0 ?
            Container(
              width: ScreenUtil().setWidth(570),
              child: showLoading(),
            ) :
            ShopPageSearchDefaultPage();
          } else {
            CommodityPageByCommodityTypeVo commodityPageByCommodityTypeVo = sanpshop.data;
            if (commodityPageByCommodityTypeVo.data.list.length == 0) {
              return isAdmin ? 
                _buildAddCommodity(bloc, context) : 
                Container(
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
                        return _buildGoodsItem(commodityPageByCommodityTypeVo.data.list[index], context, bloc, _shareShopPageBloc, _shareShopPageCommodityAdminBloc);
                      }
                    ),
                    StreamBuilder(
                      initialData: false,
                      stream: bloc.isTheEndStream,
                      builder: (context, sanpshop) {
                        if (sanpshop.data) {
                          return Column(
                            children: <Widget>[
                              isAdmin ? _buildAddCommodity(bloc, context) : Text(''),
                              TheEndBaseline()
                            ],
                          );
                        } else {
                          return Text('');
                        }
                      },
                    )
                  ],
                ),
                loadMore: () {
                  return bloc.loadMoreCommodityPageByCommodityTypeId();
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildGoodsItem (CommodityList commodityList, BuildContext context, ShopPagesBloc bloc, ShareShopPageBloc shareShopPageBloc, ShareShopPageCommodityAdminBloc shareShopPageCommodityAdminBloc) {
    return InkWell(
      onTap: () {
        if (isAdmin) {
          shareShopPageCommodityAdminBloc.getItems(commodityList.detail);
          Navigator.push(context, CupertinoPageRoute(builder: (context) => ShareShopPageCommodityDetail(commodityList.detail, commodityList.id, shareShopPageCommodityAdminBloc, bloc, false, shareShopPageBloc)));
        } else {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => ShopPagesShopPageEvaluateDetails(commodityList.detail)));
        }
      },
      onLongPress: isAdmin ? () => _onLongPressShowDeleteAndEditDialog(context, shareShopPageBloc, commodityList, bloc) : null,
      child: Container(
        height: ScreenUtil().setHeight(190),
        child: Card(
          color: commodityList.status == 0 ? Colors.grey[200] : Colors.white,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: _buildGoodsItemRow(commodityList, bloc, shareShopPageBloc),
          ),
        ),
      ),
    );
  }

  Widget _buildGoodsItemRow(CommodityList commodityList, ShopPagesBloc bloc, ShareShopPageBloc shareShopPageBloc) {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            commodityList.cover,
            width: ScreenUtil().setWidth(180),
            height: ScreenUtil().setWidth(180),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(20.0)),
        Container(
          width: ScreenUtil().setWidth(327),
          child: _buildGoodsItemGoodsMessage(commodityList, bloc, shareShopPageBloc),
        )
      ],
    );
  }

  Widget _buildGoodsItemGoodsMessage(CommodityList commodityList, ShopPagesBloc bloc, ShareShopPageBloc shareShopPageBloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(commodityList.name),
        Text('规格: ${commodityList.specs}'),
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
            _addShopingcar(commodityList, bloc, shareShopPageBloc)
          ],
        )
      ],
    );
  }

  Widget _addShopingcar(CommodityList commodityList, ShopPagesBloc bloc, ShareShopPageBloc shareShopPageBloc) {
    if (isAdmin) {
      return InkWell(
        onTap: () async {
          shareShopPageBloc.upperShelfAndLowerShelf(commodityList.id, bloc);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: commodityList.status == 0 ? Colors.green : Color.fromRGBO(255,218,68, 1.0),
            border: Border.all(
              color: commodityList.status == 0 ? Colors.green : Color.fromRGBO(255,218,68, 1.0),
            ),
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: commodityList.status == 0 ? Text('点击上架', style: TextStyle(color: Colors.white)) : Text('点击下架'),
        ),
      );
    } else {
      return InkWell(
        onTap: () async {
          await bloc.saveCommodityToShoppingCar(id: commodityList.id, name: commodityList.name, count: 1, price: commodityList.price, cover: commodityList.cover);
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

  // 添加商品框
  Widget _buildAddCommodity(ShopPagesBloc bloc, BuildContext context) {
    return InkWell(
      onTap: () {
        int commodityTypeId = bloc.commodityTypeList[bloc.leftIndex].id;
        String commodityTypeName = bloc.commodityTypeList[bloc.leftIndex].name;
        Navigator.push(context, 
          CupertinoPageRoute(builder: (context) => 
            BlocProvider(bloc: ShareShopPageBloc(), 
              child: ShareShopPageCommodityAdminAddEdit(commodityTypeId, commodityTypeName, bloc, true)
            )
          )
        );
      },
      child: Card(
        child: Container(
          alignment: Alignment.center,
          height: ScreenUtil().setHeight(180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('+', style: TextStyle(fontSize: ScreenUtil().setSp(68))),
              Text('添加商品', style: TextStyle(fontSize: ScreenUtil().setSp(38)))
            ],
          ),
        ),
      ),
    );
  }

  /// 长按商品弹出删除，修改按钮
  _onLongPressShowDeleteAndEditDialog(BuildContext context, ShareShopPageBloc bloc, CommodityList commodityList, ShopPagesBloc shopPagesBloc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialog(
          title: '操作确认',
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('请确认操作！', style: TextStyle(fontSize: ScreenUtil().setSp(32))),
          ),
          onCloseEvent: () {
            Navigator.pop(context);
            _showDeleteCommodityDialog(context, bloc, commodityList, shopPagesBloc);
          },
          onPositivePressEvent: () {
            int commodityTypeId = shopPagesBloc.commodityTypeList[shopPagesBloc.leftIndex].id;
            String commodityTypeName = shopPagesBloc.commodityTypeList[shopPagesBloc.leftIndex].name;
            Navigator.pop(context);
            Navigator.push(context, 
              CupertinoPageRoute(builder: (context) => 
                BlocProvider(bloc: ShareShopPageBloc(), 
                  child: ShareShopPageCommodityAdminAddEdit(commodityTypeId, commodityTypeName, shopPagesBloc, false, item: commodityList)
                )
              )
            );
          },
          onIconCloseEvent: () {
            Navigator.pop(context);
          },
          negativeText: '删除',
          positiveText: '修改',
        );
      }
    );
  }

  /// 删除商品
  _showDeleteCommodityDialog(BuildContext context, ShareShopPageBloc bloc, CommodityList commodityList, ShopPagesBloc shopPagesBloc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialog(
          title: '删除确认',
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('确认删除此商品？', style: TextStyle(fontSize: ScreenUtil().setSp(32), color: Colors.red)),
          ),
          onCloseEvent: () {
            Navigator.pop(context);
          },
          onPositivePressEvent: () {
            Navigator.pop(context);
            bloc.deleteCommodity(commodityList.id, shopPagesBloc);
          },
          negativeText: '取消',
          positiveText: '确认',
        );
      }
    );
  }
}