import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/login_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/common/preference_utils.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/pages/login/login_page.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/person/assets_vo.dart';
import 'package:flutter_swcy/vo/person/person_team_achievement_vo.dart';
import 'package:flutter_swcy/vo/person/person_team_list_vo.dart';
import 'package:flutter_swcy/vo/person/person_vo.dart';
import 'package:flutter_swcy/vo/person/sms_vo.dart';
import 'package:flutter_swcy/vo/person/store_flowing_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class PersonPageBloc extends BlocBase {

  bool isFirst = true;
  final String _versionKEY = 'VERSION_KEY';

  /// 版本
  BehaviorSubject<String> _versionController = BehaviorSubject<String>();
  Sink<String> get _versionSink => _versionController.sink;
  Stream<String> get versionStream => _versionController.stream;

  // 我的
  BehaviorSubject<PersonVo> _personVoController = BehaviorSubject<PersonVo>();
  Sink<PersonVo> get _personVoSink => _personVoController.sink;
  Stream<PersonVo> get personVoStream => _personVoController.stream;

  // 资产
  BehaviorSubject<AssetsVo> _assetsVoController = BehaviorSubject<AssetsVo>();
  Sink<AssetsVo> get _assetsVoSink => _assetsVoController.sink;
  Stream<AssetsVo> get assetsVoStream => _assetsVoController.stream;

  // 团队业绩
  BehaviorSubject<PersonTeamAchievementVo> _personTeamAchievementVoController = BehaviorSubject<PersonTeamAchievementVo>();
  Sink<PersonTeamAchievementVo> get _personTeamAchievementVoSink => _personTeamAchievementVoController.sink;
  Stream<PersonTeamAchievementVo> get personTeamAchievementVoStream => _personTeamAchievementVoController.stream;

  // 团队列表
  int myTeamPageNumber = 0;
  int myTeamPageSize = 10;
  bool myTeamIsEnd = false;
  PersonTeamListVo personTeamListVo;
  BehaviorSubject<PersonTeamListVo> _personTeamListVoController = BehaviorSubject<PersonTeamListVo>();
  Sink<PersonTeamListVo> get _personTeamListVoSink => _personTeamListVoController.sink;
  Stream<PersonTeamListVo> get personTeamListVoStream => _personTeamListVoController.stream;

  // 消息
  SmsVo mySmsVo;
  int mySmsPageNumber = 0;
  int mySmsPageSize = 10;
  bool mySmsIsEnd = false;
  BehaviorSubject<SmsVo> _mySmsVoController = BehaviorSubject<SmsVo>();
  Sink<SmsVo> get _mySmsVoSink => _mySmsVoController.sink;
  Stream<SmsVo> get mySmsVoStream => _mySmsVoController.stream;

  SmsVo noticeSmsVo;
  int noticeSmsPageNumber = 0;
  int noticeSmsPageSize = 10;
  bool noticeSmsIsEnd = false;
  BehaviorSubject<SmsVo> _noticeSmsVoController = BehaviorSubject<SmsVo>();
  Sink<SmsVo> get _noticeSmsVoSink => _noticeSmsVoController.sink;
  Stream<SmsVo> get noticeSmsVoStream => _noticeSmsVoController.stream;

  // 意见与投诉
  bool complaintsIsSubmit = false;
  String content;
  BehaviorSubject<bool> _complaintsController = BehaviorSubject<bool>();
  Sink<bool> get _complaintsSink => _complaintsController.sink;
  Stream<bool> get complaintsStream => _complaintsController.stream;

  // 退出登录
  bool isLogoutLoading = false;
  BehaviorSubject<bool> _isLogoutLoadingController = BehaviorSubject<bool>();
  Sink<bool> get _isLogoutLoadingSink => _isLogoutLoadingController.sink;
  Stream<bool> get isLogoutLoadingStream => _isLogoutLoadingController.stream;

  // 获取我的
  getPersonAndAdList(BuildContext context) {
    if (isFirst) {
      return getToken().then((token) async {
        BlocProvider.of<PersonInfoPageBloc>(context).getPerson(context, token);
        return await requestPost('getPersonAndAdList', token: token, context: context).then((val) {
          PersonVo personVo = PersonVo.fromJson(val);
          _personVoSink.add(personVo);
          this.isFirst = false;
          return personVo;
        });
      });
    }
  }

  // 获取资产
  getMyAssets(BuildContext context) {
    getToken().then((token) async {
      await requestPost('getMyAssets', token: token, context: context).then((val) {
        AssetsVo assetsVo = AssetsVo.fromJson(val);
        _assetsVoSink.add(assetsVo);
      });
    });
  }

  // 获取团队总业绩
  getMyTeamAchievement(BuildContext context) {
    getToken().then((token) async {
      await requestPost('getMyTeamAchievement', token: token, context: context).then((val) {
        PersonTeamAchievementVo personTeamAchievementVo = PersonTeamAchievementVo.fromJson(val);
        _personTeamAchievementVoSink.add(personTeamAchievementVo);
      });
    });
  }

  // 获取团队列表
  getMyTeam(BuildContext context) {
    this.myTeamIsEnd = false;
    getToken().then((token) async {
      myTeamPageNumber = 0;
      var formData = {
        'pageNumber': myTeamPageNumber,
        'pageSize': myTeamPageSize
      };
      await requestPost('getMyTeam', token: token, formData: formData, context: context).then((val) {
        this.personTeamListVo = PersonTeamListVo.fromJson(val);
        if ((myTeamPageNumber + 1) == personTeamListVo.data.totalPage) {
          this.myTeamIsEnd = true;
        }
        _personTeamListVoSink.add(personTeamListVo);
      });
    });
  }

  getMyTeamLoadMore(BuildContext context) {
    if (!myTeamIsEnd) {
      myTeamPageNumber++;
      getToken().then((token) async {
        var formData = {
          'pageNumber': myTeamPageNumber,
          'pageSize': myTeamPageSize
        };
        await requestPost('getMyTeam', token: token, formData: formData, context: context).then((val) {
          PersonTeamListVo personTeamListVo = PersonTeamListVo.fromJson(val);
          this.personTeamListVo.data.list.addAll(personTeamListVo.data.list);
          _personTeamListVoSink.add(personTeamListVo);
          if ((myTeamPageNumber + 1) == personTeamListVo.data.totalPage) {
            this.myTeamIsEnd = true;
          }
        });
      });
    }
  }

  // 获取我的信息列表
  getMyMessage(BuildContext context) {
    getToken().then((token) async {
      this.mySmsIsEnd = false;
      this.mySmsPageNumber = 0;
      var formData = {
        'pageNumber': mySmsPageNumber,
        'pageSize': mySmsPageSize,
        'type': 0
      };
      await requestPost('getMessage', token: token, formData: formData, context: context).then((val) {
        this.mySmsVo = SmsVo.fromJson(val);
        _mySmsVoSink.add(mySmsVo);
        if ((mySmsPageNumber + 1) == mySmsVo.data.totalPage) {
          this.mySmsIsEnd = true;
        }
      });
    });
  }

  getMyMessageLoadMore(BuildContext context) {
    if (!mySmsIsEnd) {
      mySmsPageNumber++;
      getToken().then((token) async {
        var formData = {
          'pageNumber': mySmsPageNumber,
          'pageSize': mySmsPageSize,
          'type': 0
        };
        await requestPost('getMessage', token: token, formData: formData, context: context).then((val) {
           SmsVo smsVo = SmsVo.fromJson(val);
           this.mySmsVo.data.list.addAll(smsVo.data.list);
          _mySmsVoSink.add(mySmsVo);
          if ((mySmsPageNumber + 1) == mySmsVo.data.totalPage) {
            this.mySmsIsEnd = true;
          }
        });
      });
    }
  }

  // 获取系统信息列表
  getnoticeMessage(BuildContext context) {
    getToken().then((token) async {
      this.noticeSmsIsEnd = false;
      this.noticeSmsPageNumber = 0;
      var formData = {
        'pageNumber': noticeSmsPageNumber,
        'pageSize': noticeSmsPageSize,
        'type': 1
      };
      await requestPost('getMessage', token: token, formData: formData, context: context).then((val) {
        this.noticeSmsVo = SmsVo.fromJson(val);
        _noticeSmsVoSink.add(noticeSmsVo);
        if ((noticeSmsPageNumber + 1) == noticeSmsVo.data.totalPage) {
          this.noticeSmsIsEnd = true;
        }
      });
    });
  }

  getnoticeMessageLoadMore(BuildContext context) {
    if (!noticeSmsIsEnd) {
      noticeSmsPageNumber++;
      getToken().then((token) async {
        var formData = {
          'pageNumber': noticeSmsPageNumber,
          'pageSize': noticeSmsPageSize,
          'type': 1
        };
        await requestPost('getMessage', token: token, formData: formData, context: context).then((val) {
           SmsVo smsVo = SmsVo.fromJson(val);
           this.noticeSmsVo.data.list.addAll(smsVo.data.list);
          _noticeSmsVoSink.add(noticeSmsVo);
          if ((noticeSmsPageNumber + 1) == noticeSmsVo.data.totalPage) {
            this.noticeSmsIsEnd = true;
          }
        });
      });
    }
  }

  // 意见与投诉
  setContent(String content) {
    this.content = content;
  }

  complaints(BuildContext context, TextEditingController controller, GlobalKey<FormState> formKey) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (!complaintsIsSubmit) {
        complaintsIsSubmit = true;
        _complaintsSink.add(true);
        getToken().then((token) {
          var formData = {
            'context': content
          };
          requestPost('complaints', context: context, token: token, formData: formData).then((val) {
            complaintsIsSubmit = false;
            _complaintsSink.add(false);
            CommenVo commenVo = CommenVo.fromJson(val);
            if (commenVo.code == '200') {
              showToast('提交成功');
              controller.text = '';
            } else {
              showToast('提交失败：${commenVo.message}');
            }
          });
        });
      }
    }
  }

  // 退出登录
  exitLogin(BuildContext context) {
    if (!isLogoutLoading) {
      isLogoutLoading = true;
      _isLogoutLoadingSink.add(true);
      showToast('退出成功');
      cleanToken();
      isLogoutLoading = false;
      _isLogoutLoadingSink.add(false);
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: PersonInfoPageBloc(), child: BlocProvider(bloc: LoginPageBloc(), child: LoginPage()))), (route) => route == null);
      // getToken().then((token) {
      //   var formData = {
      //     'accessToken': token
      //   };
      //   requestPost('exitLogin', formData: formData).then((val) {
      //     isLogoutLoading = false;
      //     _isLogoutLoadingSink.add(false);
      //     CommenVo commenVo = CommenVo.fromJson(val);
      //     if (commenVo.code == '200') {
      //       showToast(commenVo.message);
      //       cleanToken();
      //       Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginPage()), (route) => route == null);
      //     } else {
      //       showToast(commenVo.message);
      //     }
      //   });
      // });
    }
  }

  /// 获取共享店收益流水
  // getStoreFlowing() {
  //   getToken().then((token) {
  //     var formData = {
  //       'pageNumber': 0,
  //       'pageSize': 10
  //     };
  //     requestPost('getStoreFlowing', formData: )
  //   });
  // }

  StoreFlowingVo storeFlowingVo;
  BehaviorSubject<StoreFlowingVo> _storeFlowingVoController = BehaviorSubject<StoreFlowingVo>();
  Sink<StoreFlowingVo> get _storeFlowingVoSink => _storeFlowingVoController.sink;
  Stream<StoreFlowingVo> get storeFlowingVoStream => _storeFlowingVoController.stream;
  BehaviorSubject<bool> _isEndController = BehaviorSubject<bool>();
  Sink<bool> get _isEndSink => _isEndController.sink;
  Stream<bool> get isEndStream => _isEndController.stream;
  int pageNumber = 0;
  int pageSize = 10;
  bool isEnd = false;
  getStoreFlowing(BuildContext context) async {
    getToken().then((token) async {
      this.pageNumber = 0;
      var formData = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };
      requestPost('getStoreFlowing', token: token, formData: formData, context: context).then((val) {
        StoreFlowingVo tempVo = StoreFlowingVo.fromJson(val);
        this.storeFlowingVo = tempVo;
        setIsEnd(tempVo.data.totalPage);
        _storeFlowingVoSink.add(storeFlowingVo);
      });
    });
  }

  loadStoreFlowing(BuildContext context) async {
    if (!isEnd) {
      return await getToken().then((token) async {
        this.pageNumber++;
        var formData = {
          'pageNumber': pageNumber,
          'pageSize': pageSize
        };
        await requestPost('getStoreFlowing', token: token, formData: formData, context: context).then((val){
          StoreFlowingVo tempVo = StoreFlowingVo.fromJson(val);
          setIsEnd(tempVo.data.totalPage);
          this.storeFlowingVo.data.list.addAll(tempVo.data.list);
          _storeFlowingVoSink.add(storeFlowingVo);
        });
      });
    }
  }

  setIsEnd(int totalPage) {
    if (totalPage == pageNumber + 1) {
      _isEndSink.add(true);
      isEnd = true;
    } else {
      _isEndSink.add(false);
      isEnd = false;
    }
  }

  getVersion() {
    PreferenceUtils.instance.getString(key: _versionKEY).then((versionVal) {
      _versionSink.add(versionVal);
    });
  }

  @override
  void dispose() {
    _personVoController.close();
    _assetsVoController.close();
    _personTeamListVoController.close();
    _personTeamAchievementVoController.close();
    _mySmsVoController.close();
    _noticeSmsVoController.close();
    _complaintsController.close();
    _isLogoutLoadingController.close();
    _versionController.close();
    _storeFlowingVoController.close();
    _isEndController.close();
  }
}