import 'dart:convert';

import 'package:rescape_web/data/companies/companies.dart';
import 'package:rescape_web/logic/api/companies.dart';
import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/order_model.dart';
import 'package:rescape_web/other/measures.dart';

abstract class OrdersAPI {
  static Future<List<OrderModel>> getAll(String filter) async {
    if (CompaniesData.instance == null) await CompaniesAPI.getAll();

    List<OrderModel> itemsList = [];

    final decoded = jsonDecode((await HTTPHelper.get('/orders/$filter')).body);

    if (!decoded['error']) {
      for (var order in decoded['orders'])
        if (CompaniesData.instance!
            .where((e) => e!.id == order['companyId'])
            .isNotEmpty)
          itemsList.add(
            OrderModel(
              id: order['_id'],
              time: DateTime.parse(order['time']),
              companyId: order['companyId'],
              status: order['status'],
              total: order['total'],
              items: [
                for (var item in order['items'])
                  OrderedItemModel(
                    name: item['name'],
                    amount: item['amount'],
                    price: item['price'],
                    discount: item['discount'],
                    measure: item['measure'] == 'KG' ? Measure.kg : Measure.qty,
                  ),
              ],
              specials: order['specials'] != null
                  ? [for (var special in order['specials']) special]
                  : null,
            ),
          );
    } else
      throw Exception(decoded['message']);

    return itemsList;
  }

  static Future<Map> create(Map body) async =>
      jsonDecode((await HTTPHelper.post(body, '/orders/create')).body);

  static Future<List<OrderModel>> byCustomer(String companyId) async {
    List<OrderModel> orders = [];

    final decodedOrders =
        jsonDecode((await HTTPHelper.get('/orders/customer/$companyId')).body);

    if (decodedOrders['error'])
      throw Exception(decodedOrders['message']);
    else
      for (var order in decodedOrders['orders'])
        orders.add(
          OrderModel(
            id: order['_id'],
            companyId: order['companyId'],
            status: order['status'],
            total: order['total'],
            time: DateTime.parse(order['time']),
            items: [
              for (var item in order['items'])
                OrderedItemModel(
                  name: item['name'],
                  amount: item['amount'],
                  price: item['price'],
                  discount: item['discount'],
                  measure: item['measure'] == 'KG' ? Measure.kg : Measure.qty,
                ),
            ],
            specials: order['specials'] != null
                ? [for (var special in order['specials']) special]
                : null,
          ),
        );

    return orders;
  }

  static Future<Map> delete(String orderId) async => jsonDecode(
      (await HTTPHelper.post({'orderId': orderId}, '/orders/delete')).body);
}
