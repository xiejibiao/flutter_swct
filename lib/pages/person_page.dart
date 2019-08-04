import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/person/person_page_hand.dart';
import 'package:flutter_swcy/pages/person/person_page_item_buttom.dart';
import 'package:flutter_swcy/pages/swiper_page.dart';
import 'package:flutter_swcy/vo/person/person_vo.dart';

class PersonPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final PersonPageBloc _bloc = BlocProvider.of<PersonPageBloc>(context);
    _bloc.getPersonAndAdList(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
      ),
      body: StreamBuilder(
        stream: _bloc.homeVoStream,
        builder: (context, blocSanpshop) {
          if (blocSanpshop.hasData) {
            PersonVo personVo = blocSanpshop.data;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  PersonPageHand(personVo),
                  SwiperPage(personVo.data.homeAdVo),
                  PersonPageItemButtom()
                ],
              ),
            );
          } else {
            return showLoading();
          }
        },
      ),
    );
  }
}