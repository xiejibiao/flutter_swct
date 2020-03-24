class GetSupplierPageVo {
  String code;
  String message;
  List<SupplierPageVo> data;

  GetSupplierPageVo({this.code, this.message, this.data});

  GetSupplierPageVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SupplierPageVo>();
      json['data'].forEach((v) {
        data.add(new SupplierPageVo.fromJson(v));
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

class SupplierPageVo {
  int id;
  String name;
  InfoVoLgmnPage infoVoLgmnPage;

  SupplierPageVo({this.id, this.name, this.infoVoLgmnPage});

  SupplierPageVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    infoVoLgmnPage = json['infoVoLgmnPage'] != null
        ? new InfoVoLgmnPage.fromJson(json['infoVoLgmnPage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.infoVoLgmnPage != null) {
      data['infoVoLgmnPage'] = this.infoVoLgmnPage.toJson();
    }
    return data;
  }
}

class InfoVoLgmnPage {
  List<SupplierInfoVo> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  InfoVoLgmnPage(
      {this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  InfoVoLgmnPage.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<SupplierInfoVo>();
      json['list'].forEach((v) {
        list.add(new SupplierInfoVo.fromJson(v));
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
  int starCode;
  String brief;

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
      this.starCode,
      this.brief,
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
    starCode = json['starCode'];
    brief = json['brief'];
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
    data['starCode'] = this.starCode;
    data['brief'] = this.brief;
    return data;
  }
}
