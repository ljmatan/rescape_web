import 'dart:async';

abstract class CartItemsNumberController {
  static int _initial = 0;
  static int get initial => _initial;

  static late StreamController _streamController;
  static StreamController? get streamController => _streamController;

  static void init() => _streamController = StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void change(value) {
    if (!_streamController.isClosed) {
      _streamController.add(value);
      _initial = value;
    }
  }

  static void dispose() => _streamController.close();
}
