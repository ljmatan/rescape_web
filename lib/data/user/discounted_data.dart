import 'package:rescape_web/logic/api/models/discounted_model.dart';

abstract class DiscountedData {
  static List<DiscountedModel>? _instance;
  static List<DiscountedModel>? get instance => _instance;

  static void setInstance(List<DiscountedModel> value) => _instance = value;
}
