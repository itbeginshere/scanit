import 'package:flutter/cupertino.dart';
import 'package:scanit/services/models.dart';

class AddCategoryState with ChangeNotifier {
  String _name = '';
  String _defaultoum = '';

  UOM? _selecteduom;

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
