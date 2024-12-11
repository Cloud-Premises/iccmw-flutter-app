import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iccmw/features/quran_app/presentation/pages/setting_page.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/settings_providers.dart';
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

class VersePageFancy extends StatefulWidget {
  final int surahLeading;

  const VersePageFancy({
    super.key,
    required this.surahLeading,
  });

  @override
  State<VersePageFancy> createState() => _VersePageFancyState();
}

class _VersePageFancyState extends State<VersePageFancy> {
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
  List<Map<String, dynamic>> verses = [];
  List<Map<String, dynamic>> versesTranslation = [];
  List<Map<String, dynamic>> versesTranslitration = [];

// Translation
  // String translation = '';
  // String translitration = '';
  String translationJson = '85';

  @override
  void initState() {
    super.initState();
    selectedSurahId = widget.surahLeading;
    _initializeData();
    Provider.of<QuranSettingsProviders>(context, listen: false).loadVerseText();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _loadAllSuraData(),
      _loadVerses(),
      _loadTranslations(),
      _loadTranslitration(),
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

  Future<void> _loadVerses() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/quranCom/verse/$verseJson');
      final data = jsonDecode(response);
      if (mounted) {
        verses = List<Map<String, dynamic>>.from(data['verses']);
        // Force a rebuild after verses are loaded
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading verses: $e');
      // Set empty list to prevent infinite loading
    }
  }

  Future<void> _loadTranslations() async {
    try {
      final String response = await rootBundle
          .loadString('assets/json/quranCom/resources/$translationJson.json');
      final data = json.decode(response);

      if (mounted) {
        // print(versesTranslation);
        versesTranslation =
            List<Map<String, dynamic>>.from(data['translations']);
        // Force a rebuild after verses are loaded
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading verses: $e');
      if (mounted) {
        versesTranslation = [];
        setState(() {});
      }
    }
  }

  Future<void> _loadTranslitration() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/quranCom/resources/57.json');
      final data = json.decode(response);

      if (mounted) {
        // print(versesTranslitration);
        versesTranslitration =
            List<Map<String, dynamic>>.from(data['translations']);
        // Force a rebuild after verses are loaded
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading verses: $e');
      if (mounted) {
        versesTranslitration = [];
        setState(() {});
      }
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
            builder: (context) => VersePageFancy(surahLeading: selectedSurahId),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Arabic Theme providers
    final settingsProviders = Provider.of<QuranSettingsProviders>(context);

    setState(() {
      verseJson = settingsProviders.currentScript;
      _loadVerses();
    });

    if (settingsProviders.selectedTranslation?.id != null) {
      setState(() {
        translationJson = '${settingsProviders.selectedTranslation?.id}';
        // print(quranTranslationProvider.selectedTranslation?.id);
        _loadTranslations();
      });
    }

    return Scaffold(
      backgroundColor: settingsProviders.themeColor,
      body: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, loading, _) {
          if (loading) {
            return Center(
              child: kIsWeb
                  ? CircularProgressIndicator()
                  : (Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator()),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
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
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
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
                child: Column(
                  children: [
                    verses.isEmpty
                        ? Center(
                            child: Platform.isAndroid || kIsWeb
                                ? CircularProgressIndicator()
                                : CupertinoActivityIndicator(),
                          )
                        : _buildVersesList(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
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

  Widget _buildVersesList() {
    final currentVerses = verses.where((verse) {
      final verseKey = verse['verse_key'] as String;
      final sura = int.tryParse(verseKey.split(':')[0]);
      return sura == selectedSurahId;
    }).toList();
    final currentTranslationVerses = versesTranslation.where((verse) {
      final verseKey = verse['verse_key'] as String;
      final sura = int.tryParse(verseKey.split(':')[0]);
      return sura == selectedSurahId;
    }).toList();
    final currentTranslitrationVerses = versesTranslitration.where((verse) {
      final verseKey = verse['verse_key'] as String;
      final sura = int.tryParse(verseKey.split(':')[0]);
      return sura == selectedSurahId;
    }).toList();

    final settingsProviders = Provider.of<QuranSettingsProviders>(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentVerses.length,
      itemBuilder: (context, index) {
        final verseData = currentVerses[index];
        final verseTranslationData = currentTranslationVerses[index];
        final verseTranslitrationData = currentTranslitrationVerses[index];

        final verseNumber = int.tryParse(verseData['verse_key'].split(':')[1]);

        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.green,
                width: 0.8,
              ),
            ),
          ),
          child: ListTile(
            title: ValueListenableBuilder<double>(
              valueListenable: fontSize,
              builder: (context, size, _) => Text(
                '${verseData['text_${verseJson.split('.').first}']}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: size,
                  height: 1.8,
                  fontFamily: '${settingsProviders.arabicFont}',
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                settingsProviders.isTransliterationEnabled
                    ? ValueListenableBuilder<double>(
                        valueListenable: fontSize,
                        builder: (context, size, _) => Text(
                          '${verseTranslitrationData['text']}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: size - 16,
                            height: 1.8,
                            fontFamily: '${settingsProviders.englishFont}',
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
                SizedBox(
                  height: 8,
                ),
                settingsProviders.isTranslationEnabled
                    ? ValueListenableBuilder<double>(
                        valueListenable: fontSize,
                        builder: (context, size, _) => Text(
                          '${verseTranslationData['text']}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: size - 16,
                            height: 1.8,
                            fontFamily: '${settingsProviders.englishFont}',
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
              ],
            ),
            trailing: _buildVerseNumberCircle(verseNumber),
            onTap: () {
              print(
                  'Selected Surah ID: 00$selectedSurahId, Verse Number: 00$verseNumber');
              // print(${['text']});
            },
          ),
        );
      },
    );
  }

  Widget _buildVerseNumberCircle(int? verseNumber) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/quran/circle_border.png',
          fit: BoxFit.cover,
          width: 40,
          height: 40,
        ),
        Text(
          '$verseNumber',
          style: const TextStyle(
            fontSize: 32,
            fontFamily: 'AyatQuran',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    fontSize.dispose();
    isLoading.dispose();
    super.dispose();
  }
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
