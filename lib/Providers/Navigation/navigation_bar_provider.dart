import 'package:flutter/material.dart';

class NavigationBarProvider extends ChangeNotifier {
  int pageIndex = 0;
  void naviguer(value) {
    pageIndex = value;
    notifyListeners();
  }
}
