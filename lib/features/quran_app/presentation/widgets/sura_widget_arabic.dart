import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
// ignore: unused_import
import 'package:iccmw/features/quran_app/presentation/pages/verse_page/surah_verse_page.dart';
import 'package:iccmw/features/quran_app/presentation/pages/verse_page.dart';

class SuraWidgetArabic extends StatefulWidget {
  final int leading;
  final String title;
  final String arabicTitle;
  final String subtitle;
  final int numberOfAyat;

  const SuraWidgetArabic({
    super.key,
    required this.leading,
    required this.title,
    required this.arabicTitle,
    required this.subtitle,
    required this.numberOfAyat,
  });

  @override
  State<SuraWidgetArabic> createState() => _SuraWidgetArabicState();
}

class _SuraWidgetArabicState extends State<SuraWidgetArabic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70, // Set a fixed height for the ListTile
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: dividerColor, // Set the color of the bottom border
            width: 1.0, // Set the thickness of the bottom border
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            vertical: 0, horizontal: 8), // Reduce padding inside ListTile
        // leading: Text(
        //   '${widget.leading}',
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
              '${widget.leading}',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.arabicTitle,
              style: TextStyle(
                fontSize: 28,
                // fontFamily: "Poppins",
                // fontFamily: "Pdms",
                // fontFamily: "ArabQuranIslamic",
                fontFamily: "Uthmani2",
                // fontFamily: "NotoNaskhArabic",
                // fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.subtitle,
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              '(${widget.numberOfAyat})',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            // Navigate to the SuraDetailPage with the current data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VersePage(
                  surahLeading: widget.leading,
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
