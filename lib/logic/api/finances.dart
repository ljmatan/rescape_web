import 'dart:convert';

import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/finance.dart';

abstract class FinancesAPI {
  static Future<List<FinanceModel>> getAll() async {
    List<FinanceModel> finances = [];

    final decoded = jsonDecode((await HTTPHelper.get('/finances')).body);

    if (!decoded['error'])
      for (var finance in decoded['finances'])
        finances.add(
          FinanceModel(
            id: finance['_id'],
            companyId: finance['companyId'],
            time: DateTime.parse(finance['time']),
            amount: finance['amount'],
          ),
        );

    return finances;
  }

  static Future<Map> create(String companyId, double amount) async =>
      jsonDecode((await HTTPHelper.post({
        'companyId': companyId,
        'amount': amount,
        'time': DateTime.now().toIso8601String()
      }, '/finances/new'))
          .body);

  static Future<Map> delete(String id) async => jsonDecode(
      (await HTTPHelper.post({'transactionId': id}, '/finances/delete')).body);
}
