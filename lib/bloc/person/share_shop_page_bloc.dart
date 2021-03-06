import 'package:amap_base/amap_base.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/common/image_upload.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/shop/add_store_forunlicensed_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_page_by_commodity_type_vo.dart';
import 'package:flutter_swcy/vo/shop/commodity_vo.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class ShareShopPageBloc extends BlocBase {
  // static const String QI_NIU_URI = 'http://qncdn.gdsdec.com/';
  bool isEnd = false;
  int _pageNumber = 0, _pageSize = 10;

  // 我的共享店
  MyStorePageVo _myStorePageVo;
  BehaviorSubject<MyStorePageVo> _myStorePageVoController = BehaviorSubject<MyStorePageVo>();
  Sink<MyStorePageVo> get _myStorePageVoSink => _myStorePageVoController.sink;
  Stream<MyStorePageVo> get myStorePageVoStream => _myStorePageVoController.stream;

  // 共享店封面照
  BehaviorSubject<String> _shorePhotoController = BehaviorSubject<String>();
  Sink<String> get _shorePhotoSink => _shorePhotoController.sink;
  Stream<String> get shorePhotoStream => _shorePhotoController.stream;

  // 定位
  BehaviorSubject<Location> _locationController = BehaviorSubject<Location>();
  Sink<Location> get _locationSink => _locationController.sink;
  Stream<Location> get locationStream => _locationController.stream;

  /// 提交Loading
  BehaviorSubject<bool> _loadingController = BehaviorSubject<bool>();
  Sink<bool> get _loadingSink => _loadingController.sink;
  Stream<bool> get loadingStream => _loadingController.stream;

  // 我的共享店列表
  getMyStorePage(BuildContext context, {int pageSize}) async {
    await getToken().then((token) async {
      _pageNumber = 0;
      var formData = {
        'pageNumber': _pageNumber,
        'pageSize': pageSize == null ? _pageSize : pageSize
      };
      await requestPost('getMyStorePage', formData: formData, context: context, token: token).then((val) {
        MyStorePageVo temp = MyStorePageVo.fromJson(val);
        _myStorePageVo = temp;
        setIsEnd(temp.data.totalPage);
        _myStorePageVoSink.add(_myStorePageVo);
      });
    });
  }

  // 我的共享店列表加载更多
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

  // 我们共享店列表是否到底
  setIsEnd(int totalPage) {
    if (totalPage == _pageNumber + 1) {
      isEnd = true;
    } else {
      isEnd = false;
    }
  }

  // 获取相册文件并上传
  getShorePhoto() async {
    await ImageUpload().uploadImage().then((val) {
      if (!TextUtil.isEmpty(val)) {
        _shorePhotoSink.add(val);
      }
    });
  }

  // 添加商品获取相册文件并上传
  addCommodityGetShorePhoto() async {
    await ImageUpload().tailoringUploadImage().then((val) {
      if (!TextUtil.isEmpty(val)) {
        _shorePhotoSink.add(val);
      }
    });
  }

  // 初始化定位
  final _amapLocation = AMapLocation();
  initAMapLocation() {
    _amapLocation.init();
  }

  //  获取定位
  getLocation() async {
    final options = LocationClientOptions(
                      isOnceLocation: true,
                      locatingWithReGeocode: true
                    );
      if (await Permissions().requestPermission()) {
        _amapLocation.getLocation(options).then((val) {
          _locationSink.add(val);
        });
      } else {
        showToast('权限不足');
      }
  }

  // 校验基本参数
  bool _validateEssentialMsg({
      @required String photo, 
      @required String address, 
      @required String provinceName, 
      @required String cityName, 
      @required String areaName, 
      @required String industryName, 
      @required String legalPerson, 
      @required String name, 
      @required String brief, 
      @required String area, 
      @required int industryId,
      @required String phone,
      @required int starCode
    }) {
    if (TextUtil.isEmpty(photo)) {
      showToast('请选择仓店封面');
      return false;
    }
    if (TextUtil.isEmpty(name)) {
      showToast('请输入仓店名称');
      return false;
    }
    if (TextUtil.isEmpty(brief)) {
      showToast('请输入仓店简介');
      return false;
    }
    if (TextUtil.isEmpty(legalPerson)) {
      showToast('请输入仓店法人');
      return false;
    }
    if (TextUtil.isEmpty(areaName) || TextUtil.isEmpty(cityName) || TextUtil.isEmpty(provinceName)) {
      showToast('请获取当前定位');
      return false;
    }
    if (TextUtil.isEmpty(address)) {
      showToast('请输入仓店附近街道');
      return false;
    }
    if (TextUtil.isEmpty(area)) {
      showToast('请输入仓店面积');
      return false;
    }
    if (TextUtil.isEmpty(industryName) || industryId == null) {
      showToast('请选择行业类型');
      return false;
    }
    var phoneRegExp = RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
    if (!phoneRegExp.hasMatch(phone)) {
      showToast('联系电话输入有误');
      return false;
    }
    if (starCode == null) {
      showToast('请选择共享星级');
      return false;
    }
    return true;
  }

  // 校验认证参数
  _validateAuthenticationMsg(
    {
      @required String licenseCode, 
      @required String licensePhoto
    }) {
    if (TextUtil.isEmpty(licenseCode)) {
      showToast('请输入执照代码');
      return false;
    }
    if (TextUtil.isEmpty(licensePhoto)) {
      showToast('请上传执照副本');
      return false;
    }
    return true;
  }

  // 提交基本信息
  submitEssentialMsg({
      @required BuildContext context,
      @required String photo, 
      @required String address, 
      @required String provinceName, 
      @required String cityName, 
      @required String areaName, 
      @required String industryName, 
      @required String legalPerson, 
      @required String name, 
      @required String brief, 
      @required String area, 
      @required int industryId,
      @required String lat,
      @required String lng,
      @required String phone,
      @required int starCode,
      @required int id
    }) {
    bool validateFormData = _validateEssentialMsg(
      photo: photo, 
      address: address, 
      provinceName: provinceName, 
      cityName: cityName, 
      areaName: areaName, 
      industryName: industryName, 
      legalPerson: legalPerson,
      name: name, 
      brief: brief, 
      area: area, 
      industryId: industryId,
      phone: phone,
      starCode: starCode);

    if (validateFormData) {
      _addStoreForUnlicensed(
        context: context,
        photo: photo, 
        address: address, 
        provinceName: provinceName, 
        cityName: cityName, 
        areaName: areaName, 
        industryName: industryName, 
        legalPerson: legalPerson,
        name: name, 
        brief: brief,
        area: area, 
        industryId: industryId,
        lat: lat,
        lng: lng,
        phone: phone,
        starCode: starCode,
        id: id
      );
    }
  }

  // 提交认证参数
  submitAuthenticationMsg({
    @required BuildContext context,
    @required int id, 
    @required String licenseCode, 
    @required String licensePhoto
  }) {
    bool validateAuthenticationMsg = _validateAuthenticationMsg(licenseCode: licenseCode, licensePhoto: licensePhoto);
    if (validateAuthenticationMsg) {
      _authenticationStore(context, id: id, licenseCode: licenseCode, licensePhoto: licensePhoto);
    }
  }
  
  // 添加无证共享店
  _addStoreForUnlicensed({
    @required BuildContext context,
    @required String photo, 
    @required String address, 
    @required String provinceName, 
    @required String cityName, 
    @required String areaName, 
    @required String industryName, 
    @required String legalPerson, 
    @required String name, 
    @required String brief, 
    @required String area, 
    @required int industryId,
    @required String lat,
    @required String lng,
    @required String phone,
    @required int starCode,
    @required int id,
  }) async {
    _loadingSink.add(true);
    await getToken().then((token) async {
      var formData = {
        'id': id,
        'address': address,
        'area': area,
        'areaName': areaName,
        'cityName': cityName,
        'industryId': industryId,
        'industryName': industryName,
        'lat': lat,
        'legalPerson': legalPerson,
        'lng': lng,
        'phone': phone,
        'photo': photo,
        'provinceName': provinceName,
        'starCode': starCode,
        'storeName': name,
        'brief': brief,
      };
      await requestPost('addStoreForUnlicensed', context: context, token: token, formData: formData).then((val) {
        _loadingSink.add(false);
        AddStoreForunlicensedVo addStoreForunlicensedVo = AddStoreForunlicensedVo.fromJson(val);
        if (addStoreForunlicensedVo.code == '200') {
          showToast('上传成功');
          Navigator.pop(context, addStoreForunlicensedVo);
        } else {
          showToast('上传失败:${addStoreForunlicensedVo.message}');
        }
      });
    });
  }

  /// 认证共享店
  _authenticationStore(BuildContext context, {@required int id, @required String licenseCode, @required String licensePhoto}) {
    getToken().then((token) {
      var formData = {
        'id': id,
        'licenseCode': licenseCode,
        'licensePhoto': licensePhoto
      };
      requestPost('authenticationStore', token: token, context: context, formData: formData).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          _myStorePageVo.data.list.forEach((item) {
            if (item.id == id) {
              item.isChecked = 0;
              item.licenseCode = '1';
            }
          });
          showToast('提交认证成功');
          Navigator.pop(context);
        } else {
          showToast(commenVo.message);
        }
      });
    });
  }

  /// 检验添加商品参数
  bool _checkAddCommodityParameter(String cover, String name, double price, String specs) {
    if (TextUtil.isEmpty(cover)) {
      showToast('请上传封面图');
      return false;
    }
    if (TextUtil.isEmpty(name)) {
      showToast('请输入商品名称');
      return false;
    }
    if (price == null) {
      showToast('请输入单价');
      return false;
    }
    if (TextUtil.isEmpty(specs)) {
      showToast('请输入规格');
      return false;
    }
    return true;
  }

  /// 添加商品
  addCommodity(BuildContext context, String cover, String name, double price, String specs, int stock, String notes, int typeId, ShopPagesBloc bloc) {
    if (_checkAddCommodityParameter(cover, name, price, specs)) {
      var formData = {
        'cover': cover,
        'name': name,
        'price': price,
        'specs': specs,
        'typeId': typeId,
        'stock': stock,
        'notes': notes
      };
      requestPost('addCommodity', formData: formData).then((val) {
        CommodityVo commodityVo = CommodityVo.fromJson(val);
        if(commodityVo.code == '200') {
          showToast('添加商品成功');
          CommodityList commodityList = _getCommodityItem(commodityVo);
          bloc.addCommodityToList(commodityList);
          Navigator.pop(context);
        } else {
          showToast(commodityVo.message);
        }
      });
    }
  }

  /// 删除商品
  deleteCommodity(int id, ShopPagesBloc bloc) {
    var formData = {
      'id': id
    };
    requestPost('deleteCommodity', formData: formData).then((val) {
      CommenVo commenVo = CommenVo.fromJson(val);
      if (commenVo.code == '200') {
        showToast('删除成功');
        bloc.removeCommodityById(id);
      } else {
        showToast(commenVo.message);
      }
    });
  }

  /// 修改商品
  editCommodity(BuildContext context, String cover, int id, String name, double price, String specs, int stock, String notes, int typeId, ShopPagesBloc bloc) {
    if (_checkAddCommodityParameter(cover, name, price, specs)) {
      var formData = {
        'cover': cover,
        'id': id,
        'name': name,
        'price': price,
        'specs': specs,
        'typeId': typeId,
        'stock': stock,
        'notes': notes
      };
      requestPost('editCommodity', formData: formData).then((val) {
        CommodityVo commodityVo = CommodityVo.fromJson(val);
        if(commodityVo.code == '200') {
          showToast('修改商品成功');
          CommodityList commodityList = _getCommodityItem(commodityVo);
          bloc.editCommodityToList(commodityList);
          Navigator.pop(context);
        } else {
          showToast(commodityVo.message);
        }
      });
    }
  }

  /// 组装单个商品对象
  CommodityList _getCommodityItem(CommodityVo commodityVo) {
    CommodityList commodityList = CommodityList(
      id: commodityVo.data.id,
      typeId: commodityVo.data.id,
      name: commodityVo.data.name,
      cover: commodityVo.data.cover,
      detail: commodityVo.data.detail,
      specs: commodityVo.data.specs,
      stock: commodityVo.data.stock,
      price: commodityVo.data.price,
      status: commodityVo.data.status,
      createTime: commodityVo.data.createTime,
      delFlag: commodityVo.data.delFlag,
      notes: commodityVo.data.notes
    );
    return commodityList;
  }

  /// 上架、下架
  upperShelfAndLowerShelf(int id, ShopPagesBloc bloc) {
    var formData = {
      'id': id
    };
    requestPost('upperShelfAndLowerShelf', formData: formData).then((val) {
      CommodityVo commodityVo = CommodityVo.fromJson(val);
      if(commodityVo.code == '200') {
          showToast(commodityVo.data.status == 0 ? '商品下架成功' : '商品上架成功');
          CommodityList commodityList = _getCommodityItem(commodityVo);
          bloc.editCommodityToList(commodityList);
        } else {
          showToast(commodityVo.message);
        }
    });
  }

  Future getSettingStars() {
    return requestPost('getSettingStars');
  }

  // 修改分享店详情后，重新修改分享店详情字段
  resetStoreDescription(String description, int id) {
    int editIndex = 0;
    for(int i = 0; i < _myStorePageVo.data.list.length; i++) {
      if (_myStorePageVo.data.list[i].id == id) {
        editIndex = i;
        break;
      }
    }
    _myStorePageVo.data.list[editIndex].description= description;
    _myStorePageVoSink.add(_myStorePageVo);
  }

  /// 修改分享店后，重新修改分享店Item
  resetStoreItem(AddStoreForunlicensed addStoreForunlicensed) {
    int editIndex = 0;
    for(int i = 0; i < _myStorePageVo.data.list.length; i++) {
      if (_myStorePageVo.data.list[i].id == addStoreForunlicensed.id) {
        editIndex = i;
        break;
      }
    }
    MyStorePageItem myStorePageItem = MyStorePageItem(
      id: addStoreForunlicensed.id,
      uid: addStoreForunlicensed.uid,
      brandId: addStoreForunlicensed.brandId,
      storeName: addStoreForunlicensed.storeName,
      brief: addStoreForunlicensed.brief,
      address: addStoreForunlicensed.address,
      lat: addStoreForunlicensed.lat,
      lng: addStoreForunlicensed.lng,
      industryId: addStoreForunlicensed.industryId,
      provinceId: addStoreForunlicensed.provinceId,
      cityId: addStoreForunlicensed.cityId,
      areaId: addStoreForunlicensed.areaId,
      likeVolume: addStoreForunlicensed.likeVolume,
      createTime: addStoreForunlicensed.createTime,
      photo: addStoreForunlicensed.photo,
      description: addStoreForunlicensed.description,
      industryName: addStoreForunlicensed.industryName,
      provinceName: addStoreForunlicensed.provinceName,
      cityName: addStoreForunlicensed.cityName,
      areaName: addStoreForunlicensed.areaName,
      licenseCode: addStoreForunlicensed.licenseCode,
      licensePhoto: addStoreForunlicensed.licensePhoto,
      legalPerson: addStoreForunlicensed.legalPerson,
      isChecked: addStoreForunlicensed.isChecked,
      reason: addStoreForunlicensed.reason,
      area: double.parse(addStoreForunlicensed.area.toString()),
      phone: addStoreForunlicensed.phone,
      starCode: addStoreForunlicensed.starCode,
      type: addStoreForunlicensed.type
    );
    _myStorePageVo.data.list[editIndex]= myStorePageItem;
    _myStorePageVoSink.add(_myStorePageVo);
  }

  /// 删除共享店
  delStoreItem(int storeId, BuildContext context) {
    getToken().then((token) {
      var formData = {
        'storeId': storeId
      };
      requestPost('delStoreById', context: context, formData: formData, token: token).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          showToast(commenVo.message);
          getMyStorePage(context);
        } else {
          showToast(commenVo.message);
        }
      });
    });
  }

  @override
  void dispose() {
    _myStorePageVoController.close();
    _shorePhotoController.close();
    _locationController.close();
    _loadingController.close();
  }
}