import 'package:iccmw/features/quran_app_verse/data/datasource/verse_datasource_translitration.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model_translitration.dart';

class VerseRepositoryTranslitration {
  final VerseDatasourceTranslitration verseDataSource;

  VerseRepositoryTranslitration(this.verseDataSource);

  Future<List<VerseModelTranslitration>> fetchVerses() async {
    try {
      return await verseDataSource.fetchVerses();
    } catch (e) {
      // print('Error in VerseRepositoryTranslitration: $e');
      rethrow; // Propagate error
    }
  }
}
