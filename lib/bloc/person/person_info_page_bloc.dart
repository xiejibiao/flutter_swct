import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/home_page_bloc.dart';
import 'package:flutter_swcy/bloc/index_page_bloc.dart';
import 'package:flutter_swcy/bloc/login_page_bloc.dart';
import 'package:flutter_swcy/bloc/order_page_bloc.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/bloc/person_page_phone_authentication_bloc.dart';
import 'package:flutter_swcy/bloc/store_page_bloc.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/pages/index_page.dart';
import 'package:flutter_swcy/pages/login/login_page.dart';
import 'package:flutter_swcy/pages/person/person_info_edit_nike_name.page.dart';
import 'package:flutter_swcy/pages/person/person_page_phone_authentication.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/person/authentication_msg_vo.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class PersonInfoPageBloc extends BlocBase {

  // 图片
  File file;
  BehaviorSubject<File> _fileController = BehaviorSubject<File>();
  Sink<File> get _fileSink => _fileController.sink;
  Stream<File> get fileStream => _fileController.stream;

  // 用户信息
  BehaviorSubject<PersonInfoVo> _personInfoVoController = BehaviorSubject<PersonInfoVo>();
  Sink<PersonInfoVo> get _personInfoVoSink => _personInfoVoController.sink;
  Stream<PersonInfoVo> get personInfoVoStream => _personInfoVoController.stream;

  // 修改密码
  String password, newPassword, confirmNewPassword;
  BehaviorSubject<String> _newPasswordController = BehaviorSubject<String>();
  Sink<String> get _newPasswordSink => _newPasswordController.sink;
  Stream<String> get newPasswordStream => _newPasswordController.stream;

  /// 分享码
  BehaviorSubject<String> _commendQrcodeStrController = BehaviorSubject<String>();
  Sink<String> get _commendQrcodeStrSink => _commendQrcodeStrController.sink;
  Stream<String> get commendQrcodeStrStream => _commendQrcodeStrController.stream;

  // 认证信息
  String name, idNo;
  bool authenticationLoading = false;
  BehaviorSubject<AuthenticationMsgVo> _authenticationMsgVoController = BehaviorSubject<AuthenticationMsgVo>();
  Sink<AuthenticationMsgVo> get _authenticationMsgVoSink => _authenticationMsgVoController.sink;
  Stream<AuthenticationMsgVo> get authenticationMsgVoStream => _authenticationMsgVoController.stream;
  BehaviorSubject<bool> _authenticationLoadingController = BehaviorSubject<bool>();
  Sink<bool> get _authenticationLoadingSink => _authenticationLoadingController.sink;
  Stream<bool> get authenticationLoadingStream => _authenticationLoadingController.stream;

  
  getPersonInfo(BuildContext context, PersonPagePhoneAuthenticationBloc pagePhoneAuthenticationBloc) {
    getToken().then((token) {
      if (token == null) {
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: LoginPageBloc(), child: LoginPage())), (route) => route == null);
      } else {
        getPerson(context, token).then((val) async {
          if (val == null) {
            cleanToken();
            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: LoginPageBloc(), child: LoginPage())), (route) => route == null);
          } else {
            PersonInfoVo personInfoVo = val;
            if (personInfoVo.code == '200') {
              if (TextUtil.isEmpty(personInfoVo.data.nikeName)) {
                Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => PersonInfoEditNikeNamePage(true)), (route) => route == null);
              } else if (TextUtil.isEmpty(personInfoVo.data.phone)) {
                Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(child: PersonPagePhoneAuthentication(pagePhoneAuthenticationBloc), bloc: PersonPagePhoneAuthenticationBloc())), (route) => route == null);
              } else {
                BlocProvider.of<HomePageBloc>(context).isFirst = true;
                BlocProvider.of<StorePageBloc>(context).getLocationIsFirst = true;
                BlocProvider.of<OrderPageBloc>(context).isFirst = true;
                BlocProvider.of<PersonPageBloc>(context).isFirst = true;
                Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: IndexPageBloc(), child: IndexPage())), (route) => route == null);
              }         
            } else {
              cleanToken();
              Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: LoginPageBloc(), child: LoginPage())), (route) => route == null);
            }
          }
        });
      }
    });
  }

  // 保存图片
  setFile (File file) {
    this.file = file;
    _fileSink.add(file);
  }

  // 上传图片
  upDateAvatar(File croppedFile, BuildContext context) {
    return getToken().then((token) {
      FormData formData = new FormData.from({
        'avatar' : new UploadFileInfo(croppedFile, croppedFile.path.split('/').last)
      });
      return requestPost('upDateAvatar', token: token, context: context, formData: formData).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          showToast('上传成功');
          getPerson(context, token);
        }
        return commenVo;
      });
    });
  }

  Future getPerson(BuildContext context, String token) async {
    return await requestPost('getPersonInfo', token: token, context: context).then((val) {
      if (val == null) {
        showToast('token失效');
        cleanToken();
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: LoginPageBloc(), child: LoginPage())), (route) => route == null);
        return null;
      }
      PersonInfoVo personInfoVo = PersonInfoVo.fromJson(val);
        if (personInfoVo.code == '200') {
          _personInfoVoSink.add(personInfoVo);
        }
        return personInfoVo;
    });
  }

  // 修改昵称
  upDateNikeName(BuildContext context, String nikeName, bool isInitNikeName) {
    if (nikeName.isNotEmpty) {    
      getToken().then((token){
        var formData = {
          'nikeName': nikeName
        };
        requestPost('upDateNikeName', token: token, context: context, formData: formData).then((val){
          CommenVo personInfoCommenVo = CommenVo.fromJson(val);
          if (personInfoCommenVo.code == '200') {
            getPerson(context, token);
            showToast('修改成功');
            if (isInitNikeName) {
              Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: IndexPageBloc(), child: IndexPage())), (route) => route == null);
            } else {
              Navigator.pop(context);
            }
          } else {
            showToast('修改失败');
          }
        });
      });
    } else {
      showToast('请输入昵称');
    }
  }

  // 修改邮箱
  upDateMailbox(BuildContext context, String email) {
    if (!email.isNotEmpty) {
      showToast('请输入邮箱');
    } else {
      if (!RegexUtil.isEmail(email)) {
        showToast('邮箱地址不正确');
      } else {
        getToken().then((token){
          var formData = {
            'email': email
          };
          requestPost('upDateMailbox', token: token, context: context, formData: formData).then((val){
            CommenVo personInfoCommenVo = CommenVo.fromJson(val);
            if (personInfoCommenVo.code == '200') {
              getPerson(context, token);
              showToast('修改成功');
              Navigator.pop(context);
            } else {
              showToast('修改失败');
            }
          });
        });
      }
    }
  }

  setPassword(String password) {
    this.password = password;
  }

  setNewPassword(String newPassword) {
    this.newPassword = newPassword;
    _newPasswordSink.add(newPassword);
  }

  setConfirmNewPassword(String confirmNewPassword) {
    this.confirmNewPassword = confirmNewPassword;
  }

  // 修改密码
  submitUpDatePassword (GlobalKey<FormState> formKey, BuildContext context) async {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        await getToken().then((token) async {
        var formData = {
          'password': password,
          'newPassword': newPassword,
          'confirmPassword': confirmNewPassword
        };
        await requestPost('upDatePassword', token: token, formData: formData, context: context).then((val){
          CommenVo commenVo = CommenVo.fromJson(val);
          switch (commenVo.code) {
            case '200':
              showToast('修改成功， 请重新登录...');
              cleanToken();
              Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: LoginPageBloc(), child: LoginPage())), (route) => route == null);
              break;
            default:
              showToast(commenVo.message);
          }
        });
      });
    }
  }

  // 获取认证信息
  getAuthenticationInfo(BuildContext context) {
    getToken().then((token) async {
      await requestPost('getAuthenticationInfo', context: context, token: token).then((val) {
        AuthenticationMsgVo authenticationMsgVo = AuthenticationMsgVo.fromJson(val);
        _authenticationMsgVoSink.add(authenticationMsgVo);
      });
    });
  }

  setName (String name) {
    this.name = name;
  }

  setIdNo (String idNo) {
    this.idNo = idNo;
  }

  setAuthenticationLoading(bool authenticationLoading) {
    this.authenticationLoading = authenticationLoading;
    _authenticationLoadingSink.add(authenticationLoading);
  }

  // 认证
  authentication(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState.validate() && !authenticationLoading) {
      setAuthenticationLoading(true);
      formKey.currentState.save();
      getToken().then((token) async {
        var formData = {
          'name': name,
          'idNum': idNo
        };
        await requestPost('authentication', token: token, context: context, formData: formData).then((val){
          setAuthenticationLoading(false);
          CommenVo commenVo = CommenVo.fromJson(val);
          switch (commenVo.code) {
            case '200':
              getPerson(context, token);
              showToast('认证成功');
              Navigator.pop(context);
              break;
            case '209':
              showToast('姓名或身份证号码不吻合');
              break;
            default:
              showToast('未知错误');
          }
        });
      });
    }
  }

  commendQrcode(String uid) {
    var formData = {
      'uid': uid
    };
    requestPost('commendQrcode', formData: formData).then((val) {
      _commendQrcodeStrSink.add(val);
    });
  }

  @override
  void dispose() {
    _personInfoVoController.close();
    _fileController.close();
    _newPasswordController.close();
    _authenticationMsgVoController.close();
    _authenticationLoadingController.close();
    _commendQrcodeStrController.close();
  }
}