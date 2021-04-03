import 'dart:convert';
import 'dart:typed_data';

import 'package:rescape_web/other/measures.dart';

class ProductModel {
  Map<String, dynamic> json;
  String id, name, barcode, category, internalCode;
  double price;
  int vat;
  Measure measure;
  num? inPackage;
  double? discount;
  Uint8List? photo;

  ProductModel({
    required this.json,
    required this.id,
    required this.name,
    required this.barcode,
    required this.category,
    required this.price,
    required this.internalCode,
    required this.vat,
    required this.measure,
    required this.inPackage,
    this.discount,
    this.photo,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        json: json,
        id: json['_id'],
        internalCode: json['internalCode'],
        name: json['name'],
        barcode: json['barcode'].toString(),
        category: json['category'],
        price: json['price'],
        vat: json['vat'],
        measure: json['measure'] == 'KG' ? Measure.kg : Measure.qty,
        inPackage:
            json['inPackage'] != null ? json['inPackage'].toDouble() : null,
        photo: json['photo'] == null ? null : base64Decode(json['photo']),
        discount: json['discount'],
      );
}
