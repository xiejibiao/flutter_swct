import 'package:flutter/material.dart';
import 'package:flutter_swcy/pages/index_page.dart';
import 'package:flutter_swcy/pages/init_page.dart';
import 'package:flutter_swcy/pages/login/login_page.dart';

final Map<String, WidgetBuilder> routeMap = {
  '/': (BuildContext context) => InitPage(),            // 初始化
  '/loginPage': (BuildContext context) => LoginPage(),  // 登录
  '/indexPage': (BuildContext context) => IndexPage(),  // 首页
};