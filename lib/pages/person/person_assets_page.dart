import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/vo/person/assets_vo.dart';

class PersonAssetsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    _bloc.getMyAssets(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的资产'),
      ),
      body: StreamBuilder(
        stream: _bloc.assetsVoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            AssetsVo assetsVo = sanpshop.data;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _myCard('我的资产', assetsVo.data == null ? 0 : assetsVo.data.assets, 'assets/image_icon/icon_money1.png', null, context),
                  _myCard('我的钱包', assetsVo.data == null ? 0 : assetsVo.data.money, 'assets/image_icon/icon_money.png', null, context),
                  _myCard('在途佣金', assetsVo.data == null ? 0 : assetsVo.data.commission, 'assets/image_icon/icon_commission.png', null, context),
                  _myCard('我的理财', assetsVo.data == null ? 0 : assetsVo.data.finance, 'assets/image_icon/icon_conduct.png', null, context),
                  _myCard('授信额度', assetsVo.data == null ? 0 : assetsVo.data.creditLine, 'assets/image_icon/icon_credit.png', null, context)
                ],
              ),
            );
          } else {
            return showLoading();
          }
        },
      )
    );
  }

  Widget _myCard (String title, double money, String iconPath, Widget widget, BuildContext context) {
    return  InkWell(
      onTap: () {
        if (widget != null) {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
        }
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(iconPath, width: ScreenUtil().setWidth(64)),
                  Text(title, style: TextStyle(fontSize: ScreenUtil().setSp(32)))
                ],
              ),
              Text(money.toString(), style: TextStyle(fontSize: ScreenUtil().setSp(32)))
            ],
          ),
        ),
      ),
    );
  }
}