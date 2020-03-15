class CommodityInfoVo {
  int id;
  String name;
  int count;
  double price;
  String cover;
  bool isCheck;
  int delFlag;
  String specs;

  CommodityInfoVo({this.id, this.name, this.count, this.price, this.cover, this.isCheck});

  CommodityInfoVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
    price = json['price'];
    cover = json['cover'];
    isCheck = json['isCheck'];
    delFlag = json['delFlag'];
    specs = json['specs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['count'] = this.count;
    data['price'] = this.price;
    data['cover'] = this.cover;
    data['isCheck'] = this.isCheck;
    data['delFlag'] = this.delFlag;
    data['specs'] = this.specs;
    return data;
  }

  static List<CommodityInfoVo> fromJsonList(dynamic maps) {
    List<CommodityInfoVo> list = List(maps.length);
    for (int i = 0; i < maps.length; i++) {
      list[i] = CommodityInfoVo.fromJson(maps[i]);
    }
    return list;
  }
}