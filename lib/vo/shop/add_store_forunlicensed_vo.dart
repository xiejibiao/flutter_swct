class AddStoreForunlicensedVo {
  String code;
  String message;
  AddStoreForunlicensed data;

  AddStoreForunlicensedVo({this.code, this.message, this.data});

  AddStoreForunlicensedVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new AddStoreForunlicensed.fromJson(json['data']) : null;
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

class AddStoreForunlicensed {
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
  dynamic area;
  String phone;
  int starCode;

  AddStoreForunlicensed(
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
      this.area,
      this.phone,
      this.starCode});

  AddStoreForunlicensed.fromJson(Map<String, dynamic> json) {
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
    phone = json['phone'];
    starCode = json['starCode'];
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
    data['phone'] = this.phone;
    data['starCode'] = this.starCode;
    return data;
  }
}
