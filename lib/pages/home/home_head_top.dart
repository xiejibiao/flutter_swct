import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/pages/person/person_share_page.dart';
import 'package:flutter_swcy/vo/home/home_vo.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';

class HomeHeadTop extends StatelessWidget {
  final HomePageVo homePageVo;
  HomeHeadTop(
    this.homePageVo
  );
  @override
  Widget build(BuildContext context) {
    final PersonInfoPageBloc _personInfoBloc = BlocProvider.of<PersonInfoPageBloc>(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: _head(context, _personInfoBloc),
      ),
    );
  }

  Widget _head (BuildContext context, PersonInfoPageBloc personInfoBloc) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _heanTop(context, personInfoBloc),
            _qrCode(context)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildGradeCard('个力', 'assets/image_icon/icon_person.png', homePageVo.data.personPower),
            _buildGradeCard('信用分', 'assets/image_icon/icon_credit.png', 0),
            _buildGradeCard('团力', 'assets/image_icon/icon_team.png', homePageVo.data.groupPower),
          ],
        )
      ],
    );
  }

  // 头像昵称
  Widget _heanTop (BuildContext context, PersonInfoPageBloc personInfoBloc) {
    return StreamBuilder(
      stream: personInfoBloc.personInfoVoStream,
      builder: (context, snapshop) {
        if (snapshop.hasData) {
          PersonInfoVo personInfoVo = snapshop.data;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.network(
                  personInfoVo.data.avatar,
                  width: ScreenUtil().setWidth(170),
                  height: ScreenUtil().setWidth(170),
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(10),
              ),
              Container(
                width: ScreenUtil().setWidth(420),
                child: Text(
                  personInfoVo.data.nikeName,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(32)
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          );
        } else {
          return Text('');
        }
      },
    );
  }

  // 二维码
  Widget _qrCode (BuildContext context) {
    return InkWell(
      splashColor: Colors.white,
      highlightColor: Colors.white,
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => PersonSharePage()));
      },
      child: Image.asset(
        'assets/image_icon/icon_qr_code.png',
        width: ScreenUtil().setWidth(80.0),
      ),
    );
  }

  Card _buildGradeCard (String title, String iconPath, int sum) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  iconPath,
                  color: Color(0xFFFF9800),
                  width: ScreenUtil().setWidth(56.0),
                ),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Text(title)
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(15)),
            Text('$sum')
          ],
        ),
      ),
    );
  }
}