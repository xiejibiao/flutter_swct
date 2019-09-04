import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';

class PersonAboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _abotListTile(context),
                SizedBox(height: 50.0),
                _logoutButton(context, _bloc)
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Copyright',
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                    Image.asset(
                      'assets/image_icon/icon_copyright.png',
                      width: 15,
                      color: Colors.grey
                    ),
                    Text(
                      '2019',
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    )
                  ],
                ),
                Text(
                  '两个码农 版权所有',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column _abotListTile (BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
            title: Text('当前版本'),
            trailing: Text('V_0.0.1'),
          ),
          decoration: BoxDecoration (
            border: Border(
              bottom: Divider.createBorderSide(context, color: Colors.blue[100], width: 5.0)
            )
          ),
        ),
        Container(
          child: ListTile(
            title: Text('关于我们'),
            trailing: Icon(Icons.keyboard_arrow_right)
          ),
          decoration: BoxDecoration (
            border: Border(
              bottom: Divider.createBorderSide(context, color: Colors.black26, width: 1.5)
            )
          ),
        ),
        Container(
          child: ListTile(
            title: Text('联系客服')
          ),
          decoration: BoxDecoration (
            border: Border(
              bottom: Divider.createBorderSide(context, color: Colors.black26, width: 1.5)
            )
          ),
        ),
      ],
    );
  }

  Widget _logoutButton (BuildContext context, PersonPageBloc bloc) {
    return StreamBuilder(
      initialData: false,
      stream: bloc.isLogoutLoadingStream,
      builder: (context, sanpshop) {
        return Container(
          width: ScreenUtil().setWidth(740),
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: FlatButton(
            splashColor: Colors.white54,
            highlightColor: Colors.blue,
            color: Colors.blue,
            padding: EdgeInsets.only(
              top: 10.0, 
              bottom: 10.0
            ),
            child: sanpshop.data ? _logoutInText() : _logoutText(),
            onPressed: sanpshop.data ? null : () {
              bloc.exitLogin(context);
            },
            disabledColor: Colors.blue[300],
          ),
        );
      },
    );
  }

  Text _logoutText () {
    return Text(
      '退出登录',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0
      ),
    );
  }

  Row _logoutInText () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitHourGlass(
          color: Colors.white,
          size: 18.0,
        ),
        Text(
          '退出中...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0
          ),
        )
      ],
    );
  }
}