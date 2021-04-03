import 'dart:convert';

import 'package:rescape_web/data/companies/companies.dart';
import 'package:rescape_web/logic/api/http_helper.dart';
import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/logic/api/models/discounted_model.dart';
import 'package:rescape_web/logic/api/models/location_model.dart';

abstract class CompaniesAPI {
  static Future<List<CompanyModel>> getAll() async {
    List<CompanyModel> companies = [];

    final decoded = jsonDecode((await HTTPHelper.get('/companies')).body);

    if (!decoded['error'])
      for (var company in decoded['companies'])
        companies.add(
          CompanyModel(
            id: company['_id'],
            name: company['name'],
            pib: company['pib'],
            locations: [
              for (var location in company['locations'])
                LocationModel(
                  street: location['street'],
                  city: location['city'],
                  locationNumber: location['locationNumber'],
                ),
            ],
            discount: company['discount'],
            discounts: [
              for (var discount in company['discounts'])
                DiscountedModel(
                  productId: discount['productId'],
                  discount: discount['discount'],
                ),
            ],
            photo: company['photo'] != null
                ? base64Decode(company['photo'])
                : null,
          ),
        );

    companies
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    CompaniesData.setInstance(companies);

    return companies;
  }

  static Future<Map> addNew(Map body) async =>
      jsonDecode((await HTTPHelper.post(body, '/companies/create')).body);

  static Future<Map> delete(String id) async => jsonDecode(
      (await HTTPHelper.post({'companyId': id}, '/companies/delete')).body);

  static Future<Map> updateDiscount(String id, double discount) async =>
      jsonDecode((await HTTPHelper.post(
              {'id': id, 'discount': discount}, '/companies/update'))
          .body);

  static Future<Map> updatePhoto(String id, String photo) async => jsonDecode(
      (await HTTPHelper.post({'id': id, 'photo': photo}, '/companies/update'))
          .body);

  static Future<Map> addLocation(String companyId, Map body) async =>
      jsonDecode(
          (await HTTPHelper.post(body, '/companies/$companyId/locations/add'))
              .body);

  static Future<Map> deleteLocation(
          String companyId, int locationNumber) async =>
      jsonDecode((await HTTPHelper.post({'locationNumber': locationNumber},
              '/companies/$companyId/locations/delete'))
          .body);

  static Future<Map> addAccount(Map body) async =>
      jsonDecode((await HTTPHelper.post(body, '/auth/register')).body);

  static Future<Map> removeAccount(String userId) async => jsonDecode(
      (await HTTPHelper.post({'userId': userId}, '/auth/users/remove')).body);

  static Future<Map> getAccounts(String companyId) async =>
      jsonDecode((await HTTPHelper.get('/users/$companyId')).body);

  static Future<Map> addAccountLocation(
          String accountId, int locationNumber) async =>
      jsonDecode((await HTTPHelper.post({'locationNumber': locationNumber},
              '/users/$accountId/locations/add'))
          .body);

  static Future<Map> removeAccountLocation(
          String accountId, int locationNumber) async =>
      jsonDecode((await HTTPHelper.post({'locationNumber': locationNumber},
              '/users/$accountId/locations/remove'))
          .body);

  static Future<Map> getDiscounts(String companyId) async => jsonDecode(
      (await HTTPHelper.get('/companies/$companyId/discounts')).body);

  static Future<Map> getDiscount(String companyId) async =>
      jsonDecode((await HTTPHelper.get('/companies/$companyId/discount')).body);
}
