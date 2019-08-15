class ShopTypeAndEssentialMessageVo {
  String code;
  String message;
  ShopTypeAndEssentialMessageData data;

  ShopTypeAndEssentialMessageVo({this.code, this.message, this.data});

  ShopTypeAndEssentialMessageVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new ShopTypeAndEssentialMessageData.fromJson(json['data']) : null;
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

class ShopTypeAndEssentialMessageData {
  SwcyStoreEntity swcyStoreEntity;
  List<CommodityTypeList> commodityTypeList;
  bool follow;

  ShopTypeAndEssentialMessageData({this.swcyStoreEntity, this.commodityTypeList, this.follow});

  ShopTypeAndEssentialMessageData.fromJson(Map<String, dynamic> json) {
    swcyStoreEntity = json['swcyStoreEntity'] != null
        ? new SwcyStoreEntity.fromJson(json['swcyStoreEntity'])
        : null;
    if (json['commodityTypeList'] != null) {
      commodityTypeList = new List<CommodityTypeList>();
      json['commodityTypeList'].forEach((v) {
        commodityTypeList.add(new CommodityTypeList.fromJson(v));
      });
    }
    follow = json['follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.swcyStoreEntity != null) {
      data['swcyStoreEntity'] = this.swcyStoreEntity.toJson();
    }
    if (this.commodityTypeList != null) {
      data['commodityTypeList'] =
          this.commodityTypeList.map((v) => v.toJson()).toList();
    }
    data['follow'] = this.follow;
    return data;
  }
}

class SwcyStoreEntity {
  int id;
  String uid;
  int brandId;
  String name;
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
  String desc;

  SwcyStoreEntity(
      {this.id,
      this.uid,
      this.brandId,
      this.name,
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
      this.desc});

  SwcyStoreEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    brandId = json['brandId'];
    name = json['name'];
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
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['brandId'] = this.brandId;
    data['name'] = this.name;
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
    data['desc'] = this.desc;
    return data;
  }
}

class CommodityTypeList {
  int id;
  int storeId;
  String name;
  int status;

  CommodityTypeList({this.id, this.storeId, this.name, this.status});

  CommodityTypeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['storeId'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['storeId'] = this.storeId;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
