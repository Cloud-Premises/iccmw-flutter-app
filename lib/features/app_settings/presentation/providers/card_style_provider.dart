import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardStyleProvider extends ChangeNotifier {
  bool _cardStyling = false;

  bool get cardStyling => _cardStyling;

  CardStyleProvider() {
    _loadCardStyleFromPreferences();
  }

  void toggleCardStyle(bool newValue) async {
    _cardStyling = newValue;
    notifyListeners();
    await _saveCardStyleToPreferences(newValue);
  }

  Future<void> _loadCardStyleFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cardStyling = prefs.getBool('cardStyling') ?? false;
    notifyListeners();
  }

  Future<void> _saveCardStyleToPreferences(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cardStyling', value);
  }
}
