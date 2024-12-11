// quran_text_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuranTextProvider with ChangeNotifier {
  String _currentScript = 'uthmani.json'; // default script file
  String _firstVerseText = '';

  String get currentScript => _currentScript;
  String get firstVerseText => _firstVerseText;

  List<String> availableScripts = [
    'uthmani.json',
    'imlaei.json',
    'indopak.json',
    'uthmani_simple.json',
    // "uthmani_tajweed.json"
  ];

  Future<void> loadVerseText() async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/json/quranCom/verse/$_currentScript');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _firstVerseText =
          jsonData['verses'][0]['text_${_currentScript.split('.').first}'];

      notifyListeners();
    } catch (e) {
      print(
          "Error loading verse text: $e text_${_currentScript.split('.').first}");
    }
  }

  void setScript(String newScript) {
    if (newScript != _currentScript) {
      _currentScript = newScript;
      loadVerseText(); // Load the verse text from the selected script
    }
  }
}
