import 'package:iccmw/features/quran_app_verse/data/models/verse_model_translitration.dart';
import 'package:iccmw/features/quran_app_verse/data/repository/verse_repository_translitration.dart';

class GetVersesTranslitration {
  final VerseRepositoryTranslitration verseRepository;

  GetVersesTranslitration(this.verseRepository);

  Future<List<VerseModelTranslitration>> execute() async {
    try {
      return await verseRepository.fetchVerses();
    } catch (e) {
      // print('Error in GetVersesTranslitration use case: $e');
      rethrow; // Propagate error
    }
  }
}
