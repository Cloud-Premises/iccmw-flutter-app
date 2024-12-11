import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iccmw/features/quran_reciter/data/models/reciter_model.dart';

abstract class ReciterDataSource {
  Future<List<ReciterModel>> getReciterList();
}

class ReciterDataSourceImpl implements ReciterDataSource {
  @override
  Future<List<ReciterModel>> getReciterList() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/json/reciters.json');
      // print("Reciter JSON String: $jsonString");

      final Map<String, dynamic> jsonData =
          json.decode(jsonString) as Map<String, dynamic>;
      // print("Reciter JSON Data: $jsonData");

      final List<dynamic>? recitersJson = jsonData['reciters'];
      if (recitersJson == null) {
        // print("Error: 'reciters' key not found in JSON.");
        return [];
      }

      List<ReciterModel> reciters =
          recitersJson.map((json) => ReciterModel.fromJson(json)).toList();
      // print("Loaded Reciter List: ${reciters.length}");
      return reciters;
    } catch (e) {
      // print("Error loading Reciter JSON: $e");
      return [];
    }
  }
}
