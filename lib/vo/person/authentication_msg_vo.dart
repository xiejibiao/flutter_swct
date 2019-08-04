class AuthenticationMsgVo {
  String code;
  String message;
  AuthenticationMsg data;

  AuthenticationMsgVo({this.code, this.message, this.data});

  AuthenticationMsgVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new AuthenticationMsg.fromJson(json['data']) : null;
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

class AuthenticationMsg {
  String phone;
  String name;
  String idNum;

  AuthenticationMsg({this.phone, this.name, this.idNum});

  AuthenticationMsg.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    name = json['name'];
    idNum = json['idNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['idNum'] = this.idNum;
    return data;
  }
}