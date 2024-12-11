import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ThemeColors {
  yellow,
  green,
  orange,
  black,
  blue,
}

class Translation {
  final int id;
  final String name;
  final String authorName;
  final String slug;
  final String languageName;
  final TranslatedName translatedName;

  Translation({
    required this.id,
    required this.name,
    required this.authorName,
    required this.slug,
    required this.languageName,
    required this.translatedName,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'],
      name: json['name'],
      authorName: json['author_name'],
      slug: json['slug'],
      languageName: json['language_name'],
      translatedName: TranslatedName.fromJson(json['translated_name']),
    );
  }

  @override
  String toString() {
    return 'Translation(id: $id, name: $name)';
  }
}

class TranslatedName {
  final String name;
  final String languageName;

  TranslatedName({
    required this.name,
    required this.languageName,
  });

  factory TranslatedName.fromJson(Map<String, dynamic> json) {
    return TranslatedName(
      name: json['name'],
      languageName: json['language_name'],
    );
  }
}

// Settings Providers
class QuranSettingsProviders with ChangeNotifier {
  // Settings Providers
  String _arabicFont = 'Uthmani2';
  String get arabicFont => _arabicFont;
  void setArabicFont(String newFont) {
    _arabicFont = newFont;
    notifyListeners();
  }

// English Font Provider
  String _englishFont = 'Poppins';
  String get englishFont => _englishFont;
  void setEnglishFont(String newFont) {
    _englishFont = newFont;
    notifyListeners();
  }

  // Theme Color Provider
  ThemeColors _selectedColor = ThemeColors.orange;
  ThemeColors get selectedColor => _selectedColor;

  Color get themeColor {
    switch (_selectedColor) {
      case ThemeColors.black:
        return Colors.black87;
      case ThemeColors.green:
        return Colors.green[50]!;
      case ThemeColors.orange:
        return Colors.orange[50]!;
      case ThemeColors.yellow:
        return Colors.yellow[50]!;
      case ThemeColors.blue:
        return Colors.blue[50]!;
    }
  }

  Color get themeSelectedColor {
    switch (_selectedColor) {
      case ThemeColors.black:
        return Colors.black87;
      case ThemeColors.green:
        return Colors.green[50]!;
      case ThemeColors.orange:
        return Colors.orange[50]!;
      case ThemeColors.yellow:
        return Colors.yellow[50]!;
      case ThemeColors.blue:
        return Colors.blue[50]!;
    }
  }

  void setThemeColor(ThemeColors newColor) {
    _selectedColor = newColor;
    notifyListeners();
  }

  String _currentScript = 'uthmani.json'; // Default script file
  String _firstVerseText = '';

  // Getter for current script
  String get currentScript => _currentScript;

  // Getter for the first verse text
  String get firstVerseText => _firstVerseText;

  // List of available scripts
  List<String> availableScripts = [
    'uthmani.json',
    'imlaei.json',
    'indopak.json',
    'uthmani_simple.json',
    // 'uthmani_tajweed.json' // Uncomment if required
  ];

  /// Loads the first verse text from the current script file.
  Future<void> loadVerseText() async {
    try {
      // Load JSON string from the assets directory
      final String jsonString = await rootBundle
          .loadString('assets/json/quranCom/verse/$_currentScript');

      // Parse the JSON data
      // final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> jsonData = jsonDecode(jsonString);
      // Set the first verse text
      _firstVerseText = jsonData[0]['text_verse'];

      // Notify listeners about the updated text
      notifyListeners();
    } catch (e) {
      print("Error loading verse text: Testing $e");
    }
  }

  /// Updates the script file and reloads the verse text.
  void setScript(String newScript) {
    if (newScript != _currentScript) {
      _currentScript = newScript;

      // Load the verse text from the new script
      notifyListeners();
      loadVerseText();
    }
  }

  //

  List<Translation> _englishTranslations = [];
  Translation? _selectedTranslation;
  bool _isLoading = true;

  QuranSettingsProviders() {
    loadTranslations();
  }

  // Getters
  List<Translation> get englishTranslations => _englishTranslations;
  Translation? get selectedTranslation => _selectedTranslation;
  bool get isLoading => _isLoading;

  Future<void> loadTranslations() async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/json/quranCom/translations/translations.json');

      final Map<String, dynamic> jsonData = json.decode(jsonString);

      _englishTranslations = (jsonData['translation']['english'] as List)
          .map((json) => Translation.fromJson(json))
          .toList();

      // Set the first translation as default selected translation
      if (_englishTranslations.isNotEmpty) {
        _selectedTranslation = _englishTranslations.first;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading translations: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedTranslationById(int id) {
    _selectedTranslation = _englishTranslations.firstWhere(
        (translation) => translation.id == id,
        orElse: () => _englishTranslations.first);
    notifyListeners();
  }

  // Font Size
  double _fontSize = 16.0; // Default font size
  double get fontSize => _fontSize;
  void setFontSize(double newFontSize) {
    _fontSize = newFontSize;
    notifyListeners();
  }

  // Quran Translation
  bool _isTranslationEnabled = false; // Default value

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

  // Quran Translitration
  bool _isTransliterationEnabled = false; // Default value

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
