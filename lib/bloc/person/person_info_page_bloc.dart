import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/index_page_bloc.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/pages/index_page.dart';
import 'package:flutter_swcy/pages/login/login_page.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class PersonInfoPageBloc extends BlocBase {

  File file;
  BehaviorSubject<File> _fileController = BehaviorSubject<File>();
  Sink<File> get _fileSink => _fileController.sink;
  Stream<File> get fileStream => _fileController.stream;

  BehaviorSubject<PersonInfoVo> _personInfoVoController = BehaviorSubject<PersonInfoVo>();
  Sink<PersonInfoVo> get _personInfoVoSink => _personInfoVoController.sink;
  Stream<PersonInfoVo> get personInfoVoStream => _personInfoVoController.stream;
  
  getPersonInfo(BuildContext context) {
    getToken().then((token) {
      if (token == null) {
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginPage()), (route) => route == null);
      } else {
        requestPost('getPersonInfo', token: token, context: context).then((val) async {
          PersonInfoVo personInfoVo = PersonInfoVo.fromJson(val);
          if (personInfoVo.code == '200') {
            _personInfoVoSink.add(personInfoVo);
            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: IndexPageBloc(), child: IndexPage())), (route) => route == null);
          } else {
            cleanToken();
            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginPage()), (route) => route == null);
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
        }
        return commenVo;
      });
    });
  }

   @override
  void dispose() {
    _personInfoVoController.close();
    _fileController.close();
  }
}