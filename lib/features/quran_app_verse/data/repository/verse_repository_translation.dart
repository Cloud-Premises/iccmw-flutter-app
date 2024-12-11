import 'package:iccmw/features/quran_app_verse/data/datasource/verse_datasource_translation.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model_translation.dart';

class VerseRepositoryTranslation {
  final VerseDatasourceTranslation verseDataSource;

  VerseRepositoryTranslation(this.verseDataSource);

  Future<List<VerseModelTranslation>> fetchVerses() async {
    try {
      return await verseDataSource.fetchVerses();
    } catch (e) {
      // print('Error in VerseRepositoryTranslation: $e');
      rethrow; // Propagate error
    }
  }
}
