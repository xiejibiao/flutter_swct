import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_receiving_address_bloc.dart';
import 'package:flutter_swcy/pages/person/person_info_authentication_page.dart';
import 'package:flutter_swcy/pages/person/person_info_edit_mailbox_page.dart';
// import 'package:flutter_swcy/pages/person/person_info_edit_password_page.dart';
import 'package:flutter_swcy/pages/person/person_info_receiving_address_page.dart';
import 'package:flutter_swcy/pages/person/person_share_page.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';

class PersonInfoPageItem extends StatelessWidget {
  final PersonInfoVo personInfoVo;
  PersonInfoPageItem(
    this.personInfoVo
  );
  @override
  Widget build(BuildContext context) {
    bool isAuthentication = personInfoVo.data.authentication;
    return Column(
      children: <Widget>[
        _buildItem('assets/image_icon/icon_authentication.png', '实名认证', PersonInfoAuthenticationPage(isAuthentication), context, value: isAuthentication ? '已认证' : '未认证'),
        _buildItem('assets/image_icon/icon_mailbox.png', '邮箱', PersonInfoEditMailboxPage(), context, value: personInfoVo.data.email),
        _buildItem('assets/image_icon/icon_qr_code.png', '我的分享码', PersonSharePage(), context),
        // _buildItem('assets/image_icon/icon_edit_password.png', '修改密码', PersonInfoEditPasswordPage(), context),
        _buildItem('assets/image_icon/icon_receiving_address.png', '收货地址', BlocProvider(bloc: PersonInfoReceivingAddressBloc(), child: PersonInfoReceivingAddressPage(isSelectedAddress: false)), context),
      ],
    );
  }

  Card _buildCard (String iconPath, String title, String value) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  iconPath,
                  width: ScreenUtil().setWidth(64),
                ),
                Text(
                  title,
                  style: TextStyle (
                    fontSize: ScreenUtil().setSp(32)
                  ),
                ),
              ],
            ),
            Row (
              children: <Widget>[
                Text(
                  value,
                  style: TextStyle (
                    fontSize: ScreenUtil().setSp(32)
                  ),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell _buildItem (String iconPath, String title, Widget page, BuildContext context, {String value}) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
      },
      child: _buildCard(iconPath, title, value == null ? '' : value),
    );
  }
}