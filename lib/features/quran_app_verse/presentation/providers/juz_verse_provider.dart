import 'package:flutter/foundation.dart';
import 'package:iccmw/features/quran_app_verse/business/usecase/get_verses.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model.dart';

class JuzVerseProvider extends ChangeNotifier {
  final GetVerses getVerses;

  // Verse
  int _currentFirstVerseNumber = 1;
  int _currentLastVerseNumber = 148;

  // Verse
  int get currentFirstVerseNumber => _currentFirstVerseNumber;
  int get currentLastVerseNumber => _currentLastVerseNumber;

  List<VerseModel> _verses = [];
  List<VerseModel> get verses => _verses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  JuzVerseProvider(this.getVerses);

  /// Update _currentFirstVerseNumber and fetch verses based on the new chapterId
  void updateCurrentFirstVerseNumber(int chapterId) {
    if (_currentFirstVerseNumber != chapterId) {
      _currentFirstVerseNumber = chapterId;
      fetchVerses(); // Automatically fetch verses for the new chapter
    }
  }

  void updateCurrentLasttVerseNumber(int chapterId) {
    if (_currentLastVerseNumber != chapterId) {
      _currentLastVerseNumber = chapterId;
      fetchVerses(); // Automatically fetch verses for the new chapter
    }
  }

  /// Fetch verses and filter them by _currentFirstVerseNumber
  Future<void> fetchVerses() async {
    try {
      _isLoading = true;
      notifyListeners();
      List<VerseModel> allVerses = await getVerses.execute();
      _verses = allVerses
          .where((verse) =>
              verse.id >= _currentFirstVerseNumber &&
              verse.id <= _currentLastVerseNumber)
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
