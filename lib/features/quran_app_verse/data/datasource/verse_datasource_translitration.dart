import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model_translitration.dart';

class VerseDatasourceTranslitration {
  Future<List<VerseModelTranslitration>> fetchVerses() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/quranCom/resources/57.json');

      final List<dynamic> data = json.decode(response);

      // Debug print to ensure data is loaded correctly
      // print('Loaded JSON data: $data');

      // Map JSON to VerseModelTranslitration
      List<VerseModelTranslitration> verses = data.map((item) {
        if (item is Map<String, dynamic>) {
          return VerseModelTranslitration.fromJson(item);
        } else {
          throw Exception('Invalid JSON format');
        }
      }).toList();

      return verses;
    } catch (e) {
      // print('Error in VerseDatasourceTranslitration: $e');
      rethrow; // Propagate error
    }
  }
}
