import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/supplier/supplier_commodity_page_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class SupplierCommodityPageBloc extends BlocBase {

  /// 左侧导航下标
  int _leftIndex = 0;
  BehaviorSubject<int> _leftIndexController = BehaviorSubject<int>();
  Sink<int> get _leftIndexSink => _leftIndexController.sink;
  Stream<int> get leftIndexStream => _leftIndexController.stream;

  /// 左侧导航与商品page
  List<SupplierCommodityPageVoData> _listSupplierCommodityPageVoData;
  BehaviorSubject<List<SupplierCommodityPageVoData>> _listSupplierCommodityPageVoDataController = BehaviorSubject<List<SupplierCommodityPageVoData>>();
  Sink<List<SupplierCommodityPageVoData>> get _listSubplierPageVoSink => _listSupplierCommodityPageVoDataController.sink;
  Stream<List<SupplierCommodityPageVoData>> get listSubplierPageVoStream => _listSupplierCommodityPageVoDataController.stream;

  /// 首次获取左侧导航与商品Page
  getSupplierCommodityPage(int supplierId) {
    var formData = {
      'supplierId': supplierId
    };
    requestPost('getSupplierCommodityPage', formData: formData).then((val) {
      SupplierCommodityPageVo supplierCommodityPageVo = SupplierCommodityPageVo.fromJson(val);
      if (supplierCommodityPageVo.code == '200') {
        _listSupplierCommodityPageVoData = supplierCommodityPageVo.data;
        _listSubplierPageVoSink.add(_listSupplierCommodityPageVoData);
      } else {
        showToast(supplierCommodityPageVo.message);
      }
    });
  }

  /// 加载更多供应商商品列表
  loadMoreSupplierCommodityPage() {
    if ((_listSupplierCommodityPageVoData[_leftIndex].lgmnPage.pageNumber + 1) < _listSupplierCommodityPageVoData[_leftIndex].lgmnPage.totalPage) {
      int categoryId = _listSupplierCommodityPageVoData[_leftIndex].id;
      int pageNumber = _listSupplierCommodityPageVoData[_leftIndex].lgmnPage.pageNumber + 1;
      var formData = {
        'categoryId': categoryId,
        'pageNumber': pageNumber,
        'pageSize': 10
      }; 
      requestPost('loadMoreSupplierCommodityPage', formData: formData).then((val) {
        if (val['code'] == '200') {
          SupplierCommodityInfoVoLgmnPage supplierCommodityInfoVoLgmnPage = SupplierCommodityInfoVoLgmnPage.fromJson(val['data']);
          _listSupplierCommodityPageVoData.forEach((item) {
          if (item.id == categoryId) {
            List<SupplierCommodityInfoVo> _tempList = item.lgmnPage.list;
            item.lgmnPage = supplierCommodityInfoVoLgmnPage;
            item.lgmnPage.list.insertAll(0, _tempList);
            _listSubplierPageVoSink.add(_listSupplierCommodityPageVoData);
          }
        });
        } else {
          showToast(val['message']);
        }
      });
    }
  }

  /// 改变左侧导航下标
  changeLeftIndex(int index) {
    this._leftIndex = index;
    _leftIndexSink.add(index);
  }

  @override
  void dispose() {
    _listSupplierCommodityPageVoDataController.close();
    _leftIndexController.close();
  }
}