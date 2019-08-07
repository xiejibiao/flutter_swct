import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/login_page_bloc.dart';

class LoginPhoneFormField extends StatelessWidget {
  final LoginPageBloc bloc;
  LoginPhoneFormField(
    this.bloc
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: bloc.autovalidateStream,
      builder: (context, sanpshop) {
        return TextFormField(
          autovalidate: sanpshop.data,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: '请输入账号',
            counterText: ''
          ),
          maxLength: 11,
          validator: (value) {
            var phoneRegExp = RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
            if (!phoneRegExp.hasMatch(value)) {
              return '请输入正确的手机账号';
            }
          },
          onSaved: (value) {
            bloc.setPhone(value);
          },
        );
      },
    );
  }
}

