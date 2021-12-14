import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanit/services/models.dart';

class AddCategoryState with ChangeNotifier {
  String _name = '';
  String _defaultoum = '';

  UOM? _selecteduom;

  Color _selectedcolor = Colors.blue;

  Color get selectedcolor => _selectedcolor;

  set selectedcolor(Color newColor) {
    _selectedcolor = newColor;
    notifyListeners();
  }

  UOM? get selecteduom => _selecteduom;

  set selecteduom(UOM? newuom) {
    _selecteduom = newuom;
    notifyListeners();
  }

  String get name => _name;

  set name(String newName) {
    _name = newName;
    notifyListeners();
  }

  String get defaultoum => _defaultoum;

  set defaultoum(String newDefaultOum) {
    _defaultoum = newDefaultOum;
    notifyListeners();
  }
}
