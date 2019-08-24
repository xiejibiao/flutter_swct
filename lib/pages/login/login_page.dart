import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/login_page_bloc.dart';
import 'package:flutter_swcy/pages/login/login_button.dart';
import 'package:flutter_swcy/pages/login/login_forget_password_button.dart';
import 'package:flutter_swcy/pages/login/login_password_form_field.dart';
import 'package:flutter_swcy/pages/login/login_phone_form_field.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final LoginPageBloc _bloc = BlocProvider.of<LoginPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            LoginPhoneFormField(_bloc),
            LoginPasswordFormField(_bloc),
            SizedBox(height: ScreenUtil().setHeight(20)),
            LoginButton(_formKey, _bloc),
            LoginForgetPasswordButton(),
          ],
        ),
      )
    );
  }
}