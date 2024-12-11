// lib/services/business_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iccmw/features/local_business/data/model/category.dart';

class BusinessService {
  Future<List<Category>> loadCategories() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/business.json');
      final data = json.decode(response);
      final categoriesJson = data['categories'] as List;
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
