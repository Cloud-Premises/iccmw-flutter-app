// surah_verse_widget.dart

import 'package:flutter/material.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/settings_providers.dart';
import 'package:provider/provider.dart';

class SurahVerseWidget extends StatefulWidget {
  final int suraId;
  final int leading;
  final String verseText;
  final String translation;
  final String transliteration;
  final int fontSize;

  const SurahVerseWidget({
    super.key,
    required this.suraId,
    required this.leading,
    required this.verseText,
    required this.translation,
    required this.transliteration,
    required this.fontSize,
  });

  @override
  State<SurahVerseWidget> createState() => _SurahVerseWidgetState();
}

class _SurahVerseWidgetState extends State<SurahVerseWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.green, // Set the color of the bottom border
            width: 1.0, // Set the thickness of the bottom border
          ),
        ),
      ),
      child: ListTile(
        // trailing: Text(
        //   '${widget.leading}',
        //   style: TextStyle(
        //     fontSize: 36,
        //     fontFamily: 'AyatQuran',
        //   ),
        // ),
        trailing: Stack(
          alignment: Alignment.center, // Centers the text over the image
          children: [
            // Background image layer
            Image.asset(
              'assets/images/quran/circle_border.png',
              fit: BoxFit.cover, // Adjusts how the image fills the space
              width: 40, // Set the width and height as needed
              height: 40,
            ),
            // Text layer on top
            Text(
              '${widget.leading}',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'AyatQuran',
              ),
            ),
          ],
        ),
        title: Text(
          '${widget.verseText}',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: widget.fontSize
                .toDouble(), // Use the font size from the parent widget
            fontFamily: 'Uthmani2',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<QuranSettingsProviders>(
              builder: (context, translationProvider, child) {
                return translationProvider.isTranslationEnabled
                    ? Text(
                        widget.translation,
                        style: TextStyle(
                          fontSize: widget.fontSize.toDouble() -
                              10, // Use the font size from the parent widget
                          // fontFamily: 'Uthmani2',
                        ),
                      )
                    : Container(); // Empty container if translation is disabled
              },
            ),
            Consumer<QuranSettingsProviders>(
              builder: (context, transliterationProvider, child) {
                return transliterationProvider.isTransliterationEnabled
                    ? Text(
                        widget.translation,
                        style: TextStyle(
                          fontSize: widget.fontSize.toDouble() -
                              10, // Use the font size from the parent widget
                          // fontFamily: 'Uthmani2',
                        ),
                      )
                    : Container(); // Empty container if transliteration is disabled
              },
            ),
          ],
        ),
      ),
    );
  }
}
