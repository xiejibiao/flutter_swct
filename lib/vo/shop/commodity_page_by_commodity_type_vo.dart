class CommodityPageByCommodityTypeVo {
  String code;
  String message;
  CommodityPageByCommodityTypeData data;

  CommodityPageByCommodityTypeVo({this.code, this.message, this.data});

  CommodityPageByCommodityTypeVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new CommodityPageByCommodityTypeData.fromJson(json['data']) : null;
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

class CommodityPageByCommodityTypeData {
  List<CommodityList> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  CommodityPageByCommodityTypeData({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  CommodityPageByCommodityTypeData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<CommodityList>();
      json['list'].forEach((v) {
        list.add(new CommodityList.fromJson(v));
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

class CommodityList {
  int id;
  int typeId;
  String name;
  String cover;
  String detail;
  String specs;
  int stock;
  double price;
  int status;
  int createTime;
  int delFlag;
  String notes;

  CommodityList(
      {this.id,
      this.typeId,
      this.name,
      this.cover,
      this.detail,
      this.specs,
      this.stock,
      this.price,
      this.status,
      this.createTime,
      this.delFlag,
      this.notes});

  CommodityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['typeId'];
    name = json['name'];
    cover = json['cover'];
    detail = json['detail'];
    specs = json['specs'];
    stock = json['stock'];
    price = json['price'];
    status = json['status'];
    createTime = json['createTime'];
    delFlag = json['delFlag'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['typeId'] = this.typeId;
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['detail'] = this.detail;
    data['specs'] = this.specs;
    data['stock'] = this.stock;
    data['price'] = this.price;
    data['status'] = this.status;
    data['createTime'] = this.createTime;
    data['delFlag'] = this.delFlag;
    data['notes'] = this.notes;
    return data;
  }
}
