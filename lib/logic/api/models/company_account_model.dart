import 'package:rescape_web/logic/api/models/company_model.dart';
import 'package:rescape_web/logic/api/models/location_model.dart';

class CompanyAccountModel {
  String id, username;
  CompanyModel company;
  List<LocationModel?> locations;

  CompanyAccountModel({
    required this.id,
    required this.username,
    required this.company,
    required this.locations,
  });
}
