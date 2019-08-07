class LoginVo {
  String code;
  String message;
  LoginVoData data;

  LoginVo({this.code, this.message, this.data});

  LoginVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new LoginVoData.fromJson(json['data']) : null;
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

class LoginVoData {
  String accessToken;
  String refreshToken;
  String scope;
  String tokenType;
  int expiresIn;

  LoginVoData(
      {this.accessToken,
      this.refreshToken,
      this.scope,
      this.tokenType,
      this.expiresIn});

  LoginVoData.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    scope = json['scope'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['scope'] = this.scope;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    return data;
  }
}