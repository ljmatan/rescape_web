import 'package:rescape_web/logic/api/models/company_model.dart';

abstract class CompaniesData {
  static List<CompanyModel?>? _instance;
  static List<CompanyModel?>? get instance => _instance;

  static void setInstance(List<CompanyModel> value) => _instance = value;
}
