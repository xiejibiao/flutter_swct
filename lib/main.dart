import 'package:flutter/material.dart';
import 'package:flutter_swcy/pages/index_page.dart';
import 'package:oktoast/oktoast.dart';

void main() => runApp(MyApp());

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
          home: IndexPage(),
        ),
      ),
    );
  }
}