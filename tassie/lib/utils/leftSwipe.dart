import 'package:flutter/material.dart';

class LeftSwipe extends ChangeNotifier {
  
  bool _isSwipe = true;
  
  bool get isSwipe => _isSwipe;
  
  void setSwipe(bool value) {
    _isSwipe = value;
    notifyListeners();
  }
}