// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:iccmw/features/quran_app_verse/data/models/verse_model.dart';

// class VerseDataSource {
//   Future<List<VerseModel>> fetchVerses() async {
//     try {
//       final String response = await rootBundle
//           .loadString('assets/json/quranCom/verse/uthmani.json');
//       final List<dynamic> data = json.decode(response);

//       // Debug print to ensure data is loaded correctly
//       // print('Loaded JSON data: $data');

//       // Map JSON to VerseModel
//       List<VerseModel> verses = data.map((item) {
//         if (item is Map<String, dynamic>) {
//           return VerseModel.fromJson(item);
//         } else {
//           throw Exception('Invalid JSON format');
//         }
//       }).toList();

//       return verses;
//     } catch (e) {
//       // print('Error in VerseDataSource: $e');
//       rethrow; // Propagate error
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/settings_providers.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model.dart';

class VerseDataSource {
  final QuranSettingsProviders settings;

  // Constructor to accept QuranSettingsProviders instance
  VerseDataSource({required this.settings});

  Future<List<VerseModel>> fetchVerses() async {
    try {
      // Use currentScript from settings instead of hardcoding 'uthmani.json'
      final String response = await rootBundle
          .loadString('assets/json/quranCom/verse/${settings.currentScript}');

      final List<dynamic> data = json.decode(response);

      // Map JSON to VerseModel
      List<VerseModel> verses = data.map((item) {
        if (item is Map<String, dynamic>) {
          return VerseModel.fromJson(item);
        } else {
          throw Exception('Invalid JSON format');
        }
      }).toList();

      return verses;
    } catch (e) {
      print('Error in VerseDataSource: $e');
      rethrow; // Propagate error
    }
  }
}
