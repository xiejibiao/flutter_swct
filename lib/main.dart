import 'package:flutter/material.dart';
import 'package:flutter_swcy/provide/index_page_provide.dart';
import 'package:flutter_swcy/provide/init_page_provide.dart';
import 'package:flutter_swcy/provide/person/person_info_provide.dart';
import 'package:flutter_swcy/router/route_map.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provide/provide.dart';

void main() {
  var initPageProvide = InitPageProvide();
  var personInfoProvide = PersonInfoProvide();
  var indexPageProvide = IndexPageProvide();
  var providers = Providers();
  providers
  ..provide(Provider<InitPageProvide>.value(initPageProvide))
  ..provide(Provider<IndexPageProvide>.value(indexPageProvide))
  ..provide(Provider<PersonInfoProvide>.value(personInfoProvide));
  runApp(
    ProviderNode(
      child: MyApp(),
      providers: providers,
    )
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: OKToast(
        dismissOtherOnShow: true,
        backgroundColor: Color.fromRGBO(96, 185, 244, 1.0),
        textPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        position: ToastPosition.bottom,
        radius: 20.0,
        child: MaterialApp(
          title: '三维创业',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.blue
          ),
          initialRoute: '/',
          routes: routeMap,
        ),
      ),
    );
  }
}