class UnifiedOrderVo {
  String code;
  String message;
  UnifiedOrderData data;

  UnifiedOrderVo({this.code, this.message, this.data});

  UnifiedOrderVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new UnifiedOrderData.fromJson(json['data']) : null;
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

class UnifiedOrderData {
  String returnCode;
  String returnMsg;
  String appid;
  String mchId;
  String nonceStr;
  String sign;
  String resultCode;
  String prepayId;
  String tradeType;

  UnifiedOrderData(
      {this.returnCode,
      this.returnMsg,
      this.appid,
      this.mchId,
      this.nonceStr,
      this.sign,
      this.resultCode,
      this.prepayId,
      this.tradeType});

  UnifiedOrderData.fromJson(Map<String, dynamic> json) {
    returnCode = json['return_code'];
    returnMsg = json['return_msg'];
    appid = json['appid'];
    mchId = json['mch_id'];
    nonceStr = json['nonce_str'];
    sign = json['sign'];
    resultCode = json['result_code'];
    prepayId = json['prepay_id'];
    tradeType = json['trade_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['return_code'] = this.returnCode;
    data['return_msg'] = this.returnMsg;
    data['appid'] = this.appid;
    data['mch_id'] = this.mchId;
    data['nonce_str'] = this.nonceStr;
    data['sign'] = this.sign;
    data['result_code'] = this.resultCode;
    data['prepay_id'] = this.prepayId;
    data['trade_type'] = this.tradeType;
    return data;
  }
}