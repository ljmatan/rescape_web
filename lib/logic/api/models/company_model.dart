import 'dart:convert';
import 'dart:typed_data';

import 'package:rescape_web/logic/api/models/discounted_model.dart';
import 'package:rescape_web/logic/api/models/location_model.dart';

class CompanyModel {
  String id, name;
  int pib;
  List<LocationModel?> locations;
  double? discount;
  Uint8List? photo;
  List<DiscountedModel> discounts;

  CompanyModel({
    required this.id,
    required this.name,
    required this.pib,
    required this.locations,
    required this.discounts,
    this.discount,
    this.photo,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> json) => CompanyModel(
        id: json['_id'],
        name: json['name'],
        pib: json['pib'],
        locations: [
          for (var location in json['locations'])
            LocationModel(
              street: location['street'],
              city: location['city'],
              locationNumber: location['locationNumber'],
            ),
        ],
        photo: json['photo'] == null ? null : base64Decode(json['photo']),
        discount: json['discount'],
        discounts: [
          for (var discount in json['discounts'])
            DiscountedModel(
              productId: discount['productId'],
              discount: discount['discount'],
            ),
        ],
      );
}
