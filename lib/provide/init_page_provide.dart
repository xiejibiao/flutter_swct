import 'package:flutter/material.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/provide/person/person_info_provide.dart';
import 'package:provide/provide.dart';

class InitPageProvide with ChangeNotifier{

  init(BuildContext context) async {
    getToken().then((token) async {
      if (token ==  null) {
        // Navigator.of(context).pushNamed(routeName)
        Navigator.of(context).pushNamedAndRemoveUntil('/loginPage', (route) => route == null);
      } else {
        await Provide.value<PersonInfoProvide>(context).getPersonInfo(context);
        Navigator.of(context).pushNamedAndRemoveUntil('/indexPage', (route) => route == null);
      }
    });
  }
}