import 'dart:async';

abstract class PopupController {
  static late StreamController _streamController;

  static void init() => _streamController = StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void show(value) => _streamController.add(value);

  static void hide() => _streamController.add(null);

  static void dispose() => _streamController.close();
}
