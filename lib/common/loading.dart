import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

showLoading () {
  return Center(
    child: SpinKitThreeBounce(color: Colors.blue),
  );
}