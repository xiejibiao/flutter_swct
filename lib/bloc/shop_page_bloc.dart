import 'package:amap_base/amap_base.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';
import 'package:flutter_swcy/vo/shop/store_industry_list_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class ShopPageBloc extends BlocBase {
  bool _getLocationIsFirst = true;
  bool _getStoreIndustryListIsFirst = true;
  Map<String, bool> getPageStoreIsFirst = Map<String, bool>();

  // 定位
  Location location;
  BehaviorSubject<Location> _locationController = BehaviorSubject<Location>();
  Sink<Location> get _locationSink => _locationController.sink;
  Stream<Location> get locationStream => _locationController.stream;

  // 商家类型
  StoreIndustryListVo storeIndustryListVo;
  BehaviorSubject<StoreIndustryListVo> _storeIndustryListVoController = BehaviorSubject<StoreIndustryListVo>();
  Sink<StoreIndustryListVo> get _storeIndustryListVoSink => _storeIndustryListVoController.sink;
  Stream<StoreIndustryListVo> get storeIndustryListVoStream => _storeIndustryListVoController.stream;

  // 初始化定位
  final _amapLocation = AMapLocation();
  initAMapLocation() {
    _amapLocation.init();
  }

  //  获取定位
  getLocation() async {
    if (_getLocationIsFirst) {
      final options = LocationClientOptions(
                      isOnceLocation: true,
                      locatingWithReGeocode: true
                    );
      if (await Permissions().requestPermission()) {
        var location = _amapLocation.getLocation(options);
        await getStoreIndustryList();
        location.then((val) {
          _getLocationIsFirst = false;
          this.location = val;
          _locationSink.add(this.location);
        });
      } else {
        showToast('权限不足');
      }
    }
  }

  // 获取商家类型
  getStoreIndustryList() async {
    if (_getStoreIndustryListIsFirst) {
      await requestPost('getStoreIndustryList').then((val) {
        this.storeIndustryListVo = StoreIndustryListVo.fromJson(val);
        _storeIndustryListVoSink.add(storeIndustryListVo);
        _getStoreIndustryListIsFirst = false;
      });
    }
  }

  // 商家列表
  getPageStore(int industryId, latitude, longitude, pageNumber, pageSize) async {
    var formData = {
      'industryId': industryId,
      'lat': latitude,
      'lng': longitude,
      'pageNumber': pageNumber,
      'pageSize': pageSize
    };
    var response = await requestPost('getPageStore', formData: formData);
    ShopListVo shopListVo = ShopListVo.fromJson(response);
    return shopListVo;
  }

  loadMorePageStore(int industryId, latitude, longitude, pageNumber, pageSize) async {
    var formData = {
      'industryId': industryId,
      'lat': latitude,
      'lng': longitude,
      'pageNumber': pageNumber,
      'pageSize': pageSize
    };
    return await requestPost('getPageStore', formData: formData);
  }

  @override
  void dispose() {
    _amapLocation.stopLocate();
    _locationController.close();
    _storeIndustryListVoController.close();
  }

}