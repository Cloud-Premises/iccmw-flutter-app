import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for loading assets
import 'package:iccmw/features/quran_app/presentation/pages/setting_page.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/juz_verse_widget.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class JuzVersePage extends StatefulWidget {
  final String juzName;
  final int juzNumber;
  final String juzSuraName;
  final String juzEndSuraName;
  final String juzVerseKeyStart;
  final String juzVerseKeyEnd;

  const JuzVersePage({
    super.key,
    required this.juzName,
    required this.juzNumber,
    required this.juzSuraName,
    required this.juzEndSuraName,
    required this.juzVerseKeyStart,
    required this.juzVerseKeyEnd,
  });

  @override
  State<JuzVersePage> createState() => _JuzVersePageState();
}

class _JuzVersePageState extends State<JuzVersePage> {
  List<dynamic> verses = [];
  Map<int, Map<String, dynamic>> suraInfo = {}; // Updated to include suraId
  bool isLoading = true;
  double fontSize = 32.0; // Initial font size

  @override
  void initState() {
    super.initState();
    loadSuras(); // Load sura names first
  }

  Future<void> loadSuras() async {
    // Extract chapter numbers from verse keys
    final startChapter = int.parse(widget.juzVerseKeyStart.split(':')[0]);
    final endChapter = int.parse(widget.juzVerseKeyEnd.split(':')[0]);
    final endVerse = int.parse(widget.juzVerseKeyEnd.split(':')[1]);

    // Load verses for the given range
    await loadVerses(startChapter, endChapter, endVerse);
  }

  Future<void> loadVerses(
      int startChapter, int endChapter, int endVerse) async {
    List<dynamic> loadedVerses = [];
    try {
      // Load verses for each chapter in the range
      for (int chapter = startChapter; chapter <= endChapter; chapter++) {
        // Load the JSON file for the current chapter
        String jsonData =
            await rootBundle.loadString('assets/json/quran/$chapter.json');
        Map<String, dynamic> chapterData = json.decode(jsonData);

        // Get all verses for the chapter
        List<dynamic> chapterVerses = chapterData['verses'];

        // If it's the last chapter, filter by endVerse
        if (chapter == endChapter) {
          chapterVerses =
              chapterVerses.where((verse) => verse['id'] <= endVerse).toList();
        }

        // Add to the list of loaded verses
        loadedVerses.addAll(chapterVerses);

        // Save sura information for display
        suraInfo[chapter] = {
          'suraId': chapterData['id'], // Include the suraId
          'transliterationSura': chapterData['transliteration'] ?? '',
          'nameSura': chapterData['name'] ?? ''
        };
      }

      // Update state with loaded verses
      setState(() {
        verses = loadedVerses;
        isLoading = false;
      });
    } catch (e) {
      // Handle error gracefully
      print('Error loading verses: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _increaseFontSize() {
    setState(() {
      fontSize += 2.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      fontSize = fontSize > 10 ? fontSize - 2.0 : fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          '${widget.juzNumber}. ${widget.juzName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          SizedBox(
            width: 6,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: _increaseFontSize,
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
            onPressed: _decreaseFontSize,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: kIsWeb
                  ? CircularProgressIndicator()
                  : (Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator()),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  child: Stack(
                    children: [
                      // Background image
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

                      // Centered Row with images and text on top
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Stack for the first circle and text on top
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/quran/v_quran_circle.png',
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  '${widget.juzNumber}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 32,
                                    fontFamily: 'AyatQuran',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 21),

                            // Title text in the middle
                            Text(
                              '${widget.juzName}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Poppins",
                              ),
                            ),

                            SizedBox(width: 21),

                            // Stack for the second circle and text on top
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/quran/v_quran_circle.png',
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  widget.juzVerseKeyEnd.split(':')[1],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 32,
                                    fontFamily: 'AyatQuran',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _buildVerseWidgets(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildVerseWidgets() {
    List<Widget> verseWidgets = [];
    int? lastChapterId; // Track the last chapter ID

    for (var verse in verses) {
      String suraName = '';
      String transliterationSura = '';
      int suraId = 0;

      if (verse['chapter_id'] != lastChapterId) {
        // Get the new sura information
        final suraData = suraInfo[verse['chapter_id']];
        if (suraData != null) {
          suraId = suraData['suraId'] ?? 0;
          transliterationSura = suraData['transliterationSura']!;
          suraName = suraData['nameSura']!;
        }
        lastChapterId = verse['chapter_id']; // Update the last chapter ID
      }

      verseWidgets.add(
        JuzVerseWidget(
          leading: verse['id'],
          verseText: verse['text'], // Display the text of the verse
          fontSize: fontSize.toInt(),
          translationVerse: verse['translation'],
          transliterationVerse: verse['transliteration'],
          suraName:
              suraName, // Pass the sura name (or empty string if same chapter)
          transliterationSura: transliterationSura, // Pass the transliteration
          suraId: suraId, // Pass the suraId
        ),
      );
    }

    return verseWidgets;
  }
}
