import 'dart:convert';

import 'package:rescape_web/data/products/products.dart';
import 'package:rescape_web/other/measures.dart';
import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/product_model.dart';

abstract class ProductsAPI {
  static Future<List<ProductModel>> getAll() async {
    List<ProductModel> productList = [];

    final decoded = jsonDecode((await HTTPHelper.get('/products')).body);

    if (decoded['error'])
      throw Exception(decoded['message']);
    else
      for (var product in decoded['products'])
        productList.add(
          ProductModel(
            json: product,
            id: product['_id'],
            name: product['name'],
            barcode: product['barcode'].toString(),
            category: product['category'],
            price: product['price'].runtimeType == int
                ? product['price'].toDouble()
                : product['price'],
            internalCode: product['internalCode'],
            vat: product['vat'],
            measure: product['measure'] == 'KG' ? Measure.kg : Measure.qty,
            photo: product['photo'] != null
                ? base64Decode(product['photo'])
                : null,
            inPackage: product['inPackage'],
            discount: product['discount'] != null && product['discount'] != 0
                ? product['discount']
                : null,
          ),
        );

    ProductsData.setInstance(productList);

    return productList;
  }

  static Future<Map> addNew(Map body) async =>
      jsonDecode((await HTTPHelper.post(body, '/products/create')).body);

  static Future<Map> delete(String id) async =>
      jsonDecode((await HTTPHelper.post({'id': id}, '/products/delete')).body);

  static Future<Map> update(Map body) async =>
      jsonDecode((await HTTPHelper.post(body, '/products/update')).body);
}
