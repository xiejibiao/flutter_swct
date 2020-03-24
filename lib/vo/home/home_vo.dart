class HomePageVo {
  String code;
  String message;
  HomeVo data;

  HomePageVo({this.code, this.message, this.data});

  HomePageVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new HomeVo.fromJson(json['data']) : null;
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

class HomeVo {
  String id;
  String avatar;
  String nikeName;
  double personalCommission;
  double teamCommission;
  int score;
  List<HomeAdType0Vos> homeAdType0Vos;
  List<HomeAdType0Vos> homeAdType1Vos;

  HomeVo(
      {this.id,
      this.avatar,
      this.nikeName,
      this.personalCommission,
      this.teamCommission,
      this.score,
      this.homeAdType0Vos,
      this.homeAdType1Vos});

  HomeVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    nikeName = json['nikeName'];
    personalCommission = json['personalCommission'];
    teamCommission = json['teamCommission'];
    score = json['score'];
    if (json['homeAdType0Vos'] != null) {
      homeAdType0Vos = new List<HomeAdType0Vos>();
      json['homeAdType0Vos'].forEach((v) {
        homeAdType0Vos.add(new HomeAdType0Vos.fromJson(v));
      });
    }
    if (json['homeAdType1Vos'] != null) {
      homeAdType1Vos = new List<HomeAdType0Vos>();
      json['homeAdType1Vos'].forEach((v) {
        homeAdType1Vos.add(new HomeAdType0Vos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['nikeName'] = this.nikeName;
    data['personalCommission'] = this.personalCommission;
    data['teamCommission'] = this.teamCommission;
    data['score'] = this.score;
    if (this.homeAdType0Vos != null) {
      data['homeAdType0Vos'] =
          this.homeAdType0Vos.map((v) => v.toJson()).toList();
    }
    if (this.homeAdType1Vos != null) {
      data['homeAdType1Vos'] =
          this.homeAdType1Vos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeAdType0Vos {
  int id;
  String title;
  String cover;
  int type;
  String content;

  HomeAdType0Vos({this.id, this.title, this.cover, this.type});

  HomeAdType0Vos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cover = json['cover'];
    type = json['type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['content'] = this.type;
    data['type'] = this.content;
    return data;
  }
}