import 'package:rescape_web/other/measures.dart';

class OrderedItemModel {
  String name;
  num amount;
  double price;
  Measure measure;
  double? discount;

  OrderedItemModel({
    required this.name,
    required this.amount,
    required this.price,
    required this.discount,
    required this.measure,
  });
}

class OrderModel {
  String id, companyId, status;
  DateTime time;
  double total;
  List<OrderedItemModel> items;
  List<String>? specials;

  OrderModel({
    required this.id,
    required this.companyId,
    required this.status,
    required this.time,
    required this.total,
    required this.items,
    required this.specials,
  });
}
