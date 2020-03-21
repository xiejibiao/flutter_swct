import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_swcy/bloc/bloc_provider.dart';
// import 'package:flutter_swcy/bloc/person/person_info_receiving_address_bloc.dart';
// import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/supplier_page_shoppingCar_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
// import 'package:flutter_swcy/pages/person/supplier/supplier_commodity_settlement.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/vo/shop/commodity_info_vo.dart';
import 'package:oktoast/oktoast.dart';

class SupplierPageShoppingCar extends StatelessWidget {
  final SupplierPageShoppingCarBloc _bloc;
  final String supplierName;
  final int supplierId;
  final int storeId;
  SupplierPageShoppingCar(
    this._bloc,
    this.supplierName,
    this.storeId,
    this.supplierId
  );
  @override
  Widget build(BuildContext context) {
    _bloc.getSupplierCommodityStr();
    _bloc.getSupplierCommodityLatestPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildNavigationBottom()
    );
  }

  /// Body
  _buildBody () {
    return StreamBuilder(
      stream: _bloc.commodityInfoVoListStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return showLoading();
        } else {
          List<CommodityInfoVo> list = sanpshop.data;
          if (list.length == 0) {
            return ShopPageSearchDefaultPage();
          } else {
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(750),
                      height: ScreenUtil().setHeight(150),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]
                          )
                        ),
                        color: list[index].delFlag == 1 ? Colors.grey[200] : Colors.white
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(100),
                            child: Checkbox(
                              value: list[index].isCheck,
                              onChanged: list[index].delFlag == 1 ? null : (val) {
                                _bloc.changeCartState(id: list[index].id, checked: val);
                              },
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(550),
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    list[index].cover,
                                    width: ScreenUtil().setWidth(150),
                                    height: ScreenUtil().setWidth(150),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(10),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      list[index].name,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(32)
                                      ),
                                    ),
                                    Text(
                                      '￥${list[index].price}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: ScreenUtil().setSp(28)
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300]
                                        )
                                      ),
                                      width: ScreenUtil().setWidth(160),
                                      height: ScreenUtil().setWidth(50),
                                      child: Row(
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              if (list[index].count > 1) {
                                                _bloc.increaseOrReduceOperation(id: list[index].id, isIncrease: false);
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.grey[300]
                                                  )
                                                ),
                                                color: list[index].count == 1 ? Colors.grey[300] : Colors.white
                                              ),
                                              alignment: Alignment.center,
                                              width: ScreenUtil().setWidth(50),
                                              child: list[index].count == 1 ?
                                                      Text('') :
                                                      Text(
                                                        '-',
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil().setSp(40)
                                                        ),
                                                      ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: ScreenUtil().setWidth(50),
                                            child: Text(
                                              '${list[index].count}',
                                              style: TextStyle(
                                                fontSize: ScreenUtil().setSp(28)
                                              )
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _bloc.increaseOrReduceOperation(id: list[index].id, isIncrease: true);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                    color: Colors.grey[300]
                                                  )
                                                )
                                              ),
                                              alignment: Alignment.center,
                                              width: ScreenUtil().setWidth(50),
                                              child: Text(
                                                '+',
                                                style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(40)
                                                ),
                                              ),
                                            )
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(100),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                size: 42,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return MessageDialog(
                                      widget: Text('请问您确定要删除此商品吗？', style: TextStyle(fontSize: ScreenUtil().setSp(32))),
                                      title: '商品删除确认',
                                      negativeText: '取消',
                                      positiveText: '删除',
                                      onCloseEvent: () {
                                        Navigator.pop(context);
                                      },
                                      onPositivePressEvent: () {
                                        _bloc.removeCarts(id: list[index].id);
                                        Navigator.pop(context);
                                      },
                                    );
                                  }
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    list[index].delFlag == 1 ? 
                    Positioned(
                      top: -10,
                      right: 0,
                      child: ImageIcon(AssetImage('assets/image_icon/icon_Invalid.png'), size: 60),
                    ) :
                    Container()
                  ],
                );
              },
            );
          }
        }
      },
    );
  }

  /// 底部导航
  _buildNavigationBottom () {
    return BottomAppBar(
      child: Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setHeight(90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(180),
              child: Row(
                children: <Widget>[
                  StreamBuilder(
                    stream: _bloc.isAllCheckStream,
                    initialData: true,
                    builder: (context, sanpshop) {
                      return Checkbox(
                        value: sanpshop.data,
                        onChanged: (val) {
                          _bloc.allCheckStateChange(val);
                        },
                      );
                    },
                  ),
                  Text(
                    '全选',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: Colors.blue
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(350),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '合计：',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: Colors.blue
                    ),
                  ),
                  StreamBuilder(
                    initialData: 0.0,
                    stream: _bloc.allPriceStream,
                    builder: (context, sanpshop) {
                      return Text(
                        '￥${sanpshop.data}', 
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            StreamBuilder(
              initialData: 0,
              stream: _bloc.allCommodityCountStream,
              builder: (context, sanpshop) {
                return StreamBuilder(
                  stream: _bloc.allCommodityCountStream,
                  builder: (context, commodityInfoVoListStreamSanpshop) {
                    if (commodityInfoVoListStreamSanpshop.hasData) {
                      return InkWell(
                        onTap: () {
                          if (commodityInfoVoListStreamSanpshop.data == 0) {
                            showToast('请条挑选商品后再同步哦~~');
                            return;
                          }
                          // Navigator.push(
                          //   context, 
                          //   CupertinoPageRoute(
                          //     builder: (context) => BlocProvider(
                          //       child: BlocProvider(
                          //         child: SupplierCommoditySettlement(_bloc, supplierName),
                          //         bloc: ShareShopPageBloc(),
                          //       ), 
                          //       bloc: PersonInfoReceivingAddressBloc()
                          //     )
                          //   )
                          // );
                          _bloc.leagueStoreAddCommodity(storeId, supplierId, context);
                        },
                        // child: Container(
                        //   alignment: Alignment.center,
                        //   margin: EdgeInsets.only(right: 10),
                        //   width: ScreenUtil().setWidth(180),
                        //   height: ScreenUtil().setHeight(70),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //       color: Colors.red
                        //     ),
                        //     color: Colors.red,
                        //     borderRadius: BorderRadius.circular(3.0)
                        //   ),
                        //   child: Text(
                        //     '结算:(${sanpshop.data})',
                        //     style: TextStyle(
                        //       color: Colors.white
                        //     ),
                        //   )
                        // ),
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 10),
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setHeight(70),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red
                            ),
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(3.0)
                          ),
                          child: Text(
                            '申购到盟店:(${sanpshop.data})',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                        ),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 10),
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setHeight(70),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red
                          ),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(3.0)
                        ),
                        child: Container()
                      );
                    }
                  },
                );
              }
            )
          ],
        ),
      ),
    );
  }
}