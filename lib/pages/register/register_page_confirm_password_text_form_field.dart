import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/register_page_bloc.dart';

class RegisterPageConfirmPasswordTextFormField extends StatelessWidget {
  final RegisterPageBloc bloc;
  RegisterPageConfirmPasswordTextFormField(
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
          stream: bloc.confirmIsObscureStream,
          builder: (context, confirmIsObscureSanpShop) {
            return TextFormField(
              autovalidate: sanpshop.data,
              onSaved: (value) {
                bloc.setConfirmPassword(value);
              },
              obscureText: confirmIsObscureSanpShop.data,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.https),
                labelText: '确认密码',
                counterText: '',
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: confirmIsObscureSanpShop.data ? Colors.grey : Colors.blue,
                  ),
                  onPressed: () {
                    bloc.setConfirmIsObscure(!confirmIsObscureSanpShop.data);
                  },
                )
              ),
              maxLength: 32,
              validator: (String value) {
                if (value != bloc.password) {
                  return '两次密码不相同';
                } else {
                  return '';
                }
              },
            );
          },
        );
      },
    );
  }
}