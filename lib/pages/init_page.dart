import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/bloc/person_page_phone_authentication_bloc.dart';
import 'package:flutter_swcy/bloc/shop_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    PersonPagePhoneAuthenticationBloc pagePhoneAuthenticationBloc = BlocProvider.of<PersonPagePhoneAuthenticationBloc>(context);
    BlocProvider.of<PersonInfoPageBloc>(context).getPersonInfo(context, pagePhoneAuthenticationBloc);
    BlocProvider.of<ShopPageBloc>(context).getAndSaveStoreIndustryList();
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      appBar: AppBar(
        title: Text('三维创业'),
      ),
      body: Center(
        child: showLoading(),
      ),
    );
  }
}