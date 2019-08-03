import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/home_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/pages/home/home_head_top.dart';
import 'package:flutter_swcy/pages/swiper_page.dart';
import 'package:flutter_swcy/vo/home/home_vo.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final HomePageBloc bloc = BlocProvider.of<HomePageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('三维创业'),
      ),
      body: FutureBuilder(
        future: bloc.getHomePage(context),
        builder: (context, sanpshop) {
          return StreamBuilder(
            stream: bloc.homeVoStream,
            builder: (context, blocSanpshop) {
              if (blocSanpshop.hasData) {
                HomePageVo homePageVo = blocSanpshop.data;
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      HomeHeadTop(homePageVo),
                      SwiperPage(homePageVo.data.homeAdType0Vos),
                      SwiperPage(homePageVo.data.homeAdType1Vos)
                    ],
                  ),
                );
              } else {
                return showLoading();
              }
            },
          );
        },
      ),
    );
  }
}