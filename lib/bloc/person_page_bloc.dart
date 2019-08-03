import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/person/person_vo.dart';
import 'package:rxdart/rxdart.dart';

class PersonPageBloc extends BlocBase {

  BehaviorSubject<PersonVo> _personVoController = BehaviorSubject<PersonVo>();
  Sink<PersonVo> get _homeVoSink => _personVoController.sink;
  Stream<PersonVo> get homeVoStream => _personVoController.stream;

  getPersonAndAdList(BuildContext context) {
    return getToken().then((token) async {
      return await requestPost('getPersonAndAdList', token: token, context: context).then((val) {
        PersonVo personVo = PersonVo.fromJson(val);
        _homeVoSink.add(personVo);
        return personVo;
      });
    });
  }

  @override
  void dispose() {
    _personVoController.close();
  }
}