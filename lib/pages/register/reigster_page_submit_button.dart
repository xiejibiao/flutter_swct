import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swcy/bloc/register_page_bloc.dart';

class ReigsterPageSubmitButton extends StatelessWidget {
  final RegisterPageBloc bloc;
  final GlobalKey<FormState> formKey;
  ReigsterPageSubmitButton(
    this.bloc,
    this.formKey
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: bloc.isRegisterInStream,
      builder: (context, sanpshop) {
        return FlatButton(
          splashColor: Colors.white54,
          highlightColor: Colors.blue,
          color: Colors.blue,
          padding: EdgeInsets.only(
            top: 10.0, 
            bottom: 10.0
          ),
          child: sanpshop.data ? _submitTextIn() : _submitText(),
          disabledColor: Colors.blue[300],
          onPressed: sanpshop.data ? null : () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              // RegisterDto registerDto = new RegisterDto('$_confirmPassword', '$_password', '$_phone', '$_smsCode', _registerMap['title'] == '注册' ? 0 : 1);
              bloc.register(context);
            } else {
              
            }
          },
        );
      },
    );
  }

  // 提交按钮提示文字
  Text _submitText () {
    return Text(
      '确认提交',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0
      ),
    );
  }

  // 提交按钮请求中提示文字
  Row _submitTextIn () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitHourGlass(
          color: Colors.white,
          size: 18.0,
        ),
        Text(
          '提交中...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0
          ),
        )
      ],
    );
  }
}