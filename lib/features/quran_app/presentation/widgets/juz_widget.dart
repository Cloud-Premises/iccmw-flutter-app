// Update the onPressed method in your JuzWidget class
import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/quran_app/presentation/pages/juz_verse_page.dart';
// import 'package:iccmw/features/quran_app/presentation/pages/verse_page/juz_verse_page.dart';

class JuzWidget extends StatelessWidget {
  final String juzName;
  final int juzNumber;
  final String juzSuraName;
  final String juzEndSuraName;

  final String juzVerseKeyStart;
  final String juzVerseKeyEnd;
  final int juzVerseStartId;
  final int juzVerseEndId;

  const JuzWidget({
    Key? key,
    required this.juzName,
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
        leading: Stack(
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$juzName',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          "${juzSuraName} (${juzVerseKeyStart}) ${juzEndSuraName} (${juzVerseKeyEnd})",
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
          ),
        ),
        trailing: IconButton(
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
