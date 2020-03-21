class LeagueStoreOrderPageVo {
  String code;
  String message;
  LeagueStoreOrderPageVoData data;

  LeagueStoreOrderPageVo({this.code, this.message, this.data});

  LeagueStoreOrderPageVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new LeagueStoreOrderPageVoData.fromJson(json['data']) : null;
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

class LeagueStoreOrderPageVoData {
  List<LeagueStoreOrderPageVoList> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  LeagueStoreOrderPageVoData({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  LeagueStoreOrderPageVoData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<LeagueStoreOrderPageVoList>();
      json['list'].forEach((v) {
        list.add(new LeagueStoreOrderPageVoList.fromJson(v));
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

class LeagueStoreOrderPageVoList {
  String id;
  int status;
  double money;
  int orderTime;
  int payTime;
  String payChannel;
  String payNum;
  int supplierId;
  String storeOwnerId;
  int storeId;
  String logisticsNum;
  int addressId;
  String refundsReason;
  int commTypeSum;
  List<LeagueStoreOrderDetialsList> list;

  LeagueStoreOrderPageVoList(
      {this.id,
      this.status,
      this.money,
      this.orderTime,
      this.payTime,
      this.payChannel,
      this.payNum,
      this.supplierId,
      this.storeOwnerId,
      this.storeId,
      this.logisticsNum,
      this.addressId,
      this.refundsReason,
      this.commTypeSum,
      this.list});

  LeagueStoreOrderPageVoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    money = json['money'];
    orderTime = json['orderTime'];
    payTime = json['payTime'];
    payChannel = json['payChannel'];
    payNum = json['payNum'];
    supplierId = json['supplierId'];
    storeOwnerId = json['storeOwnerId'];
    storeId = json['storeId'];
    logisticsNum = json['logisticsNum'];
    addressId = json['addressId'];
    refundsReason = json['refundsReason'];
    commTypeSum = json['commTypeSum'];
    if (json['list'] != null) {
      list = new List<LeagueStoreOrderDetialsList>();
      json['list'].forEach((v) {
        list.add(new LeagueStoreOrderDetialsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['money'] = this.money;
    data['orderTime'] = this.orderTime;
    data['payTime'] = this.payTime;
    data['payChannel'] = this.payChannel;
    data['payNum'] = this.payNum;
    data['supplierId'] = this.supplierId;
    data['storeOwnerId'] = this.storeOwnerId;
    data['storeId'] = this.storeId;
    data['logisticsNum'] = this.logisticsNum;
    data['addressId'] = this.addressId;
    data['refundsReason'] = this.refundsReason;
    data['commTypeSum'] = this.commTypeSum;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeagueStoreOrderDetialsList {
  int id;
  String orderId;
  int commodityId;
  String commodityName;
  String commodityType;
  String cover;
  double price;
  int num;

  LeagueStoreOrderDetialsList(
      {this.id,
      this.orderId,
      this.commodityId,
      this.commodityName,
      this.commodityType,
      this.cover,
      this.price,
      this.num});

  LeagueStoreOrderDetialsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    commodityId = json['commodityId'];
    commodityName = json['commodityName'];
    commodityType = json['commodityType'];
    cover = json['cover'];
    price = json['price'];
    num = json['num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['commodityId'] = this.commodityId;
    data['commodityName'] = this.commodityName;
    data['commodityType'] = this.commodityType;
    data['cover'] = this.cover;
    data['price'] = this.price;
    data['num'] = this.num;
    return data;
  }
}