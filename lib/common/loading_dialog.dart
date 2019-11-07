import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// 加载中loading
class LoadingDialog extends Dialog {
  /// 提示文字
  final String message;
  LoadingDialog({
    @required this.message
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        ///背景透明
        color: Colors.transparent,
        ///保证控件居中效果
        child: Center(
          ///弹框大小
          child: SizedBox(
            width: ScreenUtil().setWidth(180),
            height: ScreenUtil().setWidth(180),
            child: Container(
              ///弹框背景和圆角
              decoration: ShapeDecoration(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SpinKitCircle(color: Colors.blue),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
