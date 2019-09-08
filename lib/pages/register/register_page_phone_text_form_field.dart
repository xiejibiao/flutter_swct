import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/register_page_bloc.dart';

class RegisterPagePhoneTextFormField extends StatelessWidget {
  final RegisterPageBloc bloc;
  final GlobalKey<FormFieldState> phoneFieldkey;
  RegisterPagePhoneTextFormField(
    this.bloc,
    this.phoneFieldkey
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: bloc.autovalidateStream,
      builder: (context, sanpshop) {
        return TextFormField(
          key: phoneFieldkey,
          autovalidate: sanpshop.data,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person, size: 28.0),
            labelText: '请输入您的手机号',
            counterText: ''
          ),
          maxLength: 11,
          validator: (value) {
            var phoneRegExp = RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
            if (!phoneRegExp.hasMatch(value)) {
              return '请输入正确的手机账号';
            } else {
              return '';
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