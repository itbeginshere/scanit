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
  double priceperoum;
  String color;

  Session({
    this.barcode = '',
    this.category = '',
    this.name = '',
    this.price = 0.0,
    this.units = 0.0,
    this.uom = '',
    this.priceperoum = 0.0,
    this.color = '#FFFFFF',
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

@JsonSerializable()
class Category {
  String defaultuom;
  String name;
  String color;

  Category({
    this.defaultuom = '',
    this.name = '',
    this.color = '#FFFFFF',
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Item {
  String barcode;
  String category;
  String name;
  double price;
  double units;
  String uom;

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
