// // sura_model.dart
// class Sura {
//   final int number;
//   final String name;
//   final String englishName;
//   final String englishNameTranslation;
//   final int numberOfAyahs;
//   final String revelationType;

//   Sura({
//     required this.number,
//     required this.name,
//     required this.englishName,
//     required this.englishNameTranslation,
//     required this.numberOfAyahs,
//     required this.revelationType,
//   });

//   factory Sura.fromJson(Map<String, dynamic> json) {
//     return Sura(
//       number: json['number'],
//       name: json['name'],
//       englishName: json['englishName'],
//       englishNameTranslation: json['englishNameTranslation'],
//       numberOfAyahs: json['numberOfAyahs'],
//       revelationType: json['revelationType'],
//     );
//   }
// }
// sura_model.dart
class Sura {
  final int id;
  final String revelationPlace;
  final int revelationOrder;
  final bool bismillahPre;
  final String nameSimple;
  final String nameComplex;
  final String nameArabic;
  final int versesCount;
  final List<int> pages;
  final TranslatedName translatedName;

  Sura({
    required this.id,
    required this.revelationPlace,
    required this.revelationOrder,
    required this.bismillahPre,
    required this.nameSimple,
    required this.nameComplex,
    required this.nameArabic,
    required this.versesCount,
    required this.pages,
    required this.translatedName,
  });

  factory Sura.fromJson(Map<String, dynamic> json) {
    return Sura(
      id: json['id'],
      revelationPlace: json['revelation_place'],
      revelationOrder: json['revelation_order'],
      bismillahPre: json['bismillah_pre'],
      nameSimple: json['name_simple'],
      nameComplex: json['name_complex'],
      nameArabic: json['name_arabic'],
      versesCount: json['verses_count'],
      pages: List<int>.from(json['pages']),
      translatedName: TranslatedName.fromJson(json['translated_name']),
    );
  }
}

class TranslatedName {
  final String languageName;
  final String name;

  TranslatedName({
    required this.languageName,
    required this.name,
  });

  factory TranslatedName.fromJson(Map<String, dynamic> json) {
    return TranslatedName(
      languageName: json['language_name'],
      name: json['name'],
    );
  }
}
