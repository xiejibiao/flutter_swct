import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/supplier/get_supplier_page_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class SupplierPageBloc extends BlocBase {

  List<SupplierPageVo> _listSupplierPageVo;
  BehaviorSubject<List<SupplierPageVo>> _controller = BehaviorSubject<List<SupplierPageVo>>();
  Sink<List<SupplierPageVo>> get _listSubplierPageVoSink => _controller.sink;
  Stream<List<SupplierPageVo>> get listSubplierPageVoStream => _controller.stream;

  getSupplierPage() async {
    await requestPost('getSupplierPage').then((val) {
      GetSupplierPageVo getSupplierPageVo = GetSupplierPageVo.fromJson(val);
      if (getSupplierPageVo.code == '200') {
        _listSupplierPageVo = getSupplierPageVo.data;
        _listSubplierPageVoSink.add(_listSupplierPageVo);
      } else {
        showToast(getSupplierPageVo.message);
      }
    });
  }

  loadMoreSupplierPage(int industryId, int pageNumber) {
    var formData = {
      'industryId': industryId,
      'pageNumber': (pageNumber + 1),
      'pageSize': 10
    };
    requestPost('loadMoreSupplierPage', formData: formData).then((val) {
      InfoVoLgmnPage infoVoLgmnPage = InfoVoLgmnPage.fromJson(val['data']);
      _listSupplierPageVo.forEach((item) {
        if (item.id == industryId) {
          List<SupplierInfoVo> _tempList = item.infoVoLgmnPage.list;
          item.infoVoLgmnPage = infoVoLgmnPage;
          item.infoVoLgmnPage.list.insertAll(0, _tempList);
          _listSubplierPageVoSink.add(_listSupplierPageVo);
        }
      });
    });
  }


  @override
  void dispose() {
    _controller.close();
  }
}