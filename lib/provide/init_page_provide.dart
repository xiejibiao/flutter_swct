import 'package:flutter/material.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';

class InitPageProvide with ChangeNotifier{

  init(BuildContext context) {
    getToken().then((token) {
      if (token ==  null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/loginPage', (route) => route == null);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil('/indexPage', (route) => route == null);
      }
    });
  }
}