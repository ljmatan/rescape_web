import 'package:rescape_web/logic/api/models/product_model.dart';

abstract class ProductsData {
  static List<ProductModel>? _instance;
  static List<ProductModel>? get instance => _instance;

  static void setInstance(List<ProductModel> value) => _instance = value;
}
