class PersonVo {
  String code;
  String message;
  PersonPageVo data;

  PersonVo({this.code, this.message, this.data});

  PersonVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new PersonPageVo.fromJson(json['data']) : null;
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

class PersonPageVo {
  LgmnUserInfo lgmnUserInfo;
  List<HomeAdVo> homeAdVo;
  int star;
  int credit;

  PersonPageVo({this.lgmnUserInfo, this.homeAdVo, this.star, this.credit});

  PersonPageVo.fromJson(Map<String, dynamic> json) {
    lgmnUserInfo = json['lgmnUserInfo'] != null
        ? new LgmnUserInfo.fromJson(json['lgmnUserInfo'])
        : null;
    if (json['homeAdVo'] != null) {
      homeAdVo = new List<HomeAdVo>();
      json['homeAdVo'].forEach((v) {
        homeAdVo.add(new HomeAdVo.fromJson(v));
      });
    }
    star = json['star'];
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lgmnUserInfo != null) {
      data['lgmnUserInfo'] = this.lgmnUserInfo.toJson();
    }
    if (this.homeAdVo != null) {
      data['homeAdVo'] = this.homeAdVo.map((v) => v.toJson()).toList();
    }
    data['star'] = this.star;
    data['credit'] = this.credit;
    return data;
  }
}

class LgmnUserInfo {
  String id;
  String avatar;
  String account;
  String nikeName;
  int userType;

  LgmnUserInfo(
      {this.id, this.avatar, this.account, this.nikeName, this.userType});

  LgmnUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    account = json['account'];
    nikeName = json['nikeName'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['account'] = this.account;
    data['nikeName'] = this.nikeName;
    data['userType'] = this.userType;
    return data;
  }
}

class HomeAdVo {
  int id;
  String title;
  String cover;
  int type;

  HomeAdVo({this.id, this.title, this.cover, this.type});

  HomeAdVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cover = json['cover'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['type'] = this.type;
    return data;
  }
}