
class ReciterModel {
  final int id;
  final String style;
  final String reciterNameEng;
  final String audioPath;

  ReciterModel({
    required this.id,
    required this.style,
    required this.reciterNameEng,
    required this.audioPath,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'] as int,
      style: json['style'] as String? ?? 'Unknown', // Handle null values
      reciterNameEng: json['reciter_name_eng'] as String? ??
          'Unknown', // Handle null values
      audioPath: json['audio_path'] as String? ?? '', // Handle null values
    );
  }
}
