class SupplierCommodityPageVo {
  String code;
  String message;
  List<SupplierCommodityPageVoData> data;

  SupplierCommodityPageVo({this.code, this.message, this.data});

  SupplierCommodityPageVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SupplierCommodityPageVoData>();
      json['data'].forEach((v) {
        data.add(new SupplierCommodityPageVoData.fromJson(v));
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

class SupplierCommodityPageVoData {
  int id;
  String name;
  SupplierCommodityInfoVoLgmnPage lgmnPage;

  SupplierCommodityPageVoData({this.id, this.name, this.lgmnPage});

  SupplierCommodityPageVoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lgmnPage = json['lgmnPage'] != null
        ? new SupplierCommodityInfoVoLgmnPage.fromJson(json['lgmnPage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.lgmnPage != null) {
      data['lgmnPage'] = this.lgmnPage.toJson();
    }
    return data;
  }
}

class SupplierCommodityInfoVoLgmnPage {
  List<SupplierCommodityInfoVo> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  SupplierCommodityInfoVoLgmnPage(
      {this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  SupplierCommodityInfoVoLgmnPage.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<SupplierCommodityInfoVo>();
      json['list'].forEach((v) {
        list.add(new SupplierCommodityInfoVo.fromJson(v));
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

class SupplierCommodityInfoVo {
  int id;
  int supplierId;
  int categoryId;
  String name;
  String model;
  String cover;
  String detail;
  double retailPrice;
  String specs;

  SupplierCommodityInfoVo(
      {this.id,
      this.supplierId,
      this.categoryId,
      this.name,
      this.model,
      this.cover,
      this.detail,
      this.retailPrice,
      this.specs});

  SupplierCommodityInfoVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplierId'];
    categoryId = json['categoryId'];
    name = json['name'];
    model = json['model'];
    cover = json['cover'];
    detail = json['detail'];
    retailPrice = json['retailPrice'];
    specs = json['specs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['supplierId'] = this.supplierId;
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    data['model'] = this.model;
    data['cover'] = this.cover;
    data['detail'] = this.detail;
    data['retailPrice'] = this.retailPrice;
    data['specs'] = this.specs;
    return data;
  }
}
