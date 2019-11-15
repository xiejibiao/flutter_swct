import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageDialog extends Dialog {
  /// 中间展示部分
  final Widget widget;
  /// 标题
  final String title;
  /// 左侧按钮文字
  final String negativeText;
  /// 右侧按钮文字
  final String positiveText;
  /// 左侧按钮函数
  final Function onCloseEvent;
  /// 右上角关闭函数（此函数不未null 时，右上角会展示关闭Icon）
  final Function onIconCloseEvent;
  /// 右侧按钮函数
  final Function onPositivePressEvent;

  MessageDialog({
    Key key,
    @required this.widget,
    this.negativeText,
    this.positiveText,
    this.onPositivePressEvent,
    this.title,
    this.onIconCloseEvent,
    @required this.onCloseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(45.0),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        Center(
                          child: TextUtil.isEmpty(title) ? 
                                  Container() :
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(32)
                                    ),
                                  ),
                        ),
                        onIconCloseEvent == null ? 
                          Container() :
                          GestureDetector(
                            onTap: this.onIconCloseEvent,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.close,
                                color: Color(0xffe0e0e0),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  TextUtil.isEmpty(title) ? 
                    Container() :
                    Container(
                      color: Color(0xffe0e0e0),
                      height: 1.0,
                    ),
                  Container(
                    constraints: BoxConstraints(minHeight: 110.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.4,
                          color: Colors.black12
                        )
                      )
                    ),
                    child: IntrinsicHeight(
                      child: widget,
                    ),
                  ),
                  this._buildBottomButtonGroup(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText.isNotEmpty) widgets.add(_buildBottomCancelButton());
    if (positiveText != null && positiveText.isNotEmpty) widgets.add(_buildBottomPositiveButton());
    return Container(
      height: ScreenUtil().setHeight(70),
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widgets
      ),
    );
  }

  Widget _buildBottomCancelButton() {
    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))
        ),
        child: FlatButton(
          splashColor: Colors.white,
          highlightColor: Colors.white,
          onPressed: onCloseEvent,
          child: Text(
            negativeText,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPositiveButton() {
    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))
        ),
        child: FlatButton(
          onPressed: onPositivePressEvent,
          splashColor: Colors.red,
          highlightColor: Colors.red,
          child: Text(
            positiveText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}