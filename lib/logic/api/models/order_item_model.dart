class OrderItemModel {
  String id, time, company, status;
  List<OrderItemModel> items;

  OrderItemModel({
    required this.id,
    required this.time,
    required this.company,
    required this.status,
    required this.items,
  });
}
