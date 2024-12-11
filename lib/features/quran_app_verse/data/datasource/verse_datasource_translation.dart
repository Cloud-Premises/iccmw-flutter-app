import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/settings_providers.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model_translation.dart';

class VerseDatasourceTranslation {
  final QuranSettingsProviders settings;

  VerseDatasourceTranslation({required this.settings});

  Future<List<VerseModelTranslation>> fetchVerses() async {
    try {
      // print(settings.selectedTranslation);
      final String response = await rootBundle.loadString(
          'assets/json/quranCom/resources/${settings.selectedTranslation == null ? "19.json" : "${settings.selectedTranslation?.id}.json"}');

      final List<dynamic> data = json.decode(response);

      // Debug print to ensure data is loaded correctly
      // print('Loaded JSON data: $data');

      // Map JSON to VerseModelTranslation
      List<VerseModelTranslation> verses = data.map((item) {
        if (item is Map<String, dynamic>) {
          return VerseModelTranslation.fromJson(item);
        } else {
          throw Exception('Invalid JSON format');
        }
      }).toList();

      return verses;
    } catch (e) {
      // print('Error in VerseDatasourceTranslation: $e');
      rethrow; // Propagate error
    }
  }
}
