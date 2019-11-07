import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/login_page_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/bloc/person_page_phone_authentication_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginPageBloc _bloc = BlocProvider.of<LoginPageBloc>(context);
    PersonPagePhoneAuthenticationBloc pagePhoneAuthenticationBloc = BlocProvider.of<PersonPagePhoneAuthenticationBloc>(context);
    PersonInfoPageBloc personInfoPageBloc = BlocProvider.of<PersonInfoPageBloc>(context);
    _bloc.initFluwxAuthListen(context, pagePhoneAuthenticationBloc, personInfoPageBloc);
    return Scaffold(
      backgroundColor: Color(0xFF0A0922),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/image_icon/icon_login_logo.png',
            fit: BoxFit.fitWidth,
            width: double.infinity,
          ),
          _buildWeiXinButtom(_bloc, context)
        ],
      ),
    );
  }

  // 微信登录按钮
  Widget _buildWeiXinButtom(LoginPageBloc bloc, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(30),
            width: ScreenUtil().setWidth(125),
            height: ScreenUtil().setWidth(125),
            child: InkWell(
              onTap: () async {
                await bloc.fluwxAuth();
              },
              child: Column(
                children: <Widget>[
                  ImageIcon(
                    AssetImage('assets/image_icon/icon_weixin_logo.png'),
                    size: 42,
                    color: Colors.green[300],
                  ),
                  Text(
                    '微信登录',
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenUtil().setSp(22)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
