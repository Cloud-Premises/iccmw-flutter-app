import 'package:flutter/material.dart';

class TranslationProvider with ChangeNotifier {
  bool _isTranslationEnabled = true; // Default value

  bool get isTranslationEnabled => _isTranslationEnabled;

  // Setter method for _isTranslationEnabled
  set isTranslationEnabled(bool value) {
    _isTranslationEnabled = value;
    notifyListeners();
  }

  // Toggle method (if needed)
  void toggleTranslation(bool value) {
    _isTranslationEnabled = value;
    notifyListeners();
  }
}
