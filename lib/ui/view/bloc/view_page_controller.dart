import 'dart:async';

abstract class ViewPageController {
  static int? _currentIndex;
  static int? get currentIndex => _currentIndex;
  static void setCurrentIndex(int value) => _currentIndex = value;

  static late StreamController _streamController;

  static void init() => _streamController = StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void change(value) => _streamController.add(value);

  static void dispose() => _streamController.close();
}
