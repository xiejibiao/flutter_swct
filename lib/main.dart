import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/home_page_bloc.dart';
import 'package:flutter_swcy/bloc/order_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/bloc/shop_page_bloc.dart';
import 'package:flutter_swcy/pages/init_page.dart';
import 'package:oktoast/oktoast.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

void main() async {
  await fluwx.register(appId:"wx6135b0ad2c35654c");
  runApp(
    BlocProvider(
      bloc: PersonInfoPageBloc(),
      child: BlocProvider(
        bloc: HomePageBloc(),
        child: BlocProvider(
          bloc: OrderPageBloc(),
          child: BlocProvider(
            bloc: PersonPageBloc(),
            child: BlocProvider(
              bloc: ShopPageBloc(),
              child: MyApp(),
            ),
          ),
        ),
      ),
    )
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // saveToken('e6300078-3e02-4064-b84e-86e8fd4d8cbb');
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