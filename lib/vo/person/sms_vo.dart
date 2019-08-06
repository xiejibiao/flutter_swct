class SmsVo {
  String code;
  String message;
  SmsData data;

  SmsVo({this.code, this.message, this.data});

  SmsVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new SmsData.fromJson(json['data']) : null;
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

class SmsData {
  List<Sms> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  SmsData({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  SmsData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<Sms>();
      json['list'].forEach((v) {
        list.add(new Sms.fromJson(v));
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

class Sms {
  int id;
  String title;
  String content;
  int readingVolume;
  int createTime;
  int hadRead;

  Sms(
      {this.id,
      this.title,
      this.content,
      this.readingVolume,
      this.createTime,
      this.hadRead});

  Sms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    readingVolume = json['readingVolume'];
    createTime = json['createTime'];
    hadRead = json['hadRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['readingVolume'] = this.readingVolume;
    data['createTime'] = this.createTime;
    data['hadRead'] = this.hadRead;
    return data;
  }
}