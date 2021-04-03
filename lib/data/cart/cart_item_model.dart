import 'package:rescape_web/other/measures.dart';

class CartItemModel {
  String id, name;
  num amount, vat;
  double price;
  Measure measure;
  double? discount;

  CartItemModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.price,
    required this.vat,
    required this.measure,
    this.discount,
  });
}
