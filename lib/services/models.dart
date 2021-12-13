import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class UOM {
  String value;

  UOM({this.value = ''});

  factory UOM.fromJson(Map<String, dynamic> json) => _$UOMFromJson(json);
  Map<String, dynamic> toJson() => _$UOMToJson(this);
}

@JsonSerializable()
class Session {
  String barcode;
  String category;
  String name;
  double price;
  double units;
  String uom;

  Session({
    this.barcode = '',
    this.category = '',
    this.name = '',
    this.price = 0.0,
    this.units = 0.0,
    this.uom = '',
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

@JsonSerializable()
class Category {
  String defaultuom;
  String name;

  Category({
    this.defaultuom = '',
    this.name = '',
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

// @JsonSerializable()
// class PriceHistory {
//   double price;
//   String closingdate;

//   PriceHistory({
//     this.price = 0.0,
//     this.closingdate = '',
//   });

//   factory PriceHistory.fromJson(Map<String, dynamic> json) =>
//       _$PriceHistoryFromJson(json);
//   Map<String, dynamic> toJson() => _$PriceHistoryToJson(this);
// }

@JsonSerializable()
class Item {
  String barcode;
  String category;
  String name;
  double price;
  double units;
  String uom;
  //List<PriceHistory> pricehistories;

  Item({
    this.barcode = '',
    this.name = '',
    this.price = 0.0,
    this.units = 0.0,
    this.uom = '',
    this.category = '',
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

// @JsonSerializable()
// class Retailer {
//   String name;
//   Map<String, String> stock;
//   Map<String, List<Item>> storecategories;

//   Retailer({
//     this.name = '',
//     this.stock = const {},
//     this.storecategories = const {},
//   });

//   factory Retailer.fromJson(Map<String, dynamic> json) =>
//       _$RetailerFromJson(json);
//   Map<String, dynamic> toJson() => _$RetailerToJson(this);
// }
