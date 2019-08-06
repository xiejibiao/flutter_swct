class StoreIndustryListVo {
  String code;
  String message;
  List<StoreIndustryData> data;

  StoreIndustryListVo({this.code, this.message, this.data});

  StoreIndustryListVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<StoreIndustryData>();
      json['data'].forEach((v) {
        data.add(new StoreIndustryData.fromJson(v));
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

class StoreIndustryData {
  int id;
  int pid;
  String name;

  StoreIndustryData({this.id, this.pid, this.name});

  StoreIndustryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['name'] = this.name;
    return data;
  }
}