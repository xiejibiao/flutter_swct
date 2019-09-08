import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';

class PersonInfoEditPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _passwordRegExp = RegExp('^(?![0-9]+\$)(?![a-z]+\$)(?![A-Z]+\$)(?!([^(0-9a-zA-Z)])+\$).{8,32}\$');

  @override
  Widget build(BuildContext context) {
    final PersonInfoPageBloc _bloc = BlocProvider.of<PersonInfoPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('修改密码'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        width: ScreenUtil().setWidth(750),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildPasswordTextFormField(_bloc),
                _buildNewPasswordTextFormField(_bloc),
                _buildConfirmPasswordTextFormField(_bloc),
                SizedBox(height: ScreenUtil().setHeight(20)),
                submitButton(context, _bloc)
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildPasswordTextFormField(PersonInfoPageBloc bloc) {
    return TextFormField(
      autovalidate: false,
      onSaved: (value) {
        bloc.setPassword(value);
      },
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Image.asset('assets/image_icon/icon_primary_password.png', width: ScreenUtil().setWidth(64)),
        labelText: '当前密码',
        counterText: ''
      ),
      maxLength: 32,
      validator: (String value) {
        if (!_passwordRegExp.hasMatch(value)) {
          return '密码长度或格式错误';
        } else {
          return '';
        }
      },
    );
  }

  TextFormField _buildNewPasswordTextFormField(PersonInfoPageBloc bloc) {
    return TextFormField(
      autovalidate: false,
      onSaved: (value) {
        bloc.setNewPassword(value);
      },
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Image.asset('assets/image_icon/icon_new_password.png', width: ScreenUtil().setWidth(64)),
        labelText: '新密码',
        counterText: ''
      ),
      maxLength: 32,
      validator: (String value) {
        if (!_passwordRegExp.hasMatch(value)) {
          return '密码长度或格式错误';
        } else {
          return bloc.setNewPassword(value);
        }
      },
    );
  }

  Widget _buildConfirmPasswordTextFormField(PersonInfoPageBloc bloc) {
    return StreamBuilder(
      stream: bloc.newPasswordStream,
      builder: (context, sanpshop) {
        return TextFormField(
          autovalidate: false,
          onSaved: (value) {
            bloc.setConfirmNewPassword(value);
          },
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Image.asset('assets/image_icon/icon_new_password.png', width: ScreenUtil().setWidth(64)),
            labelText: '确认密码',
            counterText: ''
          ),
          maxLength: 32,
          validator: (String value) {
            if (value != sanpshop.data) {
              return '两次密码不相同';
            } else {
              return '';
            }
          },
        );
      },
    );
  }

  Widget submitButton (BuildContext context, PersonInfoPageBloc bloc) {
    return Container(
      width: ScreenUtil().setWidth(730),
      child: FlatButton(
        splashColor: Colors.white54,
        highlightColor: Colors.blue,
        color: Colors.blue,
        padding: EdgeInsets.only(
          top: 10.0, 
          bottom: 10.0
        ),
        child: Text(
          '确认提交',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(32)
          ),
        ),
        onPressed: () {
          bloc.submitUpDatePassword(_formKey, context);
        },
      ),
    );
  }
}