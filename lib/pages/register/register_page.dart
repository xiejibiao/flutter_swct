import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/register_page_bloc.dart';
import 'package:flutter_swcy/pages/register/register_page_confirm_password_text_form_field.dart';
import 'package:flutter_swcy/pages/register/register_page_password_text_form_field.dart';
import 'package:flutter_swcy/pages/register/register_page_phone_text_form_field.dart';
import 'package:flutter_swcy/pages/register/register_page_sms_code.dart';
import 'package:flutter_swcy/pages/register/reigster_page_submit_button.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  RegisterPage(
    this.title
  );
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFieldkey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    final RegisterPageBloc _bloc = BlocProvider.of<RegisterPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              RegisterPagePhoneTextFormField(_bloc, _phoneFieldkey),
              RegisterPageSmsCode(_bloc, _formKey, _phoneFieldkey),
              RegisterPagePasswordTextFormField(_bloc),
              RegisterPageConfirmPasswordTextFormField(_bloc),
              SizedBox(height: 5.0),
              tipsText(),
              SizedBox(height: 20.0),
              ReigsterPageSubmitButton(_bloc, _formKey)
            ],
          ),
        ),
      ),
    );
  }

  // 提示文字
  Text tipsText () {
    return Text(
      '密码长度8-32位，须包含数字、字母、符号至少两种或以上格式',
      style: TextStyle(
        fontSize: 12.0,
        color: Colors.grey
      ),
    );
  }
}