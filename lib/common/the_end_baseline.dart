import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheEndBaseline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildBaselineContainer(),
          Text(
            '已全部加载', 
            style: TextStyle(
              color: Color(0xFF999999), 
              fontSize: ScreenUtil().setSp(20)
            )
          ),
          _buildBaselineContainer()
        ],
      ),
    );
  }

  Container _buildBaselineContainer () {
    return Container(
      width: ScreenUtil().setWidth(200),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF999999)
        )
      ),
    );
  }
}