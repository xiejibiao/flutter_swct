import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/home_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/pages/init_page.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  runApp(
    BlocProvider(
      bloc: PersonInfoPageBloc(),
      child: BlocProvider(
        bloc: HomePageBloc(),
        child: MyApp(),
      ),
    )
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    saveToken('98fc13f7-6f17-4f30-aa38-e4855772789c');
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
          home: InitPage(),
        ),
      ),
    );
  }
}