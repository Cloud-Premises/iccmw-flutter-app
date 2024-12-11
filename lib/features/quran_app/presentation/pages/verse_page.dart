import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/quran_app/presentation/pages/setting_page.dart';

import 'package:iccmw/features/quran_app/presentation/providers/settings/settings_providers.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/verse_page/verse_stream.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/verse_page/verse_widget.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/verse_provider.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/verse_provider_translation.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/verse_provider_translitration.dart';
import 'package:iccmw/features/quran_reciter/presentation/providers/reciters_provider.dart';

import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class SurahInfo {
  final int id;
  final String nameSimple;
  final String nameArabic;
  final String revelationPlace;
  final int versesCount;

  const SurahInfo({
    required this.id,
    required this.nameSimple,
    required this.nameArabic,
    required this.revelationPlace,
    required this.versesCount,
  });
}

class VersePage extends StatefulWidget {
  final int surahLeading;

  const VersePage({
    super.key,
    required this.surahLeading,
  });

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  // Use late initialization for required values
  late final ValueNotifier<double> fontSize = ValueNotifier(32.0);
  late final ValueNotifier<bool> isLoading = ValueNotifier(true);
  late int selectedSurahId;
  late String verseJson = 'uthmani.json';

  // Other state variables
  SurahInfo? surahInfo;
  String selectedSurahName = 'Loading...';
  int selectedVerseCount = 0;
  List<SurahInfo> surahList = [];

// Translation
  // String translation = '';
  // String translitration = '';
  String translationJson = '85';

  late AudioPlayer _audioPlayer;
  int? _currentPlayingIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final verseProvider = Provider.of<VerseProvider>(context, listen: false);
      final verseProvider = Provider.of<VerseProvider>(context, listen: false);
      final verseProviderTranslation =
          Provider.of<VerseProviderTranslation>(context, listen: false);
      final verseProviderTranslitration =
          Provider.of<VerseProviderTranslitration>(context, listen: false);

