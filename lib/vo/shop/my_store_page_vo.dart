class MyStorePageVo {
  String code;
  String message;
  MyStorePageData data;

  MyStorePageVo({this.code, this.message, this.data});

  MyStorePageVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new MyStorePageData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class MyStorePageData {
  List<MyStorePageItem> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  MyStorePageData({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  MyStorePageData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<MyStorePageItem>();
      json['list'].forEach((v) {
        list.add(new MyStorePageItem.fromJson(v));
      });
    }
    totalPage = json['totalPage'];
    pageSize = json['pageSize'];
    pageNumber = json['pageNumber'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['totalPage'] = this.totalPage;
    data['pageSize'] = this.pageSize;
    data['pageNumber'] = this.pageNumber;
    data['count'] = this.count;
    return data;
  }
}

class MyStorePageItem {
  int id;
  String uid;
  int brandId;
  String storeName;
  String address;
  String lat;
  String lng;
  int industryId;
  int provinceId;
  int cityId;
  int areaId;
  int likeVolume;
  int createTime;
  String photo;
  String description;
  String industryName;
  String provinceName;
  String cityName;
  String areaName;
  String licenseCode;
  String licensePhoto;
  String legalPerson;
  int isChecked;
  String reason;
  double area;

  MyStorePageItem(
      {this.id,
      this.uid,
      this.brandId,
      this.storeName,
      this.address,
      this.lat,
      this.lng,
      this.industryId,
      this.provinceId,
      this.cityId,
      this.areaId,
      this.likeVolume,
      this.createTime,
      this.photo,
      this.description,
      this.industryName,
      this.provinceName,
      this.cityName,
      this.areaName,
      this.licenseCode,
      this.licensePhoto,
      this.legalPerson,
      this.isChecked,
      this.reason,
      this.area});

  MyStorePageItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    brandId = json['brandId'];
    storeName = json['storeName'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    industryId = json['industryId'];
    provinceId = json['provinceId'];
    cityId = json['cityId'];
    areaId = json['areaId'];
    likeVolume = json['likeVolume'];
    createTime = json['createTime'];
    photo = json['photo'];
    description = json['description'];
    industryName = json['industryName'];
    provinceName = json['provinceName'];
    cityName = json['cityName'];
    areaName = json['areaName'];
    licenseCode = json['licenseCode'];
    licensePhoto = json['licensePhoto'];
    legalPerson = json['legalPerson'];
    isChecked = json['isChecked'];
    reason = json['reason'];
    area = json['area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['brandId'] = this.brandId;
    data['storeName'] = this.storeName;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['industryId'] = this.industryId;
    data['provinceId'] = this.provinceId;
    data['cityId'] = this.cityId;
    data['areaId'] = this.areaId;
    data['likeVolume'] = this.likeVolume;
    data['createTime'] = this.createTime;
    data['photo'] = this.photo;
    data['description'] = this.description;
    data['industryName'] = this.industryName;
    data['provinceName'] = this.provinceName;
    data['cityName'] = this.cityName;
    data['areaName'] = this.areaName;
    data['licenseCode'] = this.licenseCode;
    data['licensePhoto'] = this.licensePhoto;
    data['legalPerson'] = this.legalPerson;
    data['isChecked'] = this.isChecked;
    data['reason'] = this.reason;
    data['area'] = this.area;
    return data;
  }
}