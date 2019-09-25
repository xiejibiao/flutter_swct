import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/common/custom_image_delegate.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

Delta getDelta(content) {
  Delta delta = Delta.fromJson(content as List);
  return delta;
}

/// details参数是未decode 的原数据，detailsList 是已经半解析的数据，两个参数传递一个即可
List<Widget> getDetailWidgets({String details, List<dynamic> detailsList}) {
  List<dynamic> _items = TextUtil.isEmpty(details) ? detailsList : json.decode(details);
  List<Widget> _detailWidgets = [];
  _items.forEach((item) {
    if (item['type'] == 'text') {
      var zefyrViewWidget = ZefyrView(
                    document: NotusDocument.fromDelta(getDelta(item['content'])),
                    imageDelegate: new CustomImageDelegate(),
                  );
      _detailWidgets.add(zefyrViewWidget);
    } else {
      item['content'].forEach((temp) {
        var widget = Image.network(temp);
        _detailWidgets.add(widget);
      });
    }
  });
  return _detailWidgets;
}

Widget getZefyrView(content) {
  return ZefyrView(
    document: NotusDocument.fromDelta(getDelta(content)),
    imageDelegate: new CustomImageDelegate(),
  );
}

List<Widget> buildCommodityImageList(dynamic item) {
  List<Widget> widgets = [];
  item.forEach((temp) {
    var widget = Image.network(temp, width: ScreenUtil().setWidth(230), height: ScreenUtil().setWidth(230), fit: BoxFit.fill);
    widgets.add(widget);
  });
  return widgets;
}

