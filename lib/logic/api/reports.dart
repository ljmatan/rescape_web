import 'dart:convert';

import 'package:rescape_web/logic/api/http_helper.dart';

abstract class ReportsAPI {
  static Future<Map> getById(String orderId) async =>
      jsonDecode((await HTTPHelper.get('/reports/single/$orderId')).body);

  static Future<Map> upload(
    String encodedFile,
    String orderId,
    String companyId,
  ) async =>
      jsonDecode((await HTTPHelper.post(
              {'file': encodedFile, 'orderId': orderId, 'companyId': companyId},
              '/reports/new'))
          .body);

  static Future<Map> delete(String fileId) async => jsonDecode(
      (await HTTPHelper.post({'fileId': fileId}, '/reports/new')).body);
}
