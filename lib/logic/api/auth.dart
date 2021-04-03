import 'dart:convert';

import 'package:rescape_web/data/user/user_data.dart';
import 'package:rescape_web/logic/api/http_helper.dart';

abstract class AuthAPI {
  static Future<bool> login(String username, String password) async {
    bool success = false;

    try {
      final response = await HTTPHelper.post(
        {'username': username, 'password': password},
        '/auth/login',
      );
      final decoded = jsonDecode(response.body);
      await UserData.setInstance(
        username,
        decoded['type'],
        decoded['companyId'],
        decoded['discount'],
        decoded['locations'],
      );
      return decoded['error'] == false;
    } catch (e) {
      print(e.toString());
    }

    return success;
  }
}
