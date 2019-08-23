class CommodityShopingCarVo {
  String code;
  String message;
  List<CommodityShopingCarData> data;

  CommodityShopingCarVo({this.code, this.message, this.data});

  CommodityShopingCarVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CommodityShopingCarData>();
      json['data'].forEach((v) {
        data.add(new CommodityShopingCarData.fromJson(v));
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

class CommodityShopingCarData {
  int id;
  int typeId;
  String name;
  String cover;
  String detail;
  double price;
  String specs;
  int status;
  int createTime;
  int delFlag;

  CommodityShopingCarData(
      {this.id,
      this.typeId,
      this.name,
      this.cover,
      this.detail,
      this.price,
      this.specs,
      this.status,
      this.createTime,
      this.delFlag});

  CommodityShopingCarData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['typeId'];
    name = json['name'];
    cover = json['cover'];
    detail = json['detail'];
    price = json['price'];
    specs = json['specs'];
    status = json['status'];
    createTime = json['createTime'];
    delFlag = json['delFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['typeId'] = this.typeId;
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['detail'] = this.detail;
    data['price'] = this.price;
    data['specs'] = this.specs;
    data['status'] = this.status;
    data['createTime'] = this.createTime;
    data['delFlag'] = this.delFlag;
    return data;
  }
}