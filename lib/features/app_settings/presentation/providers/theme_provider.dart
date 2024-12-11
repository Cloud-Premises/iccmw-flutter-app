// theme_provider.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart' as material;

class ThemeDataProvider {
  Future<List<CustomThemeData>> loadThemes() async {
    final jsonString = await rootBundle.loadString('assets/json/themes.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => CustomThemeData.fromJson(json)).toList();
  }
}

class CustomThemeData {
  final int id; // Ensure this field exists
  final material.Color color1;
  final material.Color color2;
  bool selected;

  CustomThemeData({
    required this.id,
    required this.color1,
    required this.color2,
    this.selected = false,
  });

  factory CustomThemeData.fromJson(Map<String, dynamic> json) {
    return CustomThemeData(
      id: json['id'],
      color1: material.Color(int.parse(json['color1'].replaceAll('#', '0xff'))),
      color2: material.Color(int.parse(json['color2'].replaceAll('#', '0xff'))),
      selected: json['selected'] ?? false,
    );
  }
}
