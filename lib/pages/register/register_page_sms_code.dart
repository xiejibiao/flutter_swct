import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/register_page_bloc.dart';

class RegisterPageSmsCode extends StatefulWidget {
  final RegisterPageBloc bloc;
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormFieldState> phoneFieldkey;
  RegisterPageSmsCode(
    this.bloc,
    this.formKey,
    this.phoneFieldkey
  );
  _RegisterPageSmsCodeState createState() => _RegisterPageSmsCodeState();
}

class _RegisterPageSmsCodeState extends State<RegisterPageSmsCode> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: smsCodeTextFormField(),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            child: getSmsCodeButton(),
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          ),
        )                
      ],
    );
  }

  // 验证码输入框
  Widget smsCodeTextFormField () {
    return StreamBuilder(
      initialData: false,
      stream: widget.bloc.autovalidateStream,
      builder: (context, snapshop) {
        return TextFormField(
          autovalidate: snapshop.data,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.sms, size: 28.0),
            labelText: '短信验证码',
            counterText: ''
          ),
          maxLength: 6,
          keyboardType: TextInputType.number,
          validator: (value) {
            var smsCodeRegExp = RegExp('^\\d{6}\$');
            if (!smsCodeRegExp.hasMatch(value)) {
              return '请输入正确的验证码';
            }
          },
          onSaved: (value) {
            widget.bloc.setSmsCode(value);
          }
        );
      },
    );
  }

  Timer _timer;
  int _countdownTime = 60;
  bool smsButtonIsClick = true;
  String _verifyStr = '获取验证码';
  // 获取验证码按钮
  FlatButton getSmsCodeButton () {
    return FlatButton(
      onPressed: (smsButtonIsClick) ? _startTimer : null,
      splashColor: Colors.white54,
      highlightColor: Colors.blue,
      color: Colors.blue,
      disabledColor: Colors.grey[400],
      child: Text(
        _verifyStr,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0
        )
      ),
    );
  }

  // 倒计时
  void _startTimer () {
    if (widget.phoneFieldkey.currentState.validate()) {
      widget.phoneFieldkey.currentState.save();
      setState(() {
        smsButtonIsClick = false;
      });

      // 发送验证码请求
      widget.bloc.getSmsCode();

      _timer = Timer.periodic(Duration(seconds: 1), (timer){
        if (_countdownTime == 0) {
          _timer?.cancel();
          setState(() {
            smsButtonIsClick = true;
            _countdownTime = 60;
          });
          return;
        } 
        _countdownTime--;
        if (_countdownTime == 0) {
            _verifyStr = '重新发送';
        } else {
          setState(() {
            _verifyStr = '已发送 $_countdownTime s';
          });
        }
      });
    }
  }
}