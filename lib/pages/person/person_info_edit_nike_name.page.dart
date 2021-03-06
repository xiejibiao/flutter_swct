import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';

class PersonInfoEditNikeNamePage extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final bool isInitNikeName;
  PersonInfoEditNikeNamePage(
    this.isInitNikeName
  );
  @override
  Widget build(BuildContext context) {
    final PersonInfoPageBloc _bloc = BlocProvider.of<PersonInfoPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('修改昵称'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _bloc.upDateNikeName(context, _textEditingController.text, isInitNikeName);
            }, 
            child: Text(
              '保存',
              style: TextStyle(
                color: Colors.white
              ),
            )
          )
        ],
      ),
      body: StreamBuilder(
        stream: _bloc.personInfoVoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            PersonInfoVo personInfoVo = sanpshop.data;
            return _bodyCard(context, personInfoVo.data.nikeName, _bloc);
          } else {
            return showLoading();
          }
        },
      )
    );
  }

  // 输入框
  Widget _bodyCard (BuildContext context, String nikeName, PersonInfoPageBloc bloc) {
    _textEditingController.text = nikeName;
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _textEditingController,
        style: TextStyle(
          height: 1.2
        ),
        // initialValue: nikeName,
        autofocus: true,
        maxLength: 6,
        decoration: InputDecoration(
          labelText: '请输入昵称',
          counterText: '',
        ),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          bloc.upDateNikeName(context, value, isInitNikeName);
        },
      ),
    );
  }
}