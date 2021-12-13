import 'package:flutter/cupertino.dart';
import 'package:scanit/services/models.dart';

class ItemState with ChangeNotifier {
  String barcode = '';
  String category = '';
  String name = '';
  double price = 0.0;
  double units = 0.0;
  String uom = '';
  Category? selectedcategory;
  UOM? selecteduom;

  ItemState(
      {required this.barcode,
      required this.category,
      required this.name,
      required this.price,
      required this.units,
      required this.uom});

  Category? get st_selectedcategory => selectedcategory;
  UOM? get st_selecteduom => selecteduom;

  set st_selectedcategory(Category? newcategory) {
    selectedcategory = newcategory;
    notifyListeners();
  }

  set st_selecteduom(UOM? newuom) {
    selecteduom = newuom;
    notifyListeners();
  }

  String get st_name => name;

  set st_name(String newName) {
    name = newName;
    notifyListeners();
  }

  String get st_barcode => barcode;

  set st_barcode(String newBarCode) {
    barcode = newBarCode;
    notifyListeners();
  }

  String get st_category => category;

  set st_category(String newCategory) {
    category = newCategory;
    notifyListeners();
  }

  String get st_uom => uom;

  set st_uom(String newUOM) {
    uom = newUOM;
    notifyListeners();
  }

  double get st_price => price;

  set st_price(double newPrice) {
    price = newPrice;
    notifyListeners();
  }

  double get st_units => units;

  set st_units(double newUnits) {
    units = newUnits;
    notifyListeners();
  }
}
