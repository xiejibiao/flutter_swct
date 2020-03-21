import 'package:flutter_swcy/vo/supplier/get_supplier_page_vo.dart';

class LeagueStoreGetSupplierVo {
  String code;
  String message;
  SupplierInfoVo data;

  LeagueStoreGetSupplierVo({this.code, this.message, this.data});

  LeagueStoreGetSupplierVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new SupplierInfoVo.fromJson(json['data']) : null;
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

// class LeagueStoreGetSupplierVoData {
//   int id;
//   String name;
//   String address;
//   String lat;
//   String lng;
//   String photo;
//   String provinceName;
//   String cityName;
//   String areaName;
//   String phone;
//   int status;
//   String logo;
//   String description;

//   LeagueStoreGetSupplierVoData(
//       {this.id,
//       this.name,
//       this.address,
//       this.lat,
//       this.lng,
//       this.photo,
//       this.provinceName,
//       this.cityName,
//       this.areaName,
//       this.phone,
//       this.status,
//       this.logo,
//       this.description});

//   LeagueStoreGetSupplierVoData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     address = json['address'];
//     lat = json['lat'];
//     lng = json['lng'];
//     photo = json['photo'];
//     provinceName = json['provinceName'];
//     cityName = json['cityName'];
//     areaName = json['areaName'];
//     phone = json['phone'];
//     status = json['status'];
//     logo = json['logo'];
//     description = json['description'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['address'] = this.address;
//     data['lat'] = this.lat;
//     data['lng'] = this.lng;
//     data['photo'] = this.photo;
//     data['provinceName'] = this.provinceName;
//     data['cityName'] = this.cityName;
//     data['areaName'] = this.areaName;
//     data['phone'] = this.phone;
//     data['status'] = this.status;
//     data['logo'] = this.logo;
//     data['description'] = this.description;
//     return data;
//   }
// }