// lib/models/category.dart
import 'subcategory.dart';

class Category {
  final int id;
  final String name;
  final String icon;
  final List<SubCategory> subcategories;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var subcategoriesJson = json['subcategories'] as List;
    List<SubCategory> subcategoriesList = subcategoriesJson
        .map((subcategory) => SubCategory.fromJson(subcategory))
        .toList();

    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      subcategories: subcategoriesList,
    );
  }
}
