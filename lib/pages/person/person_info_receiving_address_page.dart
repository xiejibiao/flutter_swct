import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_receiving_address_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/pages/person/person_info_receiving_address_add.dart';
import 'package:flutter_swcy/vo/person/receiving_address_vo.dart';

class PersonInfoReceivingAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersonInfoReceivingAddressBloc _bloc = BlocProvider.of<PersonInfoReceivingAddressBloc>(context);
    _bloc.getReceivingAddressListByUId(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('收货地址'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 32,
            ),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: PersonInfoReceivingAddressBloc(), child: PersonInfoReceivingAddress(null)))).then((val) {
                _bloc.getReceivingAddressListByUId(context);
              });
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _bloc.receivingAddressVoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            ReceivingAddressVo receivingAddressVo = sanpshop.data;
            if (receivingAddressVo.data.length == 0) {
              return _noAddressAtPresent();
            } else {
              return ListView.builder(
                itemCount: receivingAddressVo.data.length,
                itemBuilder: (context, index) {
                  return _buildAddressItem(receivingAddressVo.data[index], context, _bloc);
                },
              );
            }
          } else {
            return showLoading();
          }
        },
      ),
    );
  }
  
  Widget _buildAddressItem(ReceivingAddress receivingAddress, BuildContext context, PersonInfoReceivingAddressBloc bloc) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(left: 20),
      height: ScreenUtil().setHeight(250),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12
          ),
          top: BorderSide(
            color: Colors.black12
          ),
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildNameAndPhoneAndAddress(receivingAddress),
          _buildEditAndDetele(context, receivingAddress, bloc)
        ],
      ),
    );
  }

  Widget _buildNameAndPhoneAndAddress(ReceivingAddress receivingAddress) {
    return Container(
      height: ScreenUtil().setHeight(160),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12
          )
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                child: Text(
                  receivingAddress.receiverName,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30)
                  ),
                ), 
                width: ScreenUtil().setWidth(200)
              ),
              Text(
                TextUtil.hideNumber(receivingAddress.receiverPhone),
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30)
                )
              ),
            ],
          ),
          Text(
            '${receivingAddress.provinceName}${receivingAddress.cityName}${receivingAddress.areaName}${receivingAddress.address}',
            style: TextStyle(
              color: Colors.black45
            )
          ),
        ],
      ),
    );
  }

  Widget _buildEditAndDetele(BuildContext context, ReceivingAddress receivingAddress, PersonInfoReceivingAddressBloc bloc){
    return Container(
      height: ScreenUtil().setHeight(85),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: PersonInfoReceivingAddressBloc(), child: PersonInfoReceivingAddress(receivingAddress)))).then((val) {
                bloc.getReceivingAddressListByUId(context);
              });
            },
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/image_icon/icon_edit.png',
                  width: ScreenUtil().setWidth(58),
                  color: Colors.black38,
                ),
                Text(
                  '修改',
                  style: TextStyle(
                    color: Colors.black38
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(20),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return MessageDialog(
                    // message: '请问您确定要删除此地址吗？',
                    widget: Text('请问您确定要删除此地址吗？', style: TextStyle(fontSize: ScreenUtil().setSp(32))),
                    onCloseEvent: () {
                      Navigator.pop(context);
                    },
                    onPositivePressEvent: () {
                      Navigator.pop(context);
                      bloc.deleteReceivingAddressById(id: receivingAddress.id, context: context);
                    },
                    negativeText: '取消',
                    positiveText: '确认',
                  );
                }
              );
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.delete_outline,
                  size: 32,
                  color: Colors.black38,
                ),
                Text(
                  '删除',
                  style: TextStyle(
                    color: Colors.black38
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(20),
          ),
        ],
      ),
    );
  }

  // 暂无收货地址
  Widget _noAddressAtPresent() {
    return Container(
      width: ScreenUtil().setWidth(750),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/image_icon/icon_receiving_address.png',
            width: ScreenUtil().setWidth(128),
            color: Colors.black26,
          ),
          Text(
            '暂无收货地址',
            style: TextStyle(
              color: Colors.black26
            ),
          )
        ],
      ),
    );
  }
}