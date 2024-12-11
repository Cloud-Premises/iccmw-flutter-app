// lib/models/subcategory.dart
class SubCategory {
  final int id;
  final String name;
  final String imageUrl;
  final String jsonUrl;

  SubCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.jsonUrl,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      jsonUrl: json['jsonUrl'],
    );
  }
}
