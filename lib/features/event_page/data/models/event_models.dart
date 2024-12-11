// File: lib/models/event_model.dart
import 'dart:convert';

class Event {
  final String title;
  final DateTime date;
  final List<String> images;

  Event({
    required this.title,
    required this.date,
    required this.images,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      date: DateTime(
        json['date']['year'],
        _monthStringToNumber(json['date']['month']),
        json['date']['day'],
      ),
      images: List<String>.from(json['images']),
    );
  }

  static int _monthStringToNumber(String month) {
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    return months[month] ?? 1; // Default to January if month not found
  }

  static List<Event> fromJsonList(String jsonString) {
    final jsonData = jsonDecode(jsonString);
    return (jsonData['events'] as List)
        .map((eventJson) => Event.fromJson(eventJson))
        .toList();
  }
}
