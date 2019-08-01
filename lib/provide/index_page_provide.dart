import 'package:flutter/material.dart';

class IndexPageProvide with ChangeNotifier {
  int currentIndex = 0;

  // 改变bottom导航下标
  bottomNavigationBarIndex (int index) {
    currentIndex = index;
    notifyListeners();
  }
}