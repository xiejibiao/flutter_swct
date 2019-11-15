import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/supplier/supplier_order_page_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class SupplierPageOrderBloc extends BlocBase {

  int _pageNumber = 0;

  SupplierOrderPageVo _supplierOrderPageVo;
  BehaviorSubject<SupplierOrderPageVo> _supplierOrderPageVoController = BehaviorSubject<SupplierOrderPageVo>();
  Sink<SupplierOrderPageVo> get _supplierOrderPageVoSink => _supplierOrderPageVoController.sink;
  Stream<SupplierOrderPageVo> get supplierOrderPageVoStream => _supplierOrderPageVoController.stream;


  /// 获取订单
  getSupplierOrderPage(BuildContext context) {
    getToken().then((token) {
      var formData = {
        'pageNumber': _pageNumber,
        'pageSize': 10
      };
      requestPost('getSupplierOrderPage', formData: formData, context: context, token: token).then((val) {
        _supplierOrderPageVo = null;
        _supplierOrderPageVo = SupplierOrderPageVo.fromJson(val);
        if (_supplierOrderPageVo.code == '200') {
          _supplierOrderPageVoSink.add(_supplierOrderPageVo);
        } else {
          showToast(_supplierOrderPageVo.message);
        }
      });
    });
  }

  /// 获取订单
  loadMoreSupplierOrderPage(BuildContext context) {
    if ((_supplierOrderPageVo.data.pageNumber + 1) < _supplierOrderPageVo.data.totalPage) {
      getToken().then((token) {
        var formData = {
          'pageNumber': _supplierOrderPageVo.data.pageNumber + 1,
          'pageSize': 10
        };
        requestPost('getSupplierOrderPage', formData: formData, context: context, token: token).then((val) {
          SupplierOrderPageVo temp = SupplierOrderPageVo.fromJson(val);
          if (temp.code == '200') {
            List<SupplierOrderPageVoList> list = _supplierOrderPageVo.data.list;
            _supplierOrderPageVo = temp;
            _supplierOrderPageVo.data.list.insertAll(0, list);
            _supplierOrderPageVoSink.add(_supplierOrderPageVo);
          } else {
            showToast(_supplierOrderPageVo.message);
          }
        });
      });
    }
  }

  /// 确认收货
  supplierOrderConfirmReceipt(String id, BuildContext context) {
    getToken().then((token) {
      var formData = {
        'id': id
      };
      requestPost('supplierOrderConfirmReceipt', formData: formData, token: token, context: context).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          showToast('确认收货成功');
          _supplierOrderPageVo.data.list.forEach((item) {
            if (item.id == id) {
              item.status = 4;
            }
          });
          _supplierOrderPageVoSink.add(_supplierOrderPageVo);
        } else { 
          showToast('确认收货异常');
        }
      });
    });
  }

  /// 申请退货
  applyForReturn(String id, BuildContext context, String refundsReason) {
    if (refundsReason == '') {
      showToast('请填写退货原因');
      return;
    }
    getToken().then((token) {
      var formData = {
        'id': id,
        'refundsReason': refundsReason
      };
      requestPost('applyForReturn', formData: formData, token: token, context: context).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          showToast('申请退货成功');
          _supplierOrderPageVo.data.list.forEach((item) {
            if (item.id == id) {
              item.status = 5;
            }
          });
          _supplierOrderPageVoSink.add(_supplierOrderPageVo);
          Navigator.pop(context);
        } else { 
          showToast('申请退货异常');
        }
      });
    });
  }

  @override
  void dispose() {
    _supplierOrderPageVoController.close();
  }
}