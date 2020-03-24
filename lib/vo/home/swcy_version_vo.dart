class SwcyVersionVo {
  String code;
  String message;
  SwcyVersionData data;

  SwcyVersionVo({this.code, this.message, this.data});

  SwcyVersionVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new SwcyVersionData.fromJson(json['data']) : null;
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

class SwcyVersionData {
  String isMandatoryUpdate;
  String version;
  String updateMsg;

  SwcyVersionData({this.isMandatoryUpdate, this.version, this.updateMsg});

  SwcyVersionData.fromJson(Map<String, dynamic> json) {
    isMandatoryUpdate = json['isMandatoryUpdate'];
    version = json['version'];
    updateMsg = json['updateMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isMandatoryUpdate'] = this.isMandatoryUpdate;
    data['version'] = this.version;
    data['updateMsg'] = this.updateMsg;
    return data;
  }
}