import 'package:flutter/material.dart';

class TransliterationProvider with ChangeNotifier {
  bool _isTransliterationEnabled = true; // Default value

  bool get isTransliterationEnabled => _isTransliterationEnabled;

  set isTransliterationEnabled(bool value) {
    _isTransliterationEnabled = value;
    notifyListeners();
  }

  void toggleTransliteration(bool value) {
    _isTransliterationEnabled = value;
    notifyListeners();
  }
}
