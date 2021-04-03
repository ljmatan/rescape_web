import 'dart:convert';

import 'package:rescape_web/logic/api/http_helper.dart';

abstract class ItemDiscountsAPI {
  static Future<Map> editDiscount(
          String companyId, String productId, double discount) async =>
      jsonDecode((await HTTPHelper.post(
              {'productId': productId, 'discount': discount},
              '/companies/$companyId/discounts/edit'))
          .body);
}
