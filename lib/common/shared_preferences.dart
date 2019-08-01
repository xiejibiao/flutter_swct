import 'package:shared_preferences/shared_preferences.dart';

// 保存Token
void saveToken (String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('TOKEN', token);
}

// 获取Token
Future<String> getToken () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get('TOKEN');
}

// 获取Token
initCheckToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  TokenTemp tokenTemp = TokenTemp(prefs.get('TOKEN'));
  return tokenTemp;
}

// 清空Token
Future cleanToken () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('TOKEN');
}

class TokenTemp {
  String token;
  TokenTemp(
    this.token
  );

  TokenTemp.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}