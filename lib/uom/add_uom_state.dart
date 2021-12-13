import 'package:flutter/material.dart';

class AddUOMState with ChangeNotifier {
  String _value = '';

  String get value => _value;

  set value(String newValue) {
    _value = newValue;
    notifyListeners();
  }
}
