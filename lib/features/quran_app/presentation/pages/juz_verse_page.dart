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
import 'package:iccmw/features/quran_app_verse/presentation/providers/juz_verse_provider.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/juz_verse_provider_translation.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/juz_verse_provider_translitration.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/verse_provider.dart';
import 'package:iccmw/features/quran_reciter/presentation/providers/reciters_provider.dart';

import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class SurahInfo {
  final int id;
  final String name;
  final String arabicTitle;
  final String suraName;
  final String endSuraName;
  final int versesCount;
  final int firstVerseId;
  final int lastVerseId;

  const SurahInfo({
    required this.id,
    required this.name,
    required this.arabicTitle,
    required this.versesCount,
    required this.firstVerseId,
    required this.lastVerseId,
    required this.suraName,
    required this.endSuraName,
  });
}

class JuzVersePage extends StatefulWidget {
  final int juzId;
  final int juzVerseStartId;
  final int juzVerseEndId;
  const JuzVersePage({
    super.key,
    required this.juzId,
    required this.juzVerseStartId,
    required this.juzVerseEndId,
  });

  @override
  State<JuzVersePage> createState() => _JuzVersePageState();
}

class _JuzVersePageState extends State<JuzVersePage> {
  // Use late initialization for required values
  late final ValueNotifier<double> fontSize = ValueNotifier(32.0);
  late final ValueNotifier<bool> isLoading = ValueNotifier(true);
  late int selectedJuzId;
  late int selectedfirstVerseId;
  late int selectedlastVerseId;
  late String verseJson = 'uthmani.json';

  // Other state variables
  SurahInfo? surahInfo;
  String selectedJuzName = 'Loading...';
  String selectedArabicTitle = 'Loading...';
  String selectedsuraName = 'Loading...';
  String selectedendSuraName = 'Loading...';
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
      final juzVerseProvider =
          Provider.of<JuzVerseProvider>(context, listen: false);
      final juzVerseProviderTranslation =
          Provider.of<JuzVerseProviderTranslation>(context, listen: false);
      final juzVerseProviderTranslitration =
          Provider.of<JuzVerseProviderTranslitration>(context, listen: false);

      juzVerseProvider.updateCurrentFirstVerseNumber(widget.juzVerseStartId);
      juzVerseProvider.updateCurrentLasttVerseNumber(widget.juzVerseEndId);

      juzVerseProviderTranslation
          .updateCurrentFirstVerseNumber(widget.juzVerseStartId);
      juzVerseProviderTranslation
          .updateCurrentLasttVerseNumber(widget.juzVerseEndId);

      juzVerseProviderTranslitration
          .updateCurrentFirstVerseNumber(widget.juzVerseStartId);
      juzVerseProviderTranslitration
          .updateCurrentLasttVerseNumber(widget.juzVerseEndId);

      juzVerseProvider.fetchVerses();
      juzVerseProviderTranslation.fetchVerses();
      juzVerseProviderTranslitration.fetchVerses();
      // final verseProvider =
      //     Provider.of<JuzVerseProvider>(context, listen: false);
      // final verseProviderTranslation =
      //     Provider.of<JuzVerseProviderTranslation>(context, listen: false);
      // final verseProviderTranslitration =
      //     Provider.of<JuzVerseProviderTranslation>(context, listen: false);

