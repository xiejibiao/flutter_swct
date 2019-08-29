import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_receiving_address_bloc.dart';
import 'package:flutter_swcy/pages/person/person_info_receiving_address_text_form_field_column.dart';
import 'package:flutter_swcy/vo/person/receiving_address_vo.dart';

class PersonInfoReceivingAddress extends StatefulWidget {
  final ReceivingAddress receivingAddress;
  PersonInfoReceivingAddress(this.receivingAddress);
  _PersonInfoReceivingAddressState createState() => _PersonInfoReceivingAddressState();
}

class _PersonInfoReceivingAddressState extends State<PersonInfoReceivingAddress> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final PersonInfoReceivingAddressBloc _bloc = BlocProvider.of<PersonInfoReceivingAddressBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('添加收货地址'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if (widget.receivingAddress == null) {
                  _bloc.saveReceivingAddress(context: context);
                } else {
                  _bloc.updateReceivingAddress(context: context, id: widget.receivingAddress.id);
                }
              }
            },
            icon: Text('保存'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: PersonInfoReceivingAddressTextFormFieldColumn(_bloc, _controller, widget.receivingAddress),
          ),
        ),
      ),
    );
  }
}