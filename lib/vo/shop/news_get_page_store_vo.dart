import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class NewsGetPageStoreVo {
  String code;
  String message;
  List<NewsGetPageStoreVoData> data;

  NewsGetPageStoreVo({this.code, this.message, this.data});

  NewsGetPageStoreVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<NewsGetPageStoreVoData>();
      json['data'].forEach((v) {
        data.add(new NewsGetPageStoreVoData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewsGetPageStoreVoData {
  NewsGetPageStoreDto newsGetPageStoreDto;
  SwcyIndustryEntity swcyIndustryEntity;
  StoreMap storeMap;

  NewsGetPageStoreVoData({this.newsGetPageStoreDto, this.swcyIndustryEntity, this.storeMap});

  NewsGetPageStoreVoData.fromJson(Map<String, dynamic> json) {
    newsGetPageStoreDto = json['newsGetPageStoreDto'] != null
        ? new NewsGetPageStoreDto.fromJson(json['newsGetPageStoreDto'])
        : null;
    swcyIndustryEntity = json['swcyIndustryEntity'] != null
        ? new SwcyIndustryEntity.fromJson(json['swcyIndustryEntity'])
        : null;
    storeMap = json['storeMap'] != null
        ? new StoreMap.fromJson(json['storeMap'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newsGetPageStoreDto != null) {
      data['newsGetPageStoreDto'] = this.newsGetPageStoreDto.toJson();
    }
    if (this.swcyIndustryEntity != null) {
      data['swcyIndustryEntity'] = this.swcyIndustryEntity.toJson();
    }
    if (this.storeMap != null) {
      data['storeMap'] = this.storeMap.toJson();
    }
    return data;
  }
}

class NewsGetPageStoreDto {
  String lat;
  String lng;

  NewsGetPageStoreDto({this.lat, this.lng});

  NewsGetPageStoreDto.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class SwcyIndustryEntity {
  int id;
  int pid;
  String name;
  int status;
  String path;

  SwcyIndustryEntity({this.id, this.pid, this.name, this.status, this.path});

  SwcyIndustryEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    name = json['name'];
    status = json['status'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['status'] = this.status;
    data['path'] = this.path;
    return data;
  }
}

class StoreMap {
  List<StoreItem> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  StoreMap(
      {this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  StoreMap.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<StoreItem>();
      json['list'].forEach((v) {
        list.add(new StoreItem.fromJson(v));
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

class StoreItem {
  int likeVolume;
  String address;
  String lng;
  String photo;
  double juli;
  String storeName;
  int id;
  String lat;

  StoreItem(
      {this.likeVolume,
      this.address,
      this.lng,
      this.photo,
      this.juli,
      this.storeName,
      this.id,
      this.lat});

  StoreItem.fromJson(Map<String, dynamic> json) {
    likeVolume = json['likeVolume'];
    address = json['address'];
    lng = json['lng'];
    photo = json['photo'];
    juli = json['juli'];
    storeName = json['storeName'];
    id = json['id'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['likeVolume'] = this.likeVolume;
    data['address'] = this.address;
    data['lng'] = this.lng;
    data['photo'] = this.photo;
    data['juli'] = this.juli;
    data['storeName'] = this.storeName;
    data['id'] = this.id;
    data['lat'] = this.lat;
    return data;
  }

  List<StoreItem> getStoreItemListFormShopDataList (List<ShopData> shopDataList) {
    List<StoreItem> list = [];
    shopDataList.forEach((item) {
      list.add(StoreItem(
        likeVolume: item.likeVolume,
        address: item.address,
        lng: item.lng,
        photo: item.photo,
        juli: item.juli,
        storeName: item.storeName,
        id: item.id,
        lat: item.lat
      ));
    });
    return list;
  }
}
