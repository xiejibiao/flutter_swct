class GetShopOrderDetailByOrderIdVo {
  String code;
  String message;
  GetShopOrderDetailByOrderIdData data;

  GetShopOrderDetailByOrderIdVo({this.code, this.message, this.data});

  GetShopOrderDetailByOrderIdVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new GetShopOrderDetailByOrderIdData.fromJson(json['data']) : null;
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

class GetShopOrderDetailByOrderIdData {
  List<OrderDetailListVos> orderDetailListVos;
  OrderEssentialInfoVo orderEssentialInfoVo;
  ReceivingAddressVo receivingAddressVo;
  String avatar;
  String nikeName;

  GetShopOrderDetailByOrderIdData(
      {this.orderDetailListVos,
      this.orderEssentialInfoVo,
      this.receivingAddressVo,
      this.avatar,
      this.nikeName});

  GetShopOrderDetailByOrderIdData.fromJson(Map<String, dynamic> json) {
    if (json['orderDetailListVos'] != null) {
      orderDetailListVos = new List<OrderDetailListVos>();
      json['orderDetailListVos'].forEach((v) {
        orderDetailListVos.add(new OrderDetailListVos.fromJson(v));
      });
    }
    orderEssentialInfoVo = json['orderEssentialInfoVo'] != null
        ? new OrderEssentialInfoVo.fromJson(json['orderEssentialInfoVo'])
        : null;
    receivingAddressVo = json['receivingAddressVo'] != null
        ? new ReceivingAddressVo.fromJson(json['receivingAddressVo'])
        : null;
    avatar = json['avatar'];
    nikeName = json['nikeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDetailListVos != null) {
      data['orderDetailListVos'] =
          this.orderDetailListVos.map((v) => v.toJson()).toList();
    }
    if (this.orderEssentialInfoVo != null) {
      data['orderEssentialInfoVo'] = this.orderEssentialInfoVo.toJson();
    }
    if (this.receivingAddressVo != null) {
      data['receivingAddressVo'] = this.receivingAddressVo.toJson();
    }
    data['avatar'] = this.avatar;
    data['nikeName'] = this.nikeName;
    return data;
  }
}

class OrderDetailListVos {
  int id;
  String orderId;
  int commodityId;
  String commodityName;
  String commodityType;
  String cover;
  double price;
  int num;

  OrderDetailListVos(
      {this.id,
      this.orderId,
      this.commodityId,
      this.commodityName,
      this.commodityType,
      this.cover,
      this.price,
      this.num});

  OrderDetailListVos.fromJson(Map<String, dynamic> json) {
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

class OrderEssentialInfoVo {
  String id;
  int status;
  double money;
  int orderTime;
  int payTime;
  String payChannel;
  String uid;
  int storeId;
  int addressId;

  OrderEssentialInfoVo(
      {this.id,
      this.status,
      this.money,
      this.orderTime,
      this.payTime,
      this.payChannel,
      this.uid,
      this.storeId,
      this.addressId});

  OrderEssentialInfoVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    money = json['money'];
    orderTime = json['orderTime'];
    payTime = json['payTime'];
    payChannel = json['payChannel'];
    uid = json['uid'];
    storeId = json['storeId'];
    addressId = json['addressId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['money'] = this.money;
    data['orderTime'] = this.orderTime;
    data['payTime'] = this.payTime;
    data['payChannel'] = this.payChannel;
    data['uid'] = this.uid;
    data['storeId'] = this.storeId;
    data['addressId'] = this.addressId;
    return data;
  }
}

class ReceivingAddressVo {
  String receiverName;
  String receiverPhone;
  String address;
  String zipCode;
  String provinceName;
  String cityName;
  String areaName;

  ReceivingAddressVo(
      {this.receiverName,
      this.receiverPhone,
      this.address,
      this.zipCode,
      this.provinceName,
      this.cityName,
      this.areaName});

  ReceivingAddressVo.fromJson(Map<String, dynamic> json) {
    receiverName = json['receiverName'];
    receiverPhone = json['receiverPhone'];
    address = json['address'];
    zipCode = json['zipCode'];
    provinceName = json['provinceName'];
    cityName = json['cityName'];
    areaName = json['areaName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiverName'] = this.receiverName;
    data['receiverPhone'] = this.receiverPhone;
    data['address'] = this.address;
    data['zipCode'] = this.zipCode;
    data['provinceName'] = this.provinceName;
    data['cityName'] = this.cityName;
    data['areaName'] = this.areaName;
    return data;
  }
}
