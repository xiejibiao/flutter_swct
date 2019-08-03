class OrderDetailsVo {
  String code;
  String message;
  OrderVo data;

  OrderDetailsVo({this.code, this.message, this.data});

  OrderDetailsVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new OrderVo.fromJson(json['data']) : null;
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

class OrderVo {
  List<OrderDetailListVo> orderDetailListVo;
  OrderPageVo orderPageVo;

  OrderVo({this.orderDetailListVo, this.orderPageVo});

  OrderVo.fromJson(Map<String, dynamic> json) {
    if (json['orderDetailListVo'] != null) {
      orderDetailListVo = new List<OrderDetailListVo>();
      json['orderDetailListVo'].forEach((v) {
        orderDetailListVo.add(new OrderDetailListVo.fromJson(v));
      });
    }
    orderPageVo = json['orderPageVo'] != null
        ? new OrderPageVo.fromJson(json['orderPageVo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDetailListVo != null) {
      data['orderDetailListVo'] =
          this.orderDetailListVo.map((v) => v.toJson()).toList();
    }
    if (this.orderPageVo != null) {
      data['orderPageVo'] = this.orderPageVo.toJson();
    }
    return data;
  }
}

class OrderDetailListVo {
  int id;
  String orderId;
  int commodityId;
  String commodityName;
  String commodityType;
  String cover;
  double price;
  int num;

  OrderDetailListVo(
      {this.id,
      this.orderId,
      this.commodityId,
      this.commodityName,
      this.commodityType,
      this.cover,
      this.price,
      this.num});

  OrderDetailListVo.fromJson(Map<String, dynamic> json) {
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

class OrderPageVo {
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

  OrderPageVo(
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

  OrderPageVo.fromJson(Map<String, dynamic> json) {
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