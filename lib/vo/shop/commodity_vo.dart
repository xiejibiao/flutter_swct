class CommodityVo {
  String code;
  String message;
  CommodityData data;

  CommodityVo({this.code, this.message, this.data});

  CommodityVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new CommodityData.fromJson(json['data']) : null;
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

class CommodityData {
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

  CommodityData(
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

  CommodityData.fromJson(Map<String, dynamic> json) {
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