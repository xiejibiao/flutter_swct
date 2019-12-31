class StarSettingVo {
  String code;
  String message;
  List<StarSetting> data;

  StarSettingVo({this.code, this.message, this.data});

  StarSettingVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<StarSetting>();
      json['data'].forEach((v) {
        data.add(new StarSetting.fromJson(v));
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

class StarSetting {
  int id;
  int starCode;
  String name;
  double sharePersonRate;
  double shareGroupRate;
  double storePersonRate;
  double storeGroupRate;
  double platformRate;

  StarSetting(
      {this.id,
      this.starCode,
      this.name,
      this.sharePersonRate,
      this.shareGroupRate,
      this.storePersonRate,
      this.storeGroupRate,
      this.platformRate});

  StarSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    starCode = json['starCode'];
    name = json['name'];
    sharePersonRate = json['sharePersonRate'];
    shareGroupRate = json['shareGroupRate'];
    storePersonRate = json['storePersonRate'];
    storeGroupRate = json['storeGroupRate'];
    platformRate = json['platformRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['starCode'] = this.starCode;
    data['name'] = this.name;
    data['sharePersonRate'] = this.sharePersonRate;
    data['shareGroupRate'] = this.shareGroupRate;
    data['storePersonRate'] = this.storePersonRate;
    data['storeGroupRate'] = this.storeGroupRate;
    data['platformRate'] = this.platformRate;
    return data;
  }
}