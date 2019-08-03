import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/person/person_info_page_hean.dart';
import 'package:flutter_swcy/pages/person/person_info_page_item.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';

class PersonInfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final PersonInfoPageBloc _bloc = BlocProvider.of<PersonInfoPageBloc>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: _bloc.personInfoVoStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            PersonInfoVo personInfoVo = sanpshop.data;
            return CustomScrollView(
              slivers: <Widget>[
                PersonInfoPageHead(personInfoVo),
                SliverToBoxAdapter(
                  child: PersonInfoPageItem(personInfoVo),
                )
              ],
            );
          }
        },
      ),
    );
  }
}