      // verseProvider.updateCurrentChapterId(widget.juzLeading);
      // verseProviderTranslation.updateCurrentChapterId(widget.juzLeading);
      // verseProviderTranslitration.updateCurrentChapterId(widget.juzLeading);
      // verseProvider.fetchVerses();
      // verseProviderTranslation.fetchVerses();
      // verseProviderTranslitration.fetchVerses();
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
    selectedJuzId = widget.juzId;
    selectedfirstVerseId = widget.juzVerseStartId;
    selectedlastVerseId = widget.juzVerseEndId;
    _initializeData();
    Provider.of<QuranSettingsProviders>(context, listen: false).loadVerseText();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _loadAllJuzData(),
    ]);
  }

  Future<void> _loadAllJuzData() async {
    if (!mounted) return;

    try {
      final String response =
          await rootBundle.loadString('assets/json/quranCom/juz/juz.json');
      final data = await json.decode(response);
      final List<dynamic> suraList = data['juzs'];

      if (!mounted) return;

      surahList = suraList
          .map((juz) => SurahInfo(
                id: juz['id'],
                name: juz['name'],
                arabicTitle: juz['arabic_title'],
                versesCount: juz['verses_count'],
                firstVerseId: juz['first_verse_id'],
                lastVerseId: juz['last_verse_id'],
                suraName: juz['sura_name'],
                endSuraName: juz['end_sura_name'],
              ))
          .toList();

      final initialSurah = surahList.firstWhere(
        (juz) => juz.id == selectedJuzId,
        orElse: () => surahList.first,
      );

      surahInfo = initialSurah;
      selectedJuzName = initialSurah.name;
      // selectedArabicTitle:
      // initialSurah.arabicTitle;
      selectedfirstVerseId = initialSurah.firstVerseId;
      selectedlastVerseId = initialSurah.lastVerseId;
      selectedVerseCount = initialSurah.versesCount;
      selectedsuraName = initialSurah.suraName;
      selectedendSuraName = initialSurah.endSuraName;
      isLoading.value = false;
    } catch (e) {
      if (!mounted) return;
      selectedJuzName = 'Error loading surah';
      // print(object);
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

    String currentValue = selectedJuzName;
    String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Juz'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    isExpanded: true,
                    value: currentValue,
                    items: surahList.map((surah) {
                      return DropdownMenuItem<String>(
                        value: surah.name,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${surah.id}'),
                            SizedBox(
                              width: 8,
                            ),
                            Text(surah.name),
                            // Column(
                            //   children: [
                            //     Text(surah.name),
                            //     Text(
                            //       surah.arabicTitle,
                            //       style: const TextStyle(
                            //         fontSize: 28,
                            //         fontFamily: "Uthmani2",
                            //       ),
                            //     ),
                            //   ],
                            // ),
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

    if (selected != null && selected != selectedJuzName && mounted) {
      final newSurah = surahList.firstWhere(
        (sura) => sura.name == selected,
        orElse: () => surahList.first,
      );

      setState(() {
        selectedJuzId = newSurah.id;
        selectedJuzName = newSurah.name;
        selectedVerseCount = newSurah.versesCount;
        surahInfo = newSurah;
        selectedfirstVerseId = newSurah.firstVerseId;
        selectedlastVerseId = newSurah.lastVerseId;
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => JuzVersePage(
              juzId: selectedJuzId,
              juzVerseStartId: selectedfirstVerseId,
              juzVerseEndId: selectedlastVerseId,
            ),
          ),
        );
      }
    }
  }

  void _playNextVerse() {
    final verseProvider = Provider.of<JuzVerseProvider>(context, listen: false);
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
        _currentPlayingIndex = null;
      });
    }
  }

  void _playPreviousVerse() {
    final verseProvider = Provider.of<JuzVerseProvider>(context, listen: false);
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
        _currentPlayingIndex = null;
      });
    }
  }

  void _playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      _isPlaying = true;
    });
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
    //   return sura == selectedJuzId;
    // }).toList();

    // final currentTranslationVerses = versesTranslation.where((verse) {
    //   final verseKey = verse['verse_key'] as String;
    //   final sura = int.tryParse(verseKey.split(':')[0]);
    //   return sura == selectedJuzId;
    // }).toList();
    // final currentTranslitrationVerses = versesTranslitration.where((verse) {
    //   final verseKey = verse['verse_key'] as String;
    //   final sura = int.tryParse(verseKey.split(':')[0]);
    //   return sura == selectedJuzId;
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
        //  VerseProviderTranslation,
        // VerseProviderTranslitration,

        // verseProviderTranslation,
        // verseProviderTranslitration,
        return Consumer4<JuzVerseProvider, JuzVerseProviderTranslation,
            JuzVerseProviderTranslitration, QuranSettingsProviders>(
          builder: (context, verseProvider, juzVerseProviderTranslation,
              juzVerseProviderTranslitration, quranSettingsProviders, _) {
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
                                      juzVerseProviderTranslation.verses[index];
                                  final verseTranslitration =
                                      juzVerseProviderTranslitration
                                          .verses[index];

                                  return Column(
                                    children: [
                                      // ListTile(
                                      //   title: Text(
                                      //     verse.textVerse,
                                      //     style: TextStyle(fontSize: 21),
                                      //   ),
                                      //   trailing: Text(
                                      //       '${verse.chapterId} ${verse.verseNumber}'),
                                      // )
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
                    'Juz',
                    selectedJuzId.toString(),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Text(
                        selectedJuzName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Poppins",
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                  const SizedBox(width: 8),
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
