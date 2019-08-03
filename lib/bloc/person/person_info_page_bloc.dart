import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/index_page_bloc.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/pages/index_page.dart';
import 'package:flutter_swcy/pages/login/login_page.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';
import 'package:rxdart/rxdart.dart';

class PersonInfoPageBloc extends BlocBase {

  BehaviorSubject<PersonInfoVo> _personInfoVoController = BehaviorSubject<PersonInfoVo>();
  Sink<PersonInfoVo> get _personInfoVoSink => _personInfoVoController.sink;
  Stream<PersonInfoVo> get personInfoVoStream => _personInfoVoController.stream;
  
  getPersonInfo(BuildContext context) {
    getToken().then((token) {
      if (token == null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => route == null);
      } else {
        requestPost('getPersonInfo', token: token, context: context).then((val) async {
          PersonInfoVo personInfoVo = PersonInfoVo.fromJson(val);
          if (personInfoVo.code == '200') {
            _personInfoVoSink.add(personInfoVo);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BlocProvider(bloc: IndexPageBloc(), child: IndexPage())), (route) => route == null);
          } else {
            cleanToken();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => route == null);
          }
        });
      }
    });
  }

   @override
  void dispose() {
    _personInfoVoController.close();
  }
}