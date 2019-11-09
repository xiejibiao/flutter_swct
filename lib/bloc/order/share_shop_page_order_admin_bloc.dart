import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/order/get_order_page_by_storeId_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/subjects.dart';

class ShareShopPageOrderAdminBloc extends BlocBase {
  int _pageNumber = 0, _pageSize = 10;

  GetOrderPageByStoreIdVo _getOrderPageByStoreIdVo;
  BehaviorSubject<GetOrderPageByStoreIdVo> _getOrderPageByStoreIdVoController = BehaviorSubject<GetOrderPageByStoreIdVo>();
  Sink<GetOrderPageByStoreIdVo> get _getOrderPageByStoreIdVoSink => _getOrderPageByStoreIdVoController.sink;
  Stream<GetOrderPageByStoreIdVo> get getOrderPageByStoreIdVoStream => _getOrderPageByStoreIdVoController.stream;
  bool isEnd = false;

  getOrderPageByShopId(int storeId, BuildContext context) {
    getToken().then((token) {
      _pageNumber = 0;
      var formData = {
        'pageNumber': _pageNumber,
        'pageSize': _pageSize,
        'storeId': storeId
      };
      _postAPI(token, context, formData).then((val) {
        if (val.code == '200') {
          _getOrderPageByStoreIdVo = val;
          _setIsEnd(val.data.totalPage);
          _getOrderPageByStoreIdVoSink.add(_getOrderPageByStoreIdVo);
        }
      });
    });
  }

  loadMoreGetOrderPageByShopId(int storeId, BuildContext context) {
    if (!isEnd) {
      getToken().then((token) {
        _pageNumber++;
        var formData = {
          'pageNumber': _pageNumber,
          'pageSize': _pageSize,
          'storeId': storeId
        };
        _postAPI(token, context, formData).then((val) {
          if (val.code == '200') {
            _getOrderPageByStoreIdVo.data.list.addAll(val.data.list);
            _setIsEnd(val.data.totalPage);
            _getOrderPageByStoreIdVoSink.add(_getOrderPageByStoreIdVo);
          }
        });
      });
    }
  }

  /// 获取订单列表
  Future<GetOrderPageByStoreIdVo> _postAPI(String token, BuildContext context, var formData) {
    return requestPost('getOrderPageByShopId', token: token, context: context, formData: formData).then((val) {
      GetOrderPageByStoreIdVo getOrderPageByStoreIdVo = GetOrderPageByStoreIdVo.fromJson(val);
      if (getOrderPageByStoreIdVo.code != '200') {
        if (getOrderPageByStoreIdVo.code == '206') {
          showToast('此门店不属于此账号');
        } else {
          showToast(getOrderPageByStoreIdVo.message);
        }
      }
      return getOrderPageByStoreIdVo;
    });
  }

  _setIsEnd(int totalPage) {
    if (totalPage == _pageNumber + 1) {
      isEnd = true;
    } else {
      isEnd = false;
    }
  }

  @override
  void dispose() {
    _getOrderPageByStoreIdVoController.close();
  }
}