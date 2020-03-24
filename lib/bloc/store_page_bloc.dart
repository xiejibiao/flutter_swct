import 'package:amap_base/amap_base.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/shop/news_get_page_store_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class StorePageBloc extends BlocBase {

  bool getLocationIsFirst = true;
  // 定位
  BehaviorSubject<Location> _locationController = BehaviorSubject<Location>();
  Sink<Location> get _locationSink => _locationController.sink;
  Stream<Location> get locationStream => _locationController.stream;

  /// 第一次请求
  BehaviorSubject<NewsGetPageStoreVo> _newsGetPageStoreVoController = BehaviorSubject<NewsGetPageStoreVo>();
  Sink<NewsGetPageStoreVo> get _newsGetPageStoreVoSink => _newsGetPageStoreVoController.sink;
  Stream<NewsGetPageStoreVo> get newsGetPageStoreVoStream => _newsGetPageStoreVoController.stream;
  
  // 初始化定位
  final _amapLocation = AMapLocation();
  initAMapLocation() {
    _amapLocation.init();
  }

  //  获取定位
  getLocation() async {
    if (getLocationIsFirst) {
      final options = LocationClientOptions(
                      isOnceLocation: true,
                      locatingWithReGeocode: true
                    );
      if (await Permissions().requestPermission()) {
        var location = _amapLocation.getLocation(options);
        location.then((val) {
          getLocationIsFirst = false;
          _locationSink.add(val);
          _newsGetPageStore(val.latitude.toString(), val.longitude.toString());
        });
      } else {
        showToast('权限不足');
      }
    }
  }


  _newsGetPageStore(String lat, String lng) {
    var formData = {
      'lat': lat,
      'lng': lng,
    };
    requestPost('newsGetPageStore', formData: formData).then((val) {
      NewsGetPageStoreVo newsGetPageStoreVo = NewsGetPageStoreVo.fromJson(val);
      _newsGetPageStoreVoSink.add(newsGetPageStoreVo);
    });
  }
  
  Future loadMoreStore(int industryId, String lat, String lng, int pageNumber, int pageSize) {
    var formData = {
      'industryId': [industryId],
      'lat': lat,
      'lng': lng,
      'pageNumber': pageNumber,
      'pageSize': pageSize
    };
    return requestPost('getPageStore', formData: formData);
  }

  @override
  void dispose() {
    _locationController.close();
    _newsGetPageStoreVoController.close();
  }
}