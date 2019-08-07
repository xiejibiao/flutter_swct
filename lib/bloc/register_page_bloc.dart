import 'package:flutter/widgets.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class RegisterPageBloc extends BlocBase {
  String _phone, _smsCode, password, _confirmPassword;   

  // 是否为密码模式
  BehaviorSubject<bool> _isObscureController = BehaviorSubject<bool>();
  Sink<bool> get _isObscureSink => _isObscureController.sink;
  Stream<bool> get isObscureStream => _isObscureController.stream;

  // 是否开启自动校验
  BehaviorSubject<bool> _autovalidateController = BehaviorSubject<bool>();
  Sink<bool> get _autovalidateSink => _autovalidateController.sink;
  Stream<bool> get autovalidateStream => _autovalidateController.stream;

  // 是否注册请求中
  BehaviorSubject<bool> _isRegisterInController = BehaviorSubject<bool>();
  Sink<bool> get _isRegisterInSink => _isRegisterInController.sink;
  Stream<bool> get isRegisterInStream => _isRegisterInController.stream;
  
  // 是否为密码模式
  BehaviorSubject<bool> _confirmIsObscureController = BehaviorSubject<bool>();
  Sink<bool> get _confirmIsObscureSink => _confirmIsObscureController.sink;
  Stream<bool> get confirmIsObscureStream => _confirmIsObscureController.stream;

  setPhone(String phone) {
    this._phone = phone;
  }

  setSmsCode(String smsCode) {
    this._smsCode = smsCode;
  }

  setPassword(String password) {
    this.password = password;
  }

  setConfirmPassword(String confirmPassword) {
    this._confirmPassword = confirmPassword;
  }

  setIsObscure(bool isObscure) {
    _isObscureSink.add(isObscure);
  }

  setAutovalidate(bool autovalidate) {
    _autovalidateSink.add(autovalidate);
  }

  setIsRegisterIn(bool isRegisterIn) {
    _isRegisterInSink.add(isRegisterIn);
  }

  setConfirmIsObscure(bool confirmIsObscure) {
    _confirmIsObscureSink.add(confirmIsObscure);
  }

  getSmsCode() async {
    var formData = {
      'phone': _phone
    };
    await requestPost('getSmsCode', formData: formData).then((val) {
      CommenVo commenVo = CommenVo.fromJson(val);
      showToast(commenVo.message);
    });
  }

  register(BuildContext context) async {
    var formData = {
      'smsCode': _smsCode,
      'phone': _phone,
      'password': password,
      'confirmPassword': _confirmPassword,
      'puid': '',
      'type': 1
    };
    await requestPost('register', formData: formData).then((val) {
      CommenVo commenVo = CommenVo.fromJson(val);
      showToast(commenVo.message);
      if (commenVo.code == '200') {
        Navigator.pop(context);
      } 
    });
  }


  @override
  void dispose() {
    _isObscureController.close();
    _autovalidateController.close();
    _isRegisterInController.close();
    _confirmIsObscureController.close();
  }
}