import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class GameProvider extends ChangeNotifier {
  final Random _random = Random();
  late int fruitIndex;

  void getRandomIndex(int totalSquares) {
    fruitIndex = _random.nextInt(totalSquares);
    notifyListeners();
  }
}