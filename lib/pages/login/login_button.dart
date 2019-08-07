import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swcy/bloc/login_page_bloc.dart';

class LoginButton extends StatelessWidget {
  final LoginPageBloc bloc;
  final GlobalKey<FormState> _formKey;
  LoginButton(
    this._formKey,
    this.bloc
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(730),
      child: StreamBuilder(
        initialData: false,
        stream: bloc.isLoginInStream,
        builder: (context, sanpshop) {
          return FlatButton(
            splashColor: Colors.white54,
            highlightColor: Colors.blue,
            color: Colors.blue,
            padding: EdgeInsets.only(
              top: 10.0, 
              bottom: 10.0
            ),
            child: sanpshop.data ? _loginIn() : _loginText(),
            disabledColor: Colors.blue[300],
            onPressed: sanpshop.data ? null : () => bloc.loginOnPressed(context, _formKey),
          );
        },
      )
    );
  }

  // 登录
  Text _loginText () {
    return Text(
      '登录',
      style: TextStyle(
        color: Colors.white,
        fontSize: ScreenUtil().setSp(32)
      ),
    );
  }

  // 登录中
  Row _loginIn () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitHourGlass(
          color: Colors.white,
          size: 18.0,
        ),
        Text(
          '登录中...',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(32)
          ),
        )
      ],
    );
  }
}