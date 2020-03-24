class ShopListVo {
  String code;
  String message;
  ShopListData data;

  ShopListVo({this.code, this.message, this.data});

  ShopListVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new ShopListData.fromJson(json['data']) : null;
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

class ShopListData {
  List<ShopData> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  ShopListData({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  ShopListData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<ShopData>();
      json['list'].forEach((v) {
        list.add(new ShopData.fromJson(v));
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

class ShopData {
  int likeVolume;
  String address;
  String lng;
  String storeName;
  String brief;
  double juli;
  String photo;
  int starCode;
  int id;
  String lat;
  int type;
  int status;

  ShopData(
      {this.likeVolume,
      this.address,
      this.lng,
      this.storeName,
      this.brief,
      this.juli,
      this.photo,
      this.id,
      this.lat,
      this.type,
      this.starCode,
      this.status});

  ShopData.fromJson(Map<String, dynamic> json) {
    likeVolume = json['likeVolume'];
    address = json['address'];
    lng = json['lng'];
    storeName = json['storeName'];
    brief = json['brief'];
    juli = json['juli'];
    photo = json['photo'];
    id = json['id'];
    lat = json['lat'];
    type = json['type'];
    starCode = json['starCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['likeVolume'] = this.likeVolume;
    data['address'] = this.address;
    data['lng'] = this.lng;
    data['storeName'] = this.storeName;
    data['brief'] = this.brief;
    data['juli'] = this.juli;
    data['photo'] = this.photo;
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['type'] = this.type;
    data['starCode'] = this.starCode;
    data['status'] = this.status;
    return data;
  }
}