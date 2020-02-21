import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';

class PersonInfoEditMailboxPage extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final PersonInfoPageBloc _bloc = BlocProvider.of<PersonInfoPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('修改邮箱'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _bloc.upDateMailbox(context, _textEditingController.text);
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
            return _bodyCard(context, personInfoVo.data.email, _bloc);
          } else {
            return showLoading();
          }
        },
      )
    );
  }

  // 输入框
  Widget _bodyCard (BuildContext context, String email, PersonInfoPageBloc bloc) {
    _textEditingController.text = email;
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _textEditingController,
        style: TextStyle(
          height: 1.2
        ),
        // initialValue: email,
        autofocus: true,
        maxLength: 20,
        decoration: InputDecoration(
          labelText: '请输入邮箱',
          counterText: '',
        ),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          bloc.upDateMailbox(context, value);
        },
      ),
    );
  }
}