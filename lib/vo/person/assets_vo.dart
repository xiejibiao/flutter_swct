class AssetsVo {
  String code;
  String message;
  AssetsDataVo data;

  AssetsVo({this.code, this.message, this.data});

  AssetsVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new AssetsDataVo.fromJson(json['data']) : null;
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

class AssetsDataVo {
  int id;
  String uid;
  double assets;
  double money;
  double commission;
  double finance;
  String password;
  double creditLine;

  AssetsDataVo(
      {this.id,
      this.uid,
      this.assets,
      this.money,
      this.commission,
      this.finance,
      this.password,
      this.creditLine});

  AssetsDataVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    assets = json['assets'];
    money = json['money'];
    commission = json['commission'];
    finance = json['finance'];
    password = json['password'];
    creditLine = json['creditLine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['assets'] = this.assets;
    data['money'] = this.money;
    data['commission'] = this.commission;
    data['finance'] = this.finance;
    data['password'] = this.password;
    data['creditLine'] = this.creditLine;
    return data;
  }
}