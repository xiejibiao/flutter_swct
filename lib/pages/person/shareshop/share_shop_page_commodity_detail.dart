import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_commodity_admin_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/commodity_detail_util.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_commodity_detail_complete.dart';

class ShareShopPageCommodityDetail extends StatelessWidget {
  final String detail;
  final int commodityId;
  final ShareShopPageCommodityAdminBloc bloc;
  final ShopPagesBloc shopPagesBloc;
  ShareShopPageCommodityDetail(
    this.detail,
    this.commodityId,
    this.bloc,
    this.shopPagesBloc
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑详情'),
        actions: <Widget>[
          IconButton(
            icon: Text('预览'),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShareShopPageCommodityAdminBloc(), child: ShareShopPageCommodityDetailComplete(bloc.items, commodityId, shopPagesBloc))));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: bloc.itemsStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            List<dynamic> _items = sanpshop.data;
            return DragAndDropList<dynamic>(
              _items,
              itemBuilder: (BuildContext context, item) {
                return Stack(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(220),
                      width: ScreenUtil().setWidth(750),
                      child: InkWell(
                        onTap: () {
                          if (item['type'] == 'text') {
                            bloc.editTextItem(item['content'], context, item);
                          } else {
                            bloc.uploadImages(item);
                          }                        
                        },
                        child: Card(
                          elevation: 5,
                          child: SingleChildScrollView(
                            child: item['type'] == 'text' ? 
                              getZefyrView(item['content']) : 
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: buildCommodityImageList(item['content']),
                                ),
                              ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(80, 145, 245, 0.3),
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: IconButton(
                          icon: Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            bloc.removeItem(item);
                          },
                        ),
                      ),
                    )
                  ],
                );
              },
              onDragFinish: (before, after) {
                Map data = _items[before];
                _items.removeAt(before);
                _items.insert(after, data);
              },
              canBeDraggedTo: (one, two) => true,
              dragElevation: 8.0,
            );
          } else {
            return showLoading();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showModalBottomSheetAddTextOrImageList(context);
        },
      ),
    );
  }

  /// 显示添加弹出框
  _showModalBottomSheetAddTextOrImageList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: ScreenUtil().setHeight(150),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage('assets/image_icon/icon_text.png'),
                      color: Colors.blue,
                    ),
                    Text('添加文字')
                  ],
                ),
                onTap: () {
                  bloc.addTextItem(context);
                },
              ),
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage('assets/image_icon/icon_image.png'),
                      color: Colors.blue,
                    ),
                    Text('添加图片')
                  ],
                ),
                onTap: () {
                  bloc.addUploadImages(context);
                },
              )
            ],
          ),
        );
      }
    );
  }
}