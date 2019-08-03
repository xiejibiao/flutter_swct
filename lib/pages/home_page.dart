import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/home_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomePageBloc>(context).getHomePage(context);
    PersonInfoPageBloc pageBloc = BlocProvider.of<PersonInfoPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('三维创业'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            FlatButton(
              child: Text('跳转'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage1()));
              },
            ),
            StreamBuilder(
              stream: pageBloc.personInfoVoStream,
              builder: (context, sanpshot){
                if (sanpshot.hasData) {
                  return Text('${sanpshot.data.data.id}');
                } else {
                  return Text('123');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class HomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomePageBloc bloc = BlocProvider.of<HomePageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('测试'),
      ),
      body: StreamBuilder(
        stream: bloc.homeVoVoStream,
        builder: (context, sanpshot){
          if (sanpshot.hasData) {
            return Text('${sanpshot.data.code}');
          } else {
            return Text('123');
          }
        },
      ),
    );
  }
}