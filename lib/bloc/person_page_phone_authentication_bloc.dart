import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/home_page_bloc.dart';
import 'package:flutter_swcy/bloc/index_page_bloc.dart';
import 'package:flutter_swcy/bloc/order_page_bloc.dart';
import 'package:flutter_swcy/bloc/person_page_bloc.dart';
import 'package:flutter_swcy/bloc/store_page_bloc.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/pages/index_page.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/person/sms_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class PersonPagePhoneAuthenticationBloc extends BlocBase {
  // 文字提示
  BehaviorSubject<String> _timeStrController = BehaviorSubject<String>();
  Sink<String> get _timeStrSink => _timeStrController.sink;
  Stream<String> get timeStrStream => _timeStrController.stream;

  // 是否倒计时中
  BehaviorSubject<bool> _isCountDownController = BehaviorSubject<bool>();
  Sink<bool> get _isCountDownSink => _isCountDownController.sink;
  Stream<bool> get isCountDownStream => _isCountDownController.stream;


  TimerUtil mCountDownTimerUtil;
  initCountDown() {
    mCountDownTimerUtil = TimerUtil(mInterval: 1000, mTotalTime: 60 * 1000);
    mCountDownTimerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      if (_tick.toInt() == 0) {
        mCountDownTimerUtil.setTotalTime(60 * 1000);
        _timeStrSink.add('获取验证码');
        _isCountDownSink.add(false);
      } else {
        _timeStrSink.add('${_tick.toInt()}秒后重新获取');
      }
    });
  }
  startCountDown(String phone) {
    var phoneRegExp = RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
    if (!phoneRegExp.hasMatch(phone)) {
      showToast('请输入正确的手机账号');
    } else {
      _getSmsCode(phone);
    }
  }

  _getSmsCode(String phone) {
    var formData = {
      'phone': phone
    };
    requestPost('getSmsCode', formData: formData).then((val) {
      SmsVo smsVo = SmsVo.fromJson(val);
      if (smsVo.code == '200') {
        mCountDownTimerUtil.startCountDown();
        _isCountDownSink.add(true);
        showToast('验证码发送成功');
      } else if (smsVo.code == '207') {
        showToast('验证码发送过于频繁，请10分钟后获取');
      } else {
        showToast('验证码发送失败');
      }
    });
  }

  authenticationPhone(String phone, String smsCode, BuildContext context) {
    if (TextUtil.isEmpty(phone)) {
      showToast('请输入正确的手机账号');
      return;
    }
    if (TextUtil.isEmpty(smsCode)) {
      showToast('请填写验证码');
      return;
    }
    var formData = {
      'phone': phone,
      'smsCode': smsCode
    };
    getToken().then((token) {
      requestPost('authenticationPhone', formData: formData, token: token, context: context).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          showToast('认证成功');
          BlocProvider.of<HomePageBloc>(context).isFirst = true;
          BlocProvider.of<StorePageBloc>(context).getLocationIsFirst = true;
          BlocProvider.of<OrderPageBloc>(context).isFirst = true;
          BlocProvider.of<PersonPageBloc>(context).isFirst = true;
          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: IndexPageBloc(), child: IndexPage())), (route) => route == null);
        } else {
          showToast(commenVo.message);
        }
      });
    });
  }
 
  @override
  void dispose() {
    _timeStrController.close();
    _isCountDownController.close();
  }
}