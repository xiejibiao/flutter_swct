import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/vo/shop/shop_type_and_essential_message_vo.dart';

class ShopPagesShopPageEvaluateLeftNavi extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  final List<CommodityTypeList> commodityTypeList;
  final int id;
  final ShopPagesBloc bloc;
  final bool isAdmin;
  ShopPagesShopPageEvaluateLeftNavi(
    this.commodityTypeList,
    this.id,
    this.bloc,
    this.isAdmin,
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.leftIndexStream,
      builder: (context, sanpshop) {
        return Container(
          width: ScreenUtil().setWidth(180),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1, color: Colors.black12)
            )
          ),
          child: ListView.builder(
            itemCount: commodityTypeList.length + 1,
            itemBuilder: (context, index) {
              return _leftInkWellItem(index, commodityTypeList, bloc, commodityTypeList.length, context);
            },
          ),
        );
      },
    );
  }

  Widget _leftInkWellItem (int index, List<CommodityTypeList> commodityTypeList, ShopPagesBloc bloc, int commodityTypeListLength, BuildContext context) {
    if (index == commodityTypeListLength) {
      return isAdmin ?
        InkWell(
          onTap: () {
            _textEditingController.text = '';
            _showAddDialog(context, bloc);
          },
          child: Container(
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(100),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black12)
              )
            ),
            child: Text(
              '+',
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(58)
              ),
            ),
          ),
        ) : 
        Container();
    } else {
      bool isSelected = bloc.thisIndexIsSelected(index);
      return InkWell(
        onTap: () {
          bloc.setLeftIndex(index);
        },
        onLongPress: isAdmin ? () => _onLongPressShowDialog(context, bloc, commodityTypeList[index]) : null,
        child: Container(
          alignment: Alignment.centerLeft,
          height: ScreenUtil().setHeight(100),
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.black12)
            )
          ),
          child: Text(
            commodityTypeList[index].name,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(28)
            ),
          ),
        ),
      );
    }
  }

  // 展示添加弹窗
  _showAddDialog(BuildContext context, ShopPagesBloc bloc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialog(
          title: '添加类型',
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: '请输入类型'
                ),
                validator: (value) {
                  if (TextUtil.isEmpty(value)) {
                    return '请输入类型名称';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          onCloseEvent: () {
            Navigator.pop(context);
          },
          onPositivePressEvent: () {
            if(_formKey.currentState.validate()) {
              bloc.addCommodityType(context, _textEditingController.text, id);
              Navigator.pop(context);
            }
          },
          negativeText: '取消',
          positiveText: '确认',
        );
      }
    );
  }

  // 长按删除、修改操作
  _onLongPressShowDialog(BuildContext context, ShopPagesBloc bloc, CommodityTypeList item) {
    _textEditingController.text = item.name;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialog(
          title: '操作确认',
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: '请输入类型'
                ),
                validator: (value) {
                  if (TextUtil.isEmpty(value)) {
                    return '请输入类型名称';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          onCloseEvent: () {
            Navigator.pop(context);
            _showDeleteDialog(context, bloc, item);
          },
          onPositivePressEvent: () {
            if(_formKey.currentState.validate()) {
              Navigator.pop(context);
              bloc.editCommodityType(item.id, _textEditingController.text, context, id);
            }
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

  _showDeleteDialog(BuildContext context, ShopPagesBloc bloc, CommodityTypeList item) {
    _textEditingController.text = item.name;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialog(
          title: '删除确认',
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('确认删除此类型？删除此类型连带删除此类型下商品！', style: TextStyle(fontSize: ScreenUtil().setSp(32), color: Colors.red)),
          ),
          onCloseEvent: () {
            Navigator.pop(context);
          },
          onPositivePressEvent: () {
            Navigator.pop(context);
            bloc.deleteCommodityType(item.id, context, id);
          },
          negativeText: '取消',
          positiveText: '确认',
        );
      }
    );
  }
}