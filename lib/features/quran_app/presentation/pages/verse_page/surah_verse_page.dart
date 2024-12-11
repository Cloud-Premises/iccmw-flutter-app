import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:iccmw/features/quran_app/presentation/pages/setting_page.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/surah_verse_widget.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class SurahVersePage extends StatefulWidget {
  final int leading;
  final String title;
  final String subtitle;
  final int numberOfAyat;

  const SurahVersePage({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.numberOfAyat,
  });

  @override
  State<SurahVersePage> createState() => _SurahVersePageState();
}

class _SurahVersePageState extends State<SurahVersePage> {
  List<dynamic> verses = [];
  bool isLoading = true;
  double fontSize = 32.0; // Initial font size

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  Future<void> _loadVerses() async {
    try {
      // Load the JSON file based on the surah number (leading)
      final String response = await rootBundle
          .loadString('assets/json/quran/${widget.leading}.json');
      final Map<String, dynamic> data = json.decode(response);
      setState(() {
        // Assign verses from the loaded data
        verses = data['verses'];
        isLoading = false;
      });
    } catch (e) {
      // Handle the case where the file does not exist or another error occurs
      setState(() {
        isLoading = false;
      });
      print('Error loading verses: $e');
    }
  }

  void _increaseFontSize() {
    setState(() {
      fontSize += 2.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      fontSize = fontSize > 10
          ? fontSize - 2.0
          : fontSize; // Prevent font size from going too small
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          '${widget.leading}. ${widget.title}',
          style: TextStyle(
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
              child:
                  //  Platform.isAndroid || kIsWeb
                  //     ? CircularProgressIndicator()
                  //     : CupertinoActivityIndicator())

                  kIsWeb
                      ? CircularProgressIndicator()
                      : (Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator()))
          : Column(
              children: [
                // File name: surah_header_widget.dart
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
                                  '${widget.leading}',
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
                              '${widget.title}',
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
                                  '${widget.numberOfAyat}',
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
                  child: ListView.builder(
                    itemCount: verses.length,
                    itemBuilder: (context, index) {
                      final verse = verses[index];
                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: 1.0,
                        child: SurahVerseWidget(
                          suraId: widget.leading,
                          leading: verse['id'],
                          verseText: verse['text'],
                          translation: verse['translation'],
                          transliteration: verse[
                              'transliteration'], // New field for transliteration
                          fontSize:
                              fontSize.toInt(), // Pass the updated font size
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
