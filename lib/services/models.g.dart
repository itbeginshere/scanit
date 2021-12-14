// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UOM _$UOMFromJson(Map<String, dynamic> json) => UOM(
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$UOMToJson(UOM instance) => <String, dynamic>{
      'value': instance.value,
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      barcode: json['barcode'] as String? ?? '',
      category: json['category'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      units: (json['units'] as num?)?.toDouble() ?? 0.0,
      uom: json['uom'] as String? ?? '',
      priceperoum: (json['priceperoum'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String? ?? '#FFFFFF',
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'barcode': instance.barcode,
      'category': instance.category,
      'name': instance.name,
      'price': instance.price,
      'units': instance.units,
      'uom': instance.uom,
      'priceperoum': instance.priceperoum,
      'color': instance.color,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      defaultuom: json['defaultuom'] as String? ?? '',
      name: json['name'] as String? ?? '',
      color: json['color'] as String? ?? '#FFFFFF',
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'defaultuom': instance.defaultuom,
      'name': instance.name,
      'color': instance.color,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      barcode: json['barcode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      units: (json['units'] as num?)?.toDouble() ?? 0.0,
      uom: json['uom'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'barcode': instance.barcode,
      'category': instance.category,
      'name': instance.name,
      'price': instance.price,
      'units': instance.units,
      'uom': instance.uom,
    };
