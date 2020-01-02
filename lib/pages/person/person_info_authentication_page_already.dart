import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/vo/person/authentication_msg_vo.dart';

class PersonInfoAuthenticationPageAlready extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersonInfoPageBloc _bloc = BlocProvider.of<PersonInfoPageBloc>(context);
    _bloc.getAuthenticationInfo(context);
    return StreamBuilder(
      stream: _bloc.authenticationMsgVoStream,
      builder: (context, sanpshop) {
        if (sanpshop.hasData) {
          AuthenticationMsgVo authenticationMsgVo = sanpshop.data;
          return SingleChildScrollView(
            child: _buildCardItem(authenticationMsgVo.data),
          );
        } else {
          return showLoading();
        }
      },
    );
  }

  // Item 总汇
  Column _buildCardItem(AuthenticationMsg authenticationMsg) {
    return Column(
      children: <Widget>[
        _buildCard('assets/image_icon/icon_name.png', '姓名', authenticationMsg.name),
        // _buildCard('assets/image_icon/icon_phone.png', '手机号', authenticationMsg.phone),
        _buildCard('assets/image_icon/icon_id.png', '身份证号', authenticationMsg.idNum),
      ],
    );
  }

  // card 样式
  Card _buildCard (String iconPath, String title, String value) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  ImageIcon(
                    AssetImage(
                      iconPath
                    ),
                    color: Colors.blue,
                    size: 32,
                  ),
                  SizedBox(width: ScreenUtil().setWidth(20)),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(32)
                    )
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(32),
                color: Colors.grey[600]
              )
            ),
          ],
        ),
      ),
    );
  }
}