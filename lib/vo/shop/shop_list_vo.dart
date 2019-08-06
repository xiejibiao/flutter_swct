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
  String name;
  double juli;
  String photo;
  int id;
  String lat;

  ShopData(
      {this.likeVolume,
      this.address,
      this.lng,
      this.name,
      this.juli,
      this.photo,
      this.id,
      this.lat});

  ShopData.fromJson(Map<String, dynamic> json) {
    likeVolume = json['likeVolume'];
    address = json['address'];
    lng = json['lng'];
    name = json['name'];
    juli = json['juli'];
    photo = json['photo'];
    id = json['id'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['likeVolume'] = this.likeVolume;
    data['address'] = this.address;
    data['lng'] = this.lng;
    data['name'] = this.name;
    data['juli'] = this.juli;
    data['photo'] = this.photo;
    data['id'] = this.id;
    data['lat'] = this.lat;
    return data;
  }
}