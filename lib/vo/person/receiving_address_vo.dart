class ReceivingAddressVo {
  String code;
  String message;
  List<ReceivingAddress> data;

  ReceivingAddressVo({this.code, this.message, this.data});

  ReceivingAddressVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ReceivingAddress>();
      json['data'].forEach((v) {
        data.add(new ReceivingAddress.fromJson(v));
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

class ReceivingAddress {
  int id;
  String uid;
  String receiverName;
  String receiverPhone;
  String address;
  String zipCode;
  int delFlag;
  String provinceName;
  String cityName;
  String areaName;

  ReceivingAddress(
      {this.id,
      this.uid,
      this.receiverName,
      this.receiverPhone,
      this.address,
      this.zipCode,
      this.delFlag});

  ReceivingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    receiverName = json['receiverName'];
    receiverPhone = json['receiverPhone'];
    address = json['address'];
    zipCode = json['zipCode'];
    delFlag = json['delFlag'];
    provinceName = json['provinceName'];
    cityName = json['cityName'];
    areaName = json['areaName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['receiverName'] = this.receiverName;
    data['receiverPhone'] = this.receiverPhone;
    data['address'] = this.address;
    data['zipCode'] = this.zipCode;
    data['delFlag'] = this.delFlag;
    data['provinceName'] = this.provinceName;
    data['cityName'] = this.cityName;
    data['areaName'] = this.areaName;
    return data;
  }
}