import 'package:flutter/widgets.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';
import 'package:rxdart/rxdart.dart';

class ShareShopPageBloc extends BlocBase {
  int _pageNumber = 0, _pageSize = 10;

  // 我的共享店
  MyStorePageVo _myStorePageVo;
  BehaviorSubject<MyStorePageVo> _myStorePageVoController = BehaviorSubject<MyStorePageVo>();
  Sink<MyStorePageVo> get _myStorePageVoSink => _myStorePageVoController.sink;
  Stream<MyStorePageVo> get myStorePageVoStream => _myStorePageVoController.stream;

  bool isEnd = false;

  getMyStorePage(BuildContext context) async {
    await getToken().then((token) async {
      print(token);
      _pageNumber = 0;
      var formData = {
        'pageNumber': _pageNumber,
        'pageSize': _pageSize
      };
      await requestPost('getMyStorePage', formData: formData, context: context, token: token).then((val) {
        MyStorePageVo temp = MyStorePageVo.fromJson(val);
        _myStorePageVo = temp;
        setIsEnd(temp.data.totalPage);
        _myStorePageVoSink.add(_myStorePageVo);
      });
    });
  }
  getMyStorePageLoadMore(BuildContext context) async {
    if (!isEnd) {
      await getToken().then((token) async {
        _pageNumber++;
        var formData = {
          'pageNumber': _pageNumber,
          'pageSize': _pageSize
        };
        await requestPost('getMyStorePage', formData: formData, context: context, token: token).then((val) {
          MyStorePageVo temp = MyStorePageVo.fromJson(val);
          _myStorePageVo.data.list.addAll(temp.data.list);
          setIsEnd(temp.data.totalPage);
          _myStorePageVoSink.add(_myStorePageVo);
        });
      });
    }
  }

  setIsEnd(int totalPage) {
    if (totalPage == _pageNumber + 1) {
      isEnd = true;
    } else {
      isEnd = false;
    }
  }

  @override
  void dispose() {
    _myStorePageVoController.close();
  }
}