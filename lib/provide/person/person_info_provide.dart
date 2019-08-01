import 'package:flutter/material.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';

class PersonInfoProvide with ChangeNotifier {
  PersonInfoVo personInfoVo;

  getPersonInfo(BuildContext context) {
    getToken().then((token) {
      requestPost('getPersonInfo', token: token, context: context).then((val) async {
        PersonInfoVo personInfoVo = PersonInfoVo.fromJson(val);
        setPersonInfoVoProvide(personInfoVo);
      });
    });
  }

  setPersonInfoVoProvide (PersonInfoVo personInfoVo) {
    this.personInfoVo = personInfoVo;
    notifyListeners();
  }
}