import 'package:rescape_web/data/cart/cart_item_model.dart';
import 'package:rescape_web/ui/pages/customer/cart/bloc/cart_controller.dart';

abstract class CartItems {
  static List<String> _specials = [];
  static List<String> get specials => _specials;

  static List<CartItemModel> _instance = [];
  static List<CartItemModel> get instance => _instance;

  static void addToOrder(CartItemModel item) {
    if (_instance.where((e) => e.id == item.id).isNotEmpty)
      _instance.removeWhere((e) => e.id == item.id);
    _instance.add(item);
    CartItemsNumberController.change(_instance.length);
  }

  static void removeFromOrder(String productID) {
    _instance.removeWhere((item) => item.id == productID);
    CartItemsNumberController.change(_instance.length);
  }

  static void clearAll() {
    _instance.clear();
    CartItemsNumberController.change(0);
  }

  static void addSpecial(String special) => _specials.add(special);

  static void removeSpecial(String special) => _specials.remove(special);
}
