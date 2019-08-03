import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/home/home_vo.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc extends BlocBase {
  HomePageVo homePageVo;

  BehaviorSubject<HomePageVo> _homeVoController = BehaviorSubject<HomePageVo>();
  Sink<HomePageVo> get _homeVoSink => _homeVoController.sink;
  Stream<HomePageVo> get homeVoVoStream => _homeVoController.stream;

  getHomePage(BuildContext context) {
    getToken().then((token) async {
      await requestPost('getHomePage', token: token, context: context).then((val) {
        HomePageVo homePageVo = HomePageVo.fromJson(val);
        _homeVoSink.add(homePageVo);
      });
    });
  }

  @override
  void dispose() {
    _homeVoController.close();
  }
}