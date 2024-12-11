import 'package:flutter/foundation.dart';
import 'package:iccmw/features/quran_app_verse/business/usecase/get_verses.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model.dart';

class VerseProvider extends ChangeNotifier {
  final GetVerses getVerses;

  int _currentChapterId = 2; // Default chapterId
  int get currentChapterId => _currentChapterId;

  List<VerseModel> _verses = [];
  List<VerseModel> get verses => _verses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  VerseProvider(this.getVerses);

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
      List<VerseModel> allVerses = await getVerses.execute();
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