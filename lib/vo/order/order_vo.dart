class OrderPageVo {
  String code;
  String message;
  OrderList data;

  OrderPageVo({this.code, this.message, this.data});

  OrderPageVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new OrderList.fromJson(json['data']) : null;
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

class OrderList {
  List<OrderVo> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  OrderList({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  OrderList.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<OrderVo>();
      json['list'].forEach((v) {
        list.add(new OrderVo.fromJson(v));
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

class OrderVo {
  String id;
  int status;
  double money;
  int orderTime;
  int storeId;
  String storeName;
  String imageUrl;
  int payTime;
  String payChannel;
  String payNum;
  String uid;
  String logisticsNum;

  OrderVo(
      {this.id,
      this.status,
      this.money,
      this.orderTime,
      this.storeId,
      this.storeName,
      this.imageUrl,
      this.payTime,
      this.payChannel,
      this.payNum,
      this.uid,
      this.logisticsNum});

  OrderVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    money = json['money'];
    orderTime = json['orderTime'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    imageUrl = json['imageUrl'];
    payTime = json['payTime'];
    payChannel = json['payChannel'];
    payNum = json['payNum'];
    uid = json['uid'];
    logisticsNum = json['logisticsNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['money'] = this.money;
    data['orderTime'] = this.orderTime;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['imageUrl'] = this.imageUrl;
    data['payTime'] = this.payTime;
    data['payChannel'] = this.payChannel;
    data['payNum'] = this.payNum;
    data['uid'] = this.uid;
    data['logisticsNum'] = this.logisticsNum;
    return data;
  }
}