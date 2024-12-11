import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerCardVisibilityProvider extends ChangeNotifier {
  bool _isCardVisible = true;

  bool get isCardVisible => _isCardVisible;

  PrayerCardVisibilityProvider() {
    _loadVisibilityFromCache(); // Load visibility status from cache when the provider is initialized
  }

  // Toggle the visibility and update the cache
  void toggleCardVisibility() async {
    _isCardVisible = !_isCardVisible;
    notifyListeners(); // Notify listeners to rebuild UI
    await _saveVisibilityToCache(_isCardVisible); // Save updated value to cache
  }

  // Set visibility and update the cache
  void setCardVisibility(bool visibility) async {
    _isCardVisible = visibility;
    notifyListeners();
    await _saveVisibilityToCache(visibility); // Save value to cache
  }

  // Load visibility state from SharedPreferences (cache)
  Future<void> _loadVisibilityFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    _isCardVisible = prefs.getBool('isCardVisible') ?? true;
    notifyListeners(); // Notify listeners to rebuild UI after loading from cache
  }

  // Save the visibility state to SharedPreferences (cache)
  Future<void> _saveVisibilityToCache(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCardVisible', value);
  }
}
