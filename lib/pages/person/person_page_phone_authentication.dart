import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/person_page_phone_authentication_bloc.dart';

class PersonPagePhoneAuthentication extends StatefulWidget {
  final PersonPagePhoneAuthenticationBloc bloc;
  PersonPagePhoneAuthentication(
    this.bloc
  );
  _PersonPagePhoneAuthenticationState createState() => _PersonPagePhoneAuthenticationState();
}

class _PersonPagePhoneAuthenticationState extends State<PersonPagePhoneAuthentication> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    widget.bloc.initCountDown();
    return Scaffold(
      appBar: AppBar(
        title: Text('手机号认证'),
        actions: <Widget>[
          IconButton(
            icon: Text('完成'),
            onPressed: () {
              widget.bloc.authenticationPhone(_phoneController.text, _smsCodeController.text, context);
            },
          )
        ],
      ),
      body: Container(
        width: ScreenUtil().setWidth(750),
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '手机号'
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _smsCodeController,
                    decoration: InputDecoration(
                      labelText: '验证码',
                      counterText: ''
                    ),
                    maxLength: 6,
                  ),
                ),
                StreamBuilder(
                  initialData: false,
                  stream: widget.bloc.isCountDownStream,
                  builder: (context, sanpshop) {
                    return InkWell(
                      onTap: sanpshop.data ? null : 
                      () {
                        widget.bloc.startCountDown(_phoneController.text);
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(230),
                        height: ScreenUtil().setHeight(75),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sanpshop.data ? Colors.grey : Colors.blue,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: StreamBuilder(
                          initialData: '获取验证码',
                          stream: widget.bloc.timeStrStream,
                          builder: (context, sanpshop) {
                            return Text(
                              '${sanpshop.data}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(28)
                              )
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}