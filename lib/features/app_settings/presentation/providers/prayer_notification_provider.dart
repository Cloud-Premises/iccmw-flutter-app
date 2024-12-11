// import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
// import 'package:iccmw/features/app_settings/utils/notification_service.dart';
// import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerNotificationProvider extends ChangeNotifier {
  // Get Dates
  final now = DateTime.now();
  final formatter = DateFormat('EEEE d MMMM yyyy');
  final formatterDay = DateFormat('d');
  final formatterMonth = DateFormat('MMMM');

  late String nowDay = formatterDay.format(now);
  late Map<String, dynamic> prayersData = {};
  String? fajrStartTime;
  String? dhuhrStartTime;
  String? asrStartTime;
  String? maghribStartTime;
  String? ishaStartTime;

  String? fajrEndTime;
  String? dhuhrEndTime;
  String? asrEndTime;
  String? maghribEndTime;
  String? ishaEndTime;

  // Initial states for each prayer's start and end notifications
  bool _fajrStart = true;
  bool _fajrEnd = true;
  bool _dhuhrStart = true;
  bool _dhuhrEnd = true;
  bool _asrStart = true;
  bool _asrEnd = true;
  bool _maghribStart = true;
  bool _maghribEnd = true;
  bool _ishaStart = true;
  bool _ishaEnd = true;

  // States for group switches
  bool _allPrayersStart = true;
  bool _allPrayersEnd = true;

  PrayerNotificationProvider() {
    _loadFromCache();
    // setPrayer();
  }

  // Getter methods
  bool get fajrStart => _fajrStart;
  bool get fajrEnd => _fajrEnd;
  bool get dhuhrStart => _dhuhrStart;
  bool get dhuhrEnd => _dhuhrEnd;
  bool get asrStart => _asrStart;
  bool get asrEnd => _asrEnd;
  bool get maghribStart => _maghribStart;
  bool get maghribEnd => _maghribEnd;
  bool get ishaStart => _ishaStart;
  bool get ishaEnd => _ishaEnd;

  bool get allPrayersStart => _allPrayersStart;
  bool get allPrayersEnd => _allPrayersEnd;

  // Toggle methods with cache storage
  void toggleFajrStart(bool value) {
    _fajrStart = value;
    _saveToCache('fajrStart', value);
    notifyListeners();
  }

  void toggleFajrEnd(bool value) {
    _fajrEnd = value;
    _saveToCache('fajrEnd', value);
    notifyListeners();
  }

  void toggleDhuhrStart(bool value) {
    _dhuhrStart = value;
    _saveToCache('dhuhrStart', value);
    notifyListeners();
  }

  void toggleDhuhrEnd(bool value) {
    _dhuhrEnd = value;
    _saveToCache('dhuhrEnd', value);
    notifyListeners();
  }

  void toggleAsrStart(bool value) {
    _asrStart = value;
    _saveToCache('asrStart', value);
    notifyListeners();
  }

  void toggleAsrEnd(bool value) {
    _asrEnd = value;
    _saveToCache('asrEnd', value);
    notifyListeners();
  }

  void toggleMaghribStart(bool value) {
    _maghribStart = value;
    _saveToCache('maghribStart', value);
    notifyListeners();
  }

  void toggleMaghribEnd(bool value) {
    _maghribEnd = value;
    _saveToCache('maghribEnd', value);
    notifyListeners();
  }

  void toggleIshaStart(bool value) {
    _ishaStart = value;
    _saveToCache('ishaStart', value);
    notifyListeners();
  }

  void toggleIshaEnd(bool value) {
    _ishaEnd = value;
    _saveToCache('ishaEnd', value);
    notifyListeners();
  }

  // Group toggle methods
  void toggleAllPrayersStart(bool value) {
    _allPrayersStart = value;
    _fajrStart = value;
    _dhuhrStart = value;
    _asrStart = value;
    _maghribStart = value;
    _ishaStart = value;

    _saveToCache('allPrayersStart', value);
    _saveToCache('fajrStart', value);
    _saveToCache('dhuhrStart', value);
    _saveToCache('asrStart', value);
    _saveToCache('maghribStart', value);
    _saveToCache('ishaStart', value);

    notifyListeners();
  }

  void toggleAllPrayersEnd(bool value) {
    _allPrayersEnd = value;
    _fajrEnd = value;
    _dhuhrEnd = value;
    _asrEnd = value;
    _maghribEnd = value;
    _ishaEnd = value;

    _saveToCache('allPrayersEnd', value);
    _saveToCache('fajrEnd', value);
    _saveToCache('dhuhrEnd', value);
    _saveToCache('asrEnd', value);
    _saveToCache('maghribEnd', value);
    _saveToCache('ishaEnd', value);

    notifyListeners();
  }

  // Method to save a boolean value to cache
  Future<void> _saveToCache(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // Method to load cached values on app startup
  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();

    _fajrStart = prefs.getBool('fajrStart') ?? true;
    _fajrEnd = prefs.getBool('fajrEnd') ?? true;
    _dhuhrStart = prefs.getBool('dhuhrStart') ?? true;
    _dhuhrEnd = prefs.getBool('dhuhrEnd') ?? true;
    _asrStart = prefs.getBool('asrStart') ?? true;
    _asrEnd = prefs.getBool('asrEnd') ?? true;
    _maghribStart = prefs.getBool('maghribStart') ?? true;
    _maghribEnd = prefs.getBool('maghribEnd') ?? true;
    _ishaStart = prefs.getBool('ishaStart') ?? true;
    _ishaEnd = prefs.getBool('ishaEnd') ?? true;

    _allPrayersStart =
        _fajrStart && _dhuhrStart && _asrStart && _maghribStart && _ishaStart;

    _allPrayersEnd =
        _fajrEnd && _dhuhrEnd && _asrEnd && _maghribEnd && _ishaEnd;

    notifyListeners();
  }
}
