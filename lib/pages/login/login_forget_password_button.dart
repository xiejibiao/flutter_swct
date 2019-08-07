import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/register_page_bloc.dart';
import 'package:flutter_swcy/pages/register/register_page.dart';

class LoginForgetPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          highlightColor: Colors.white54,
          splashColor: Colors.white54,
          child: Text(
            '忘记密码',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: Colors.blue
            ),
          ),
          onPressed: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: RegisterPageBloc(), child: RegisterPage('忘记密码'))));
          },
        ),
      ],
    );
  }
}