class VerseModel {
  final int id;
  final int chapterId;
  final int verseNumber;
  final String textVerse;

  VerseModel({
    required this.id,
    required this.chapterId,
    required this.verseNumber,
    required this.textVerse,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    // Split the verse_key into chapterId and verseNumber
    List<String> verseParts = (json['verse_key'] ?? '0:0').split(':');
    int chapterId = int.tryParse(verseParts[0]) ?? 0;
    int verseNumber = int.tryParse(verseParts[1]) ?? 0;

    return VerseModel(
      id: json['id'] ?? 0,
      chapterId: chapterId,
      verseNumber: verseNumber,
      textVerse: json['text_verse'] ?? '',
    );
  }
}
