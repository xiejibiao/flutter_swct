class PersonInfoVo {
  String code;
  String message;
  PersonInfo data;

  PersonInfoVo({this.code, this.message, this.data});

  PersonInfoVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new PersonInfo.fromJson(json['data']) : null;
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

class PersonInfo {
  String id;
  String avatar;
  String nikeName;
  String email;
  bool authentication;

  PersonInfo({this.id, this.avatar, this.nikeName, this.email, this.authentication});

  PersonInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    nikeName = json['nikeName'];
    email = json['email'];
    authentication = json['authentication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['nikeName'] = this.nikeName;
    data['email'] = this.email;
    data['authentication'] = this.authentication;
    return data;
  }
}