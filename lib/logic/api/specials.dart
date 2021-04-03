import 'dart:convert';

import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/specials_model.dart';

abstract class SpecialsAPI {
  static Future<List<SpecialsModel>> getAll() async {
    late List<SpecialsModel> specials = [];

    final response = await HTTPHelper.get('/specials');

    final decoded = jsonDecode(response.body);

    if (decoded['error']) throw Exception(decoded['message']);

    for (var special in decoded['specials'])
      specials.add(
        SpecialsModel(
          id: special['_id'],
          code: special['code'],
          description: special['description'],
          images: special['images'],
        ),
      );

    return specials;
  }

  static Future<Map> create(
          String code, String description, List<Map> images) async =>
      jsonDecode((await HTTPHelper.post(
              {'code': code, 'description': description, 'images': images},
              '/specials/new'))
          .body);

  static Future<Map> delete(String id) async => jsonDecode(
      (await HTTPHelper.post({'specialsId': id}, '/specials/delete')).body);
}
