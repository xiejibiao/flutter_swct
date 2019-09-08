import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/register_page_bloc.dart';

class RegisterPagePasswordTextFormField extends StatelessWidget {
  final RegisterPageBloc bloc;
  RegisterPagePasswordTextFormField(
    this.bloc
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: bloc.autovalidateStream,
      builder: (context, sanpshop) {
        return StreamBuilder(
          initialData: true,
          stream: bloc.isObscureStream,
          builder: (context, isObscureSanpshop) {
            return TextFormField(
              autovalidate: sanpshop.data,
              onSaved: (value) {
                bloc.setPassword(value);
              },
              obscureText: isObscureSanpshop.data,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.https),
                labelText: '输入密码',
                counterText: '',
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: isObscureSanpshop.data ? Colors.grey : Colors.blue,
                  ),
                  onPressed: () {
                    bloc.setIsObscure(!isObscureSanpshop.data);
                  },
                )
              ),
              maxLength: 32,
              validator: (String value) {
                var passwordRegExp = RegExp('^(?![0-9]+\$)(?![a-z]+\$)(?![A-Z]+\$)(?!([^(0-9a-zA-Z)])+\$).{8,32}\$');
                if (!passwordRegExp.hasMatch(value)) {
                  return '密码长度或格式错误';
                } 
                return bloc.setPassword(value);
              },
            );
          },
        );
      },
    );
  }
}