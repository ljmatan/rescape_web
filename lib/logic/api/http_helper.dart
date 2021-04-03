import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class HTTPHelper {
  static const String _url = 'http://164.90.170.45:3000/api';
  //  'http://localhost:3000/api';

  static Future<http.Response> get([String endpoint = '']) async =>
      await http.get(Uri.parse(_url + endpoint));

  static Future<http.Response> post(Map body, String endpoint) async =>
      await http
          .post(Uri.parse(_url + endpoint), body: jsonEncode(body), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      });
}
