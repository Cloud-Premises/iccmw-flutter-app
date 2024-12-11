import 'package:flutter/material.dart';
import 'package:iccmw/features/quran_app_verse/data/models/verse_model.dart';

class VerseTile extends StatelessWidget {
  final VerseModel verse;
  // final AudioPlayer audioPlayer;
  // final VoidCallback onPlay;
  // final bool isPlaying;
  final Color backgroundColor; // Add a new property for background color

  const VerseTile({
    super.key,
    required this.verse,
    // required this.audioPlayer,
    // required this.onPlay,
    // this.isPlaying = false,
    this.backgroundColor =
        Colors.transparent, // Default to white if not provided
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: const Border.symmetric(
              horizontal: BorderSide(
                color: Color.fromARGB(255, 189, 187, 187),
                width: 1,
              ),
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            // tileColor: isPlaying
            //     ? Colors.grey[200]
            //     : Colors.transparent, // Set the tile color here
            trailing: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Image.asset(
                    'assets/images/symbols/circle.png',
                    width: 35.0,
                    height: 50.0,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: Center(
                      child: Text(
                        verse.verseNumber.toString(),
                        style: const TextStyle(
                          fontFamily: 'AyatQuran',
                          fontSize: 35.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              verse.textVerse,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Uthmani2',
                fontSize: 21,
                height: 1.5,
                // color: isPlaying
                //     ? Colors.green
                //     : Colors.black, // Changes color when playing
              ),
            ),
            // onTap: onPlay,

            onTap: () {
              // print('Tapped Verse ID: ${verse.id}'); // Print the verse ID
              // onPlay(); // Call the onPlay callback
            },
          ),
        ),
      ],
    );
  }
}
