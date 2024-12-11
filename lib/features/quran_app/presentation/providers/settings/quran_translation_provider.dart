import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class QuranTranslationProvider extends ChangeNotifier {
  List<Translation> _englishTranslations = [];
  Translation? _selectedTranslation;
  bool _isLoading = true;

  QuranTranslationProvider() {
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
}
