// settings_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettingProvider extends ChangeNotifier {
  bool _surahTitle = true;
  bool _juzTitle = true;

  bool get surahTitle => _surahTitle;
  bool get juzTitle => _juzTitle;

  GeneralSettingProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _surahTitle = prefs.getBool('surahTitle') ?? true;
    _juzTitle = prefs.getBool('juzTitle') ?? true;
    notifyListeners();
  }

  Future<void> toggleSurahTitle(bool value) async {
    _surahTitle = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('surahTitle', _surahTitle);
    notifyListeners();
  }

  Future<void> toggleJuzTitle(bool value) async {
    _juzTitle = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('juzTitle', _juzTitle);
    notifyListeners();
  }
}