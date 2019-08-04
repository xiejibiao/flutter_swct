import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';

class PersonInfoAuthenticationPageNot extends StatefulWidget {
  _PersonInfoAuthenticationPageNotState createState() => _PersonInfoAuthenticationPageNotState();
}

class _PersonInfoAuthenticationPageNotState extends State<PersonInfoAuthenticationPageNot> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final PersonInfoPageBloc _bloc = BlocProvider.of<PersonInfoPageBloc>(context);
    return _authenticationForm(_bloc);
  }

  // 未认证
  Form _authenticationForm (PersonInfoPageBloc bloc) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            _buildNameTextFormField(bloc),
            _buildIdNoFormField(bloc),
            SizedBox(height: ScreenUtil().setHeight(20)),
            _buildSubmitButton(context, bloc, _formKey)
          ],
        ),
      ),
    );
  }

  TextFormField _buildNameTextFormField(PersonInfoPageBloc bloc) {
    return TextFormField(
      maxLength: 4,
      onSaved: (value) {
        bloc.setName(value);
      },
      validator: (String value) {
        if (!RegexUtil.isZh(value) || value.length < 2 || value.length > 4) {
          return '姓名错误';
        }
      },
      decoration: InputDecoration(
        prefixIcon: Image.asset('assets/image_icon/icon_name.png', width: 32.0),
        labelText: '姓名',
        counterText: ''
      )
    );
  }

  TextFormField _buildIdNoFormField(PersonInfoPageBloc bloc) {
    return TextFormField(
      maxLength: 18,
      onSaved: (value) {
        bloc.setIdNo(value);
      },
      validator: (String value) {
        if (!RegexUtil.isIDCard18(value)) {
          return '身份证号码错误';
        }
      },
      decoration: InputDecoration(
        prefixIcon: Image.asset('assets/image_icon/icon_id.png', width: 32.0),
        labelText: '身份证号码',
        counterText: ''
      )
    );
  }

  Widget _buildSubmitButton(BuildContext context, PersonInfoPageBloc bloc, GlobalKey<FormState> formKey) {
    return StreamBuilder(
      stream: bloc.authenticationLoadingStream,
      initialData: false,
      builder: (context, sanpshop) {
        return FlatButton(
          splashColor: Colors.white54,
          highlightColor: Colors.blue,
          color: Colors.blue,
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          disabledColor: Colors.blue[300],
          child: !sanpshop.data ? 
                  Text('确认提交', style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(32)))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitHourGlass(
                          color: Colors.white,
                          size: 18.0,
                        ),
                        Text('提交中', style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(32)))
                      ],
                    ),
          onPressed: sanpshop.data ? null : () => bloc.authentication(context, formKey),
        );
      },
    );
  }
}