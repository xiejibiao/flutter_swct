class SupplierOrderPageVo {
  String code;
  String message;
  SupplierOrderPageVoData data;

  SupplierOrderPageVo({this.code, this.message, this.data});

  SupplierOrderPageVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new SupplierOrderPageVoData.fromJson(json['data']) : null;
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

class SupplierOrderPageVoData {
  List<SupplierOrderPageVoList> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  SupplierOrderPageVoData({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  SupplierOrderPageVoData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<SupplierOrderPageVoList>();
      json['list'].forEach((v) {
        list.add(new SupplierOrderPageVoList.fromJson(v));
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

class SupplierOrderPageVoList {
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
  Null logisticsNum;
  int addressId;
  String refundsReason;
  SupplierInfoVo supplierInfoVo;
  ReceivingAddressVo receivingAddressVo;
  StoreInfoVo storeInfoVo;
  List<SupplierOrderDetailInfoVos> supplierOrderDetailInfoVos;

  SupplierOrderPageVoList(
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
      this.supplierInfoVo,
      this.receivingAddressVo,
      this.storeInfoVo,
      this.supplierOrderDetailInfoVos});

  SupplierOrderPageVoList.fromJson(Map<String, dynamic> json) {
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
    supplierInfoVo = json['supplierInfoVo'] != null
        ? new SupplierInfoVo.fromJson(json['supplierInfoVo'])
        : null;
    receivingAddressVo = json['receivingAddressVo'] != null
        ? new ReceivingAddressVo.fromJson(json['receivingAddressVo'])
        : null;
    storeInfoVo = json['storeInfoVo'] != null
        ? new StoreInfoVo.fromJson(json['storeInfoVo'])
        : null;
    if (json['supplierOrderDetailInfoVos'] != null) {
      supplierOrderDetailInfoVos = new List<SupplierOrderDetailInfoVos>();
      json['supplierOrderDetailInfoVos'].forEach((v) {
        supplierOrderDetailInfoVos
            .add(new SupplierOrderDetailInfoVos.fromJson(v));
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
    if (this.supplierInfoVo != null) {
      data['supplierInfoVo'] = this.supplierInfoVo.toJson();
    }
    if (this.receivingAddressVo != null) {
      data['receivingAddressVo'] = this.receivingAddressVo.toJson();
    }
    if (this.storeInfoVo != null) {
      data['storeInfoVo'] = this.storeInfoVo.toJson();
    }
    if (this.supplierOrderDetailInfoVos != null) {
      data['supplierOrderDetailInfoVos'] =
          this.supplierOrderDetailInfoVos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SupplierInfoVo {
  int id;
  String name;
  String address;
  String lat;
  String lng;
  String photo;
  String provinceName;
  String cityName;
  String areaName;
  String phone;
  int status;
  String logo;
  String description;

  SupplierInfoVo(
      {this.id,
      this.name,
      this.address,
      this.lat,
      this.lng,
      this.photo,
      this.provinceName,
      this.cityName,
      this.areaName,
      this.phone,
      this.status,
      this.logo,
      this.description});

  SupplierInfoVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    photo = json['photo'];
    provinceName = json['provinceName'];
    cityName = json['cityName'];
    areaName = json['areaName'];
    phone = json['phone'];
    status = json['status'];
    logo = json['logo'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['photo'] = this.photo;
    data['provinceName'] = this.provinceName;
    data['cityName'] = this.cityName;
    data['areaName'] = this.areaName;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['logo'] = this.logo;
    data['description'] = this.description;
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

class StoreInfoVo {
  String storeName;
  String address;
  String photo;
  String provinceName;
  String cityName;
  String areaName;
  String phone;

  StoreInfoVo(
      {this.storeName,
      this.address,
      this.photo,
      this.provinceName,
      this.cityName,
      this.areaName,
      this.phone});

  StoreInfoVo.fromJson(Map<String, dynamic> json) {
    storeName = json['storeName'];
    address = json['address'];
    photo = json['photo'];
    provinceName = json['provinceName'];
    cityName = json['cityName'];
    areaName = json['areaName'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeName'] = this.storeName;
    data['address'] = this.address;
    data['photo'] = this.photo;
    data['provinceName'] = this.provinceName;
    data['cityName'] = this.cityName;
    data['areaName'] = this.areaName;
    data['phone'] = this.phone;
    return data;
  }
}

class SupplierOrderDetailInfoVos {
  String commodityName;
  String commodityType;
  String cover;
  double price;
  int num;

  SupplierOrderDetailInfoVos(
      {this.commodityName,
      this.commodityType,
      this.cover,
      this.price,
      this.num});

  SupplierOrderDetailInfoVos.fromJson(Map<String, dynamic> json) {
    commodityName = json['commodityName'];
    commodityType = json['commodityType'];
    cover = json['cover'];
    price = json['price'];
    num = json['num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commodityName'] = this.commodityName;
    data['commodityType'] = this.commodityType;
    data['cover'] = this.cover;
    data['price'] = this.price;
    data['num'] = this.num;
    return data;
  }
}
