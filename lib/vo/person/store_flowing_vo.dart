class StoreFlowingVo {
  String code;
  String message;
  StoreFlowingData data;

  StoreFlowingVo({this.code, this.message, this.data});

  StoreFlowingVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new StoreFlowingData.fromJson(json['data']) : null;
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

class StoreFlowingData {
  List<StoreFlowingItem> list;
  int totalPage;
  int pageSize;
  int pageNumber;
  int count;

  StoreFlowingData({this.list, this.totalPage, this.pageSize, this.pageNumber, this.count});

  StoreFlowingData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<StoreFlowingItem>();
      json['list'].forEach((v) {
        list.add(new StoreFlowingItem.fromJson(v));
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

class StoreFlowingItem {
  int id;
  String uid;
  String orderId;
  String payNo;
  double money;
  String typeCode;
  int result;
  String payeeId;
  double payeeMoney;
  int createTime;
  int type;
  double personalCommission;
  double teamCommission;
  double totalCommission;
  double supplierMoney;

  StoreFlowingItem(
      {this.id,
      this.uid,
      this.orderId,
      this.payNo,
      this.money,
      this.typeCode,
      this.result,
      this.payeeId,
      this.payeeMoney,
      this.createTime,
      this.type,
      this.personalCommission,
      this.teamCommission,
      this.totalCommission,
      this.supplierMoney});

  StoreFlowingItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    orderId = json['orderId'];
    payNo = json['payNo'];
    money = json['money'];
    typeCode = json['typeCode'];
    result = json['result'];
    payeeId = json['payeeId'];
    payeeMoney = json['payeeMoney'];
    createTime = json['createTime'];
    type = json['type'];
    personalCommission = json['personalCommission'];
    teamCommission = json['teamCommission'];
    totalCommission = json['totalCommission'];
    supplierMoney = json['supplierMoney'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['orderId'] = this.orderId;
    data['payNo'] = this.payNo;
    data['money'] = this.money;
    data['typeCode'] = this.typeCode;
    data['result'] = this.result;
    data['payeeId'] = this.payeeId;
    data['payeeMoney'] = this.payeeMoney;
    data['createTime'] = this.createTime;
    data['type'] = this.type;
    data['personalCommission'] = this.personalCommission;
    data['teamCommission'] = this.teamCommission;
    data['totalCommission'] = this.totalCommission;
    data['supplierMoney'] = this.supplierMoney;
    return data;
  }
}