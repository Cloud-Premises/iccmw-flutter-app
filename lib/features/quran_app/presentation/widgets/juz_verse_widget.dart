import 'package:flutter/material.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/settings_providers.dart';
import 'package:provider/provider.dart';

class JuzVerseWidget extends StatefulWidget {
  final int leading;
  final String verseText;
  final int fontSize;
  final String suraName;
  final int suraId;
  final String transliterationSura;
  final String transliterationVerse;
  final String translationVerse;
  const JuzVerseWidget(
      {super.key,
      required this.leading,
      required this.verseText,
      required this.fontSize,
      required this.suraId,
      required this.suraName,
      required this.transliterationSura,
      required this.translationVerse,
      required this.transliterationVerse});

  @override
  State<JuzVerseWidget> createState() => _JuzVerseWidgetState();
}

class _JuzVerseWidgetState extends State<JuzVerseWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.suraName == ''
            ? Container()
            : Container(
                width: double.infinity,
                color: Colors.green,
                child: Center(
                  child: Text(
                    widget.suraName,
                    style: TextStyle(
                      fontSize: 29,
                      color: Colors.white,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
        Container(
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
                    fontSize: 36,
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
                            widget.translationVerse,
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
                            widget.transliterationVerse,
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
        ),
      ],
    );
  }
}
