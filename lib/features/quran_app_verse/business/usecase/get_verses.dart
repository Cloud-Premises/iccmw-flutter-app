import 'package:iccmw/features/quran_app_verse/data/models/verse_model.dart';
import 'package:iccmw/features/quran_app_verse/data/repository/verse_repository.dart';

class GetVerses {
  final VerseRepository verseRepository;

  GetVerses(this.verseRepository);

  Future<List<VerseModel>> execute() async {
    try {
      return await verseRepository.fetchVerses();
    } catch (e) {
      // print('Error in GetVerses use case: $e');
      rethrow; // Propagate error
    }
  }
}
