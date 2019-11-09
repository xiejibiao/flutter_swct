class GetOrderPageByStoreIdVo {
  String code;
  String message;
  OrderPageData data;

  GetOrderPageByStoreIdVo({this.code, this.message, this.data});

  GetOrderPageByStoreIdVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new OrderPageData.fromJson(json['data']) : null;
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

class OrderPageData {
  List<DataItem> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  OrderPageData({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  OrderPageData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<DataItem>();
      json['list'].forEach((v) {
        list.add(new DataItem.fromJson(v));
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

class DataItem {
  String id;
  int status;
  int orderTime;
  String uid;
  int storeId;
  String avatar;
  String nikeName;
  String address;
  String provinceName;
  String cityName;
  String areaName;

  DataItem(
      {this.id,
      this.status,
      this.orderTime,
      this.uid,
      this.storeId,
      this.avatar,
      this.nikeName,
      this.address,
      this.provinceName,
      this.cityName,
      this.areaName});

  DataItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    orderTime = json['orderTime'];
    uid = json['uid'];
    storeId = json['storeId'];
    avatar = json['avatar'];
    nikeName = json['nikeName'];
    address = json['address'];
    provinceName = json['provinceName'];
    cityName = json['cityName'];
    areaName = json['areaName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['orderTime'] = this.orderTime;
    data['uid'] = this.uid;
    data['storeId'] = this.storeId;
    data['avatar'] = this.avatar;
    data['nikeName'] = this.nikeName;
    data['address'] = this.address;
    data['provinceName'] = this.provinceName;
    data['cityName'] = this.cityName;
    data['areaName'] = this.areaName;
    return data;
  }
}
