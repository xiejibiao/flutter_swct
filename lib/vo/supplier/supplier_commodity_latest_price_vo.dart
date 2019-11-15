class SupplierCommodityLatestPriceVo {
  String code;
  String message;
  List<SupplierCommodityLatestVo> data;

  SupplierCommodityLatestPriceVo({this.code, this.message, this.data});

  SupplierCommodityLatestPriceVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SupplierCommodityLatestVo>();
      json['data'].forEach((v) {
        data.add(new SupplierCommodityLatestVo.fromJson(v));
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

class SupplierCommodityLatestVo {
  int id;
  String name;
  String cover;
  double retailPrice;
  int status;
  int delFlag;

  SupplierCommodityLatestVo(
      {this.id,
      this.name,
      this.cover,
      this.retailPrice,
      this.status,
      this.delFlag});

  SupplierCommodityLatestVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    retailPrice = json['retailPrice'];
    status = json['status'];
    delFlag = json['delFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['retailPrice'] = this.retailPrice;
    data['status'] = this.status;
    data['delFlag'] = this.delFlag;
    return data;
  }
}
