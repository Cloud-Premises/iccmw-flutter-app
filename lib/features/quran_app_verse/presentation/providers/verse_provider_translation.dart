import 'package:flutter/foundation.dart';
import 'package:iccmw/features/quran_app_verse/business/usecase/get_verses_translation.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model_translation.dart';

class VerseProviderTranslation extends ChangeNotifier {
  final GetVersesTranslation getVerses;

  int _currentChapterId = 2; // Default chapterId
  int get currentChapterId => _currentChapterId;

  List<VerseModelTranslation> _verses = [];
  List<VerseModelTranslation> get verses => _verses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  VerseProviderTranslation(this.getVerses);

  /// Update _currentChapterId and fetch verses based on the new chapterId
  void updateCurrentChapterId(int chapterId) {
    if (_currentChapterId != chapterId) {
      _currentChapterId = chapterId;
      fetchVerses(); // Automatically fetch verses for the new chapter
    }
  }

  /// Fetch verses and filter them by _currentChapterId
  Future<void> fetchVerses() async {
    try {
      _isLoading = true;
      notifyListeners();
      List<VerseModelTranslation> allVerses = await getVerses.execute();
      _verses = allVerses
          .where((verse) => verse.chapterId == _currentChapterId)
          .toList();
      _error = ''; // Clear error message on success
    } catch (e) {
      _error = 'Error fetching verses: $e';
      _verses = []; // Reset verses in case of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