      verseProvider.updateCurrentChapterId(widget.surahLeading);
      verseProviderTranslation.updateCurrentChapterId(widget.surahLeading);
      verseProviderTranslitration.updateCurrentChapterId(widget.surahLeading);
      verseProvider.fetchVerses();
      verseProviderTranslation.fetchVerses();
      verseProviderTranslitration.fetchVerses();
      // print('widget.initialVerseId ----------------');
      // if (widget.initialVerseId != null) {
      //   final index = verseProvider.verses
      //       .indexWhere((v) => v.id == widget.initialVerseId);
      //   if (index != -1) {
      //     setState(() {
      //       _currentPlayingIndex = index;
      //       _isPlaying = true;
      //     });
      //     final verse = verseProvider.verses[index];
      //     final audioUrl = _buildAudioUrl(verse.chapterId, verse.verseNumber);
      //     _playAudio(audioUrl);
      //     _scrollToSura(verse.chapterId);
      //   }
      // }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (_currentPlayingIndex != null) {
        _playNextVerse();
      }
    });
    selectedSurahId = widget.surahLeading;
    _initializeData();
    Provider.of<QuranSettingsProviders>(context, listen: false).loadVerseText();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _loadAllSuraData(),
    ]);
  }

  Future<void> _loadAllSuraData() async {
    if (!mounted) return;

    try {
      final String response =
          await rootBundle.loadString('assets/json/quranCom/surah/surah.json');
      final data = await json.decode(response);
      final List<dynamic> suraList = data['chapters'];

      if (!mounted) return;

      surahList = suraList
          .map((sura) => SurahInfo(
                id: sura['id'],
                nameSimple: sura['name_simple'],
                nameArabic: sura['name_arabic'],
                revelationPlace: sura['revelation_place'],
                versesCount: sura['verses_count'],
              ))
          .toList();

      final initialSurah = surahList.firstWhere(
        (sura) => sura.id == selectedSurahId,
        orElse: () => surahList.first,
      );

      surahInfo = initialSurah;
      selectedSurahName = initialSurah.nameSimple;
      selectedVerseCount = initialSurah.versesCount;
      isLoading.value = false;
    } catch (e) {
      if (!mounted) return;
      selectedSurahName = 'Error loading surah';
      selectedVerseCount = 0;
      isLoading.value = false;
      debugPrint('Error loading surah data: $e');
    }
  }

  void _increaseFontSize() {
    fontSize.value += 2.0;
  }

  void _decreaseFontSize() {
    if (fontSize.value > 10) {
      fontSize.value -= 2.0;
    }
  }

  void _showSurahDialog() async {
    if (isLoading.value) return;

    String currentValue = selectedSurahName;
    String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Surah'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    isExpanded: true,
                    value: currentValue,
                    items: surahList.map((surah) {
                      return DropdownMenuItem<String>(
                        value: surah.nameSimple,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${surah.id}'),
                            Text(surah.nameSimple),
                            Text(
                              surah.nameArabic,
                              style: const TextStyle(
                                fontSize: 28,
                                fontFamily: "Uthmani2",
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setDialogState(() {
                          currentValue = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(currentValue),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selected != null && selected != selectedSurahName && mounted) {
      final newSurah = surahList.firstWhere(
        (sura) => sura.nameSimple == selected,
        orElse: () => surahList.first,
      );

      setState(() {
        selectedSurahId = newSurah.id;
        selectedSurahName = newSurah.nameSimple;
        selectedVerseCount = newSurah.versesCount;
        surahInfo = newSurah;
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VersePage(surahLeading: selectedSurahId),
          ),
        );
      }
    }
  }

  void _playNextVerse() {
    final verseProvider = Provider.of<VerseProvider>(context, listen: false);
    if (_currentPlayingIndex != null &&
        _currentPlayingIndex! < verseProvider.verses.length - 1) {
      setState(() {
        _currentPlayingIndex = _currentPlayingIndex! + 1;
      });

      final nextVerse = verseProvider.verses[_currentPlayingIndex!];
      final nextAudioUrl =
          _buildAudioUrl(nextVerse.chapterId, nextVerse.verseNumber);
      _playAudio(nextAudioUrl);
    } else {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _playPreviousVerse() {
    final verseProvider = Provider.of<VerseProvider>(context, listen: false);
    if (_currentPlayingIndex != null && _currentPlayingIndex! > 0) {
      setState(() {
        _currentPlayingIndex = _currentPlayingIndex! - 1;
      });

      final previousVerse = verseProvider.verses[_currentPlayingIndex!];
      final previousAudioUrl =
          _buildAudioUrl(previousVerse.chapterId, previousVerse.verseNumber);
      _playAudio(previousAudioUrl);
    } else {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _playAudio(
    String url,
  ) async {
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      _isPlaying = true;
    });

    // Show notification when audio starts playing
    // _showNotification(
    //   'Playing Audio',
    //   'Verse is playing ${_currentPlayingIndex} ',
    // );

    // if (!_isNotificationShown) {
    //   _showNotification(
    //     "Qur'an Audio Playback",
    //     'The verse is now playing.',
    //   );
    //   _isNotificationShown = true;
    // }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      // _hideNotification(); // Hide notification when paused
    } else {
      final verseProvider = Provider.of<VerseProvider>(context, listen: false);
      if (_currentPlayingIndex != null) {
        final verse = verseProvider.verses[_currentPlayingIndex!];
        final audioUrl = _buildAudioUrl(verse.chapterId, verse.verseNumber);
        _playAudio(audioUrl);
      }
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String _buildAudioUrl(int chapterId, int verseNumber) {
    final provider = Provider.of<ReciterProvider>(context, listen: false);

    final selectedReciter = provider.selectedReciter;

    String chapterStr = chapterId.toString().padLeft(3, '0');
    String verseStr = verseNumber.toString().padLeft(3, '0');
    String reciter = selectedReciter?.audioPath ??
        'https://everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com';

    return '$reciter/$chapterStr$verseStr.mp3';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    // _hideNotification(); // Ensure notification is hidden when the player is disposed
    // _scrollController.dispose();
    super.dispose();
  }
  // @override
  // void dispose() {
  //   _audioPlayer.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final settingsProvider = Provider.of<QuranSettingsProviders>(context);

    // setState(() {
    //   verseJson = settingsProvider.currentScript;
    //   _loadVerses();
    // });

    // if (settingsProvider.selectedTranslation?.id != null) {
    //   setState(() {
    //     translationJson = '${settingsProvider.selectedTranslation?.id}';
    //     // print(quranTranslationProvider.selectedTranslation?.id);
    //     _loadTranslations();
    //   });
    // }

    // final currentVerses = verses.where((verse) {
    //   final verseKey = verse['verse_key'] as String;
    //   final sura = int.tryParse(verseKey.split(':')[0]);
    //   return sura == selectedSurahId;
    // }).toList();

    // final currentTranslationVerses = versesTranslation.where((verse) {
    //   final verseKey = verse['verse_key'] as String;
    //   final sura = int.tryParse(verseKey.split(':')[0]);
    //   return sura == selectedSurahId;
    // }).toList();
    // final currentTranslitrationVerses = versesTranslitration.where((verse) {
    //   final verseKey = verse['verse_key'] as String;
    //   final sura = int.tryParse(verseKey.split(':')[0]);
    //   return sura == selectedSurahId;
    // }).toList();

    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, _) {
        if (loading) {
          return Center(
              child: kIsWeb
                  ? CircularProgressIndicator()
                  : (Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator()));
        }

        return Consumer4<VerseProvider, VerseProviderTranslation,
            VerseProviderTranslitration, QuranSettingsProviders>(
          builder: (context, verseProvider, verseProviderTranslation,
              verseProviderTranslitration, quranSettingsProviders, _) {
            if (verseProvider.isLoading ||
                verseProvider.verses.length == 0 ||
                verseProvider.verses.isEmpty) {
              return Center(
                child: Platform.isAndroid || kIsWeb
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator(),
              );
            } else if (verseProvider.error.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(verseProvider.error),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        print(verseProvider.verses);
                        verseProvider.fetchVerses();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                  backgroundColor: quranSettingsProviders.themeColor,
                  body: Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              // backgroundColor: Theme.of(context).colorScheme.primary,
                              backgroundColor: appBarColor,
                              floating: true,
                              snap: true,
                              title: const Text(
                                "Qur'an",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                              ),
                              actions: [
                                IconButton(
                                  icon: const Icon(Icons.settings,
                                      color: Colors.white),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SettingsPage()),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Colors.white),
                                  onPressed: _increaseFontSize,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: Colors.white),
                                  onPressed: _decreaseFontSize,
                                ),
                              ],
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _HeaderDelegate(
                                child: _buildSurahHeader(),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: ListView.builder(
                                shrinkWrap:
                                    true, // Ensure the list does not take up infinite space
                                physics:
                                    const NeverScrollableScrollPhysics(), // Prevent independent scrolling

                                itemCount: verseProvider.verses.length,
                                itemBuilder: (context, index) {
                                  final verse = verseProvider.verses[index];
                                  final verseTranslation =
                                      verseProviderTranslation.verses[index];
                                  final verseTranslitration =
                                      verseProviderTranslitration.verses[index];

                                  return Column(
                                    children: [
                                      VerseWidget(
                                        verse: verse,
                                        verseTranslation: verseTranslation,
                                        verseTranslitration:
                                            verseTranslitration,
                                        fontSize: fontSize,
                                        arabicFont:
                                            quranSettingsProviders.arabicFont,
                                        englishFont:
                                            quranSettingsProviders.englishFont,
                                        isTransliterationEnabled:
                                            quranSettingsProviders
                                                .isTransliterationEnabled,
                                        isTranslationEnabled:
                                            quranSettingsProviders
                                                .isTranslationEnabled,
                                        audioPlayer: _audioPlayer,
                                        isPlaying:
                                            _currentPlayingIndex == index,
                                        onPlay: () {
                                          setState(() {
                                            _currentPlayingIndex = index;
                                          });
                                          final audioUrl = _buildAudioUrl(
                                            verse.chapterId,
                                            verse.verseNumber,
                                          );
                                          _playAudio(audioUrl);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerseStream(
                        audioPlayer: _audioPlayer,
                        currentVerseText: _currentPlayingIndex != null
                            ? verseProvider
                                .verses[_currentPlayingIndex!].textVerse
                            : '',
                        onPlayPause: _togglePlayPause,
                        isPlaying: _isPlaying,
                        onPlayNext: _playNextVerse,
                        onPlayPrevious: _playPreviousVerse,
                        verseId: _currentPlayingIndex != null
                            ? verseProvider.verses[_currentPlayingIndex!].id
                            : 0,
                        verseNumber: _currentPlayingIndex != null
                            ? verseProvider
                                .verses[_currentPlayingIndex!].chapterId
                            : 0,
                      ),
                    ],
                  ));
            }
          },
        );
      },
    );
  }

  Widget _buildSurahHeader() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _showSurahDialog,
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: Colors.white),
            ),
            Positioned.fill(
              child: Image.asset(
                'assets/images/quran/pattern.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Image.asset(
                'assets/images/quran/surah_header.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCircleInfo(
                    surahInfo?.revelationPlace ?? '',
                    selectedSurahId.toString(),
                  ),
                  const SizedBox(width: 21),
                  Row(
                    children: [
                      Text(
                        selectedSurahName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Poppins",
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                  const SizedBox(width: 21),
                  _buildCircleInfo('Ayaat', selectedVerseCount.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleInfo(String topText, String bottomText) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/quran/v_quran_circle.png',
          fit: BoxFit.cover,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              topText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            Text(
              bottomText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // @override
  // void dispose() {
  //   fontSize.dispose();
  //   isLoading.dispose();
  //   super.dispose();
  // }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _HeaderDelegate({required this.child});

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
