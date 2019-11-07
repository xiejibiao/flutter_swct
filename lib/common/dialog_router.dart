import 'package:flutter/material.dart';

/// 透明路由
class DialogRouter extends PageRouteBuilder{
  final Widget page;
  DialogRouter(this.page)
    : super(
    opaque: false,
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}