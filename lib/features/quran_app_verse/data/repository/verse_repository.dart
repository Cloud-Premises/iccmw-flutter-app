import 'package:iccmw/features/quran_app_verse/data/datasource/verse_datasource.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model.dart';

class VerseRepository {
  final VerseDataSource verseDataSource;

  VerseRepository(this.verseDataSource);

  Future<List<VerseModel>> fetchVerses() async {
    try {
      return await verseDataSource.fetchVerses();
    } catch (e) {
      // print('Error in VerseRepository: $e');
      rethrow; // Propagate error
    }
  }
}
