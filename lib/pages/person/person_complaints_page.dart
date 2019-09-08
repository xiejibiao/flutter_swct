import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';

class PersonComplaintsPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('意见与投诉'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[
          _complaintsCard(_bloc),
          SizedBox(height: 10),
          _complaintsFlatButton(context, _bloc, _controller, _formKey)
        ],
      ),
    );
  }

  Card _complaintsCard (PersonPageBloc bloc) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            validator: (value) {
              if (value == '') {
                return '请填写反馈信息';
              } else {
                return '';
              }
            },
            onSaved: (value) {
              bloc.setContent(value);
            },
            style: TextStyle(
              height: 1.2
            ),
            maxLines: 10,
            maxLength: 250,
            decoration: InputDecoration(
              hintText: '请填写250个字以内的问题描述，以便我们提供更好的帮助',
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _complaintsFlatButton (BuildContext context, PersonPageBloc bloc, TextEditingController controller, GlobalKey<FormState> formKey) {
    return StreamBuilder(
      stream: bloc.complaintsStream,
      initialData: false,
      builder: (context, snanshop) {
        return FlatButton(
          splashColor: Colors.white54,
          highlightColor: Colors.blue,
          color: Colors.blue,
          padding: EdgeInsets.only(
            top: 10.0, 
            bottom: 10.0
          ),
          child: snanshop.data ? _submitInText() : _submitText(),
          disabledColor: Colors.blue[300],
          onPressed: snanshop.data ? null : () {
            bloc.complaints(context, controller, formKey);
          },
        );
      },
    );
  }

  Text _submitText () {
    return Text(
      '提交',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0
      ),
    );
  }

  // 提交中
  Row _submitInText () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitHourGlass(
          color: Colors.white,
          size: 18.0,
        ),
        Text(
          '提交中...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0
          ),
        )
      ],
    );
  }
}