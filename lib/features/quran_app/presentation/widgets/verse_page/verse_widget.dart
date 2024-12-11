import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model_translation.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model_translitration.dart';
// import 'package:iccmw/features/quran_app/data/model/verse_model.dart';

class VerseWidget extends StatelessWidget {
  // Verse Number and verse Text
  final VerseModel verse;
  final VerseModelTranslation verseTranslation;
  final VerseModelTranslitration verseTranslitration;

  // Font Family and Font Size
  final fontSize;
  final String arabicFont;
  final String englishFont;
  final Color backgroundColor;

  // Translation Visibility boolean
  final bool isTransliterationEnabled;
  final bool isTranslationEnabled;

  // Audio and Call back function
  final AudioPlayer audioPlayer;
  final VoidCallback onPlay;
  final bool isPlaying;

  const VerseWidget({
    super.key,
    // verse Number and verse Text
    required this.verse,
    required this.verseTranslation,
    required this.verseTranslitration,
    // Font Family and Font Size
    required this.fontSize,
    required this.arabicFont,
    required this.englishFont,

    // Translation Visibility boolean
    this.backgroundColor = Colors.transparent,
    required this.isTransliterationEnabled,
    required this.isTranslationEnabled,

    // Audio and Call back function
    required this.audioPlayer,
    required this.onPlay,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPlaying ? Colors.white : backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.orange,
            width: 0.8,
          ),
        ),
      ),
      child: ListTile(
        title: ValueListenableBuilder<double>(
          valueListenable: fontSize,
          builder: (context, size, _) => Text(
            // '${verseData['text']}',
            verse.textVerse,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: size,
              height: 1.8,
              fontFamily: arabicFont,
            ),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: isTransliterationEnabled,
              child: ValueListenableBuilder<double>(
                valueListenable: fontSize,
                builder: (context, size, _) => Text(
                  verseTranslitration.textVerse,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: size - 16,
                    height: 1.8,
                    fontFamily: englishFont,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isTranslationEnabled,
              child: ValueListenableBuilder<double>(
                valueListenable: fontSize,
                builder: (context, size, _) => Text(
                  verseTranslation.textVerse,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: size - 16,
                    height: 1.8,
                    fontFamily: englishFont,
                  ),
                ),
              ),
            )
          ],
        ),
        trailing: _buildVerseNumberCircle(verse.verseNumber),
        onTap: () {
          onPlay();
          // print(
          //     'Selected Surah ID: 00$selectedSurahId, Verse Number: 00$verseNumber');
          // print(${['text']});
        },
      ),
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
}