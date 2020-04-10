import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/message_dialog.dart';
import 'package:flutter_swcy/common/preference_utils.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/home/home_vo.dart';
import 'package:flutter_swcy/vo/home/swcy_version_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc extends BlocBase {
  bool isFirst = true;
  String _versionKEY = 'VERSION_KEY';

  BehaviorSubject<HomePageVo> _homeVoController = BehaviorSubject<HomePageVo>();
  Sink<HomePageVo> get _homeVoSink => _homeVoController.sink;
  Stream<HomePageVo> get homeVoStream => _homeVoController.stream;

  getHomePage(BuildContext context) {
    if (isFirst) {
      return getToken().then((token) async {
        return await requestPost('getHomePage', token: token, context: context).then((val) {
          this.isFirst = false;
          HomePageVo homePageVo = HomePageVo.fromJson(val);
          _homeVoSink.add(homePageVo);
          return homePageVo;
        });
      });
    }
  }

  String appVersion = '2.4.10';
  getSwcyVersion(BuildContext context) {
    PreferenceUtils.instance.saveString(key: _versionKEY, value: appVersion);
    requestPost('getSwcyVersion').then((val) {
      SwcyVersionVo swcyVersionVo = SwcyVersionVo.fromJson(val);
      if (swcyVersionVo.code == '200') {
        if (appVersion != swcyVersionVo.data.version) {
          if (swcyVersionVo.data.isMandatoryUpdate == "true") {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return MessageDialog(
                  widget: Text(swcyVersionVo.data.updateMsg, style: TextStyle(fontSize: ScreenUtil().setSp(32))),
                  onCloseEvent: () async {
                    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  onPositivePressEvent: () async {
                    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  negativeText: '取消',
                  positiveText: '确认',
                );
              }
            );
          } else {
            showToast(swcyVersionVo.data.updateMsg);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _homeVoController.close();
  }
}