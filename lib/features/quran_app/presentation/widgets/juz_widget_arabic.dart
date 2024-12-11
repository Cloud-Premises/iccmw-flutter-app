// Update the onPressed method in your JuzWidgetArabic class
import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/quran_app/presentation/pages/juz_verse_page.dart';

class JuzWidgetArabic extends StatelessWidget {
  final String juzName;
  final String juzArabicTitle;

  final int juzNumber;
  final String juzSuraName;
  final String juzEndSuraName;

  final String juzVerseKeyStart;
  final String juzVerseKeyEnd;

  final int juzVerseStartId;
  final int juzVerseEndId;

  const JuzWidgetArabic({
    Key? key,
    required this.juzName,
    required this.juzArabicTitle,
    required this.juzNumber,
    required this.juzSuraName,
    required this.juzEndSuraName,
    required this.juzVerseKeyStart,
    required this.juzVerseKeyEnd,
    required this.juzVerseStartId,
    required this.juzVerseEndId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 75,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: ListTile(
        // leading: Text(
        //   '$juzNumber',
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontFamily: "Poppins",
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
              '${juzNumber}',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    juzArabicTitle,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 28,
                      // fontFamily: "Poppins",
                      // fontFamily: "Pdms",
                      // fontFamily: "arabQuranIslamic",
                      fontFamily: "Uthmani2",
                      // fontFamily: "NotoNaskhArabic",
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '$juzName',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text(
          "${juzSuraName} (${juzVerseKeyStart}) ${juzEndSuraName} (${juzVerseKeyEnd})",
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JuzVersePage(
                  juzId: juzNumber,
                  juzVerseStartId: juzVerseStartId,
                  juzVerseEndId: juzVerseEndId,
                ),
              ),
            );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => JuzVersePage(
            //       juzName: juzName,
            //       juzNumber: juzNumber,
            //       juzSuraName: juzSuraName,
            //       juzVerseKeyStart: juzVerseKeyStart,
            //       juzEndSuraName: juzEndSuraName,
            //       juzVerseKeyEnd: juzVerseKeyEnd,
            //     ),
            //   ),
            // );
          },
          icon: Icon(
            Icons.play_circle_outline,
            color: commonComponentColor,
            size: 32,
          ),
        ),
      ),
    );
  }
}
