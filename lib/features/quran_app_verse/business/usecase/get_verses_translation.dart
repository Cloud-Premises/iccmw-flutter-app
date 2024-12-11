import 'package:iccmw/features/quran_app_verse/data/models/verse_model_translation.dart';
import 'package:iccmw/features/quran_app_verse/data/repository/verse_repository_translation.dart';

class GetVersesTranslation {
  final VerseRepositoryTranslation verseRepositoryTranslation;

  GetVersesTranslation(this.verseRepositoryTranslation);

  Future<List<VerseModelTranslation>> execute() async {
    try {
      return await verseRepositoryTranslation.fetchVerses();
    } catch (e) {
      // print('Error in GetVersesTranslation use case: $e');
      rethrow; // Propagate error
    }
  }
}
