import 'dart:convert';

import 'package:amap_base/amap_base.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';
import 'package:flutter_swcy/vo/shop/store_industry_list_from_cache_vo.dart';
import 'package:flutter_swcy/vo/shop/store_industry_list_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPageBloc extends BlocBase {
  bool _getLocationIsFirst = true;
  Map<String, bool> getPageStoreIsFirst = Map<String, bool>();

  // 定位
  Location location;
  BehaviorSubject<Location> _locationController = BehaviorSubject<Location>();
  Sink<Location> get _locationSink => _locationController.sink;
  Stream<Location> get locationStream => _locationController.stream;

  // 商家类型缓存Key
  final String storeIndustryListKey = 'STORE_INDUSTRY_LIST';

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

  // 初始化时，获取商家类型列表并缓存化
  getAndSaveStoreIndustryList() async {
    await requestPost('getStoreIndustryList').then((val) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      StoreIndustryListVo temp = StoreIndustryListVo.fromJson(val);
      List<Map> tempList = [];
      temp.data.forEach((item){
        Map<String, dynamic> newStoreIndustry = {
          'id': item.id,
          'name': item.name      
        };
        tempList.add(newStoreIndustry);
      });
      String storeIndustryListString = json.encode(tempList).toString();
      sharedPreferences.setString(storeIndustryListKey, storeIndustryListString);
    });
  }

  Future getStoreIndustryListFromCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String storeIndustryListString = sharedPreferences.getString(storeIndustryListKey);
    List<Map> tempList = (json.decode(storeIndustryListString.toString()) as List).cast();
    if (tempList != null) {
      List<StoreIndustryListFromCacheVo> storeIndustryListFromCacheList = [];
      tempList.forEach((item) {
        storeIndustryListFromCacheList.add(StoreIndustryListFromCacheVo.fromJson(item));
      });
      return storeIndustryListFromCacheList;
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
  }
}