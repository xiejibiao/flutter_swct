import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/login_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class LoginPageBloc extends BlocBase{

  String phone, password;

  BehaviorSubject<bool> _isObscureController = BehaviorSubject<bool>();
  Sink<bool> get _isObscureSink => _isObscureController.sink;
  Stream<bool> get isObscureStream => _isObscureController.stream;

  BehaviorSubject<bool> _autovalidateController = BehaviorSubject<bool>();
  Sink<bool> get _autovalidateSink => _autovalidateController.sink;
  Stream<bool> get autovalidateStream => _autovalidateController.stream;

  BehaviorSubject<bool> _isLoginInController = BehaviorSubject<bool>();
  Sink<bool> get _isLoginInSink => _isLoginInController.sink;
  Stream<bool> get isLoginInStream => _isLoginInController.stream;
  

  //  保存Phone
  setPhone (String phone) {
    this.phone = phone;
  }

  // 保存密码
  setPassword(String password) {
    this.password = password;
  }

  // 开启关闭密码模式
  setIsObscure(bool isObscure) {
    _isObscureSink.add(isObscure);
  }

  // 开启关闭自动校验
  setAutovalidate(bool autovalidate) {
    _autovalidateSink.add(autovalidate);
  }

  // 登录请求中
  setIsLoginIn(bool isLoginIn) {
    _isLoginInSink.add(isLoginIn);
  }

  // 登录校验，登录
  loginOnPressed (BuildContext context, GlobalKey<FormState> formKey) async {
    final PersonInfoPageBloc pageBloc = BlocProvider.of<PersonInfoPageBloc>(context);
    if (formKey.currentState.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      formKey.currentState.save();
      var formData = {
        'phone': phone,
        'password': password,
      };
      await requestPost('login', formData: formData).then((val) {
        LoginVo loginVo = LoginVo.fromJson(val);
        if (loginVo.code == '200') {
          saveToken(loginVo.data.accessToken);
          pageBloc.getPersonInfo(context);
        } else {
          showToast(loginVo.message);
        }
      });
    } else {
      setAutovalidate(true);
    }
  }


  @override
  void dispose() {
    _isObscureController.close();
    _autovalidateController.close();
    _isLoginInController.close();
  } 
}