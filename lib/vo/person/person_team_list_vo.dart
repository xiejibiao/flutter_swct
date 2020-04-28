class PersonTeamListVo {
  String code;
  String message;
  PersonTeamData data;

  PersonTeamListVo({this.code, this.message, this.data});

  PersonTeamListVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new PersonTeamData.fromJson(json['data']) : null;
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

class PersonTeamData {
  List<PersonTeamList> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  PersonTeamData({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  PersonTeamData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<PersonTeamList>();
      json['list'].forEach((v) {
        list.add(new PersonTeamList.fromJson(v));
      });
    }
    totalPage = json['totalPage'];
    pageSize = json['pageSize'];
    pageNumber = json['pageNumber'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['totalPage'] = this.totalPage;
    data['pageSize'] = this.pageSize;
    data['pageNumber'] = this.pageNumber;
    data['count'] = this.count;
    return data;
  }
}

class PersonTeamList {
  String uid;
  String avatar;
  String nikeName;
  String phone;
  double personPower;
  double consumptionAmount;

  PersonTeamList({this.uid, this.avatar, this.nikeName, this.phone, this.personPower, this.consumptionAmount});

  PersonTeamList.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    avatar = json['avatar'];
    nikeName = json['nikeName'];
    phone = json['phone'];
    personPower = json['personPower'];
    consumptionAmount = json['consumptionAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['avatar'] = this.avatar;
    data['nikeName'] = this.nikeName;
    data['phone'] = this.phone;
    data['personPower'] = this.personPower;
    data['consumptionAmount'] = this.consumptionAmount;
    return data;
  }
}