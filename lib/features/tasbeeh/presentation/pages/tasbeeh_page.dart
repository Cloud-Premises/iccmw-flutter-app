import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/tasbeeh/presentation/pages/background_page.dart';
import 'package:iccmw/features/tasbeeh/presentation/pages/bookmark_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:iccmw/features/tasbeeh/presentation/providers/select_image_provider.dart';
import 'package:vibration/vibration.dart'; // Import vibration package
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class TasbeehPage extends StatefulWidget {
  const TasbeehPage({super.key});

  @override
  State<TasbeehPage> createState() => _TasbeehPageState();
}

class _TasbeehPageState extends State<TasbeehPage> {
  int _count = 0;
  int _target = 10;
  int _laps = 0;
  final TextEditingController _bookmarkController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool showLapMessage = true;
  bool isVirbration = true;
  bool backgroundColor = true;
  bool isAudio = true;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt('tasbeeh_count') ?? 0;
      _laps = prefs.getInt('tasbeeh_laps') ?? 0;
      _target = prefs.getInt('tasbeeh_target') ?? 10;
    });
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbeeh_count', _count);
    await prefs.setInt('tasbeeh_laps', _laps);
    await prefs.setInt('tasbeeh_target', _target);
    _showSnackBar('Count, laps, and target saved successfully!');
  }

  void _incrementCounter() {
    if (isAudio == true) {
      _playAudio();
    }
    setState(() {
      _count++;
      if (_count == _target) {
        _laps++;
        _count = 0; // Reset count after reaching the target
        if (showLapMessage) {
          _showLapsDialog();
        }

        // Vibrate if isVirbration is true
        if (isVirbration) {
          if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
            Vibration.vibrate(duration: 500);
          }
        }
      }
    });
  }

  void _playAudio() async {
    try {
      // Stop any currently playing audio before starting a new one
      await _audioPlayer.stop();

      // Play the new audio
      await _audioPlayer.play(
        AssetSource('audio/iL.mp3'), // Relative to the assets directory
      );
    } catch (e) {
      // debugPrint('Error playing audio: $e');
    }
  }

  void _resetCounter() {
    setState(() {
      _count = 0;
      _laps = 0;
    });
    _saveCounter();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLapsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Laps Completed'),
          content: Text('You have completed $_laps laps of $_target counts!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSetGoalDialog() {
    _targetController.text = _target.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Set number of Counts in a Lap',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
            ),
          ),
          content: TextField(
            controller: _targetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter number count for one lap',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final int? newTarget =
                    int.tryParse(_targetController.text.trim());
                if (newTarget != null && newTarget > 0) {
                  setState(() {
                    _target = newTarget;
                    _count = 0; // Reset the count when the target is changed
                    _laps = 0; // Reset laps as well
                  });
                  _saveCounter();
                  Navigator.of(context).pop();
                  _showSnackBar('Target updated to $_target!');
                } else {
                  _showSnackBar('Invalid target value.');
                }
              },
              child: const Text(
                'Set',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddBookmarkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add To Bookmark'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _bookmarkController,
                decoration: const InputDecoration(hintText: 'Bookmark Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final String bookmarkName = _bookmarkController.text.trim();
                if (bookmarkName.isNotEmpty) {
                  await _saveBookmark(bookmarkName, _count, _laps);
                  _showSnackBar(
                      'Bookmark "$bookmarkName" saved with count $_count and $_laps laps!');
                  _bookmarkController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveBookmark(String bookmarkName, int count, int laps) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];

    Map<String, dynamic> bookmark = {
      'name': bookmarkName,
      'count': count,
      'laps': laps,
    };

    String bookmarkJson = jsonEncode(bookmark);
    bookmarks.add(bookmarkJson);

    await prefs.setStringList('bookmarks', bookmarks);
  }

  @override
  Widget build(BuildContext context) {
    double progress = _count / _target;

    return Scaffold(
      // backgroundColor: const Color.fromRGBO(0, 153, 51, 1),
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'Tasbeeh',
          style: TextStyle(
            color: appBarTextColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: appBarIconColor,
          ),
        ),
        // actions: [
        //   // isAudio
        //   IconButton(
        //     onPressed: () {
        //       setState(() {
        //         isAudio ? isAudio = false : isAudio = true;
        //       });
        //     },
        //     icon: Icon(
        //       isAudio ? Icons.volume_up : Icons.volume_off_rounded,
        //       color: Colors.white,
        //     ),
        //   ),
        //   IconButton(
        //     onPressed: () {
        //       setState(() {
        //         showLapMessage ? showLapMessage = false : showLapMessage = true;
        //       });
        //     },
        //     icon: Icon(
        //       showLapMessage ? Icons.message : Icons.speaker_notes_off,
        //       color: Colors.white,
        //     ),
        //   ),
        //   IconButton(
        //     onPressed: () {
        //       setState(() {
        //         isVirbration ? isVirbration = false : isVirbration = true;
        //       });
        //     },
        //     icon: Icon(
        //       isVirbration ? Icons.vibration : Icons.phonelink_erase,
        //       color: Colors.white,
        //     ),
        //   ),
        //   IconButton(
        //     onPressed: () {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(builder: (context) => const BackgroudPage()),
        //       );
        //     },
        //     icon: const Icon(
        //       Icons.image,
        //       color: Colors.white,
        //     ),
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.bookmark, color: Colors.white),
        //     onPressed: () {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(builder: (context) => const BookmarkPage()),
        //       );
        //     },
        //   ),
        // ],

        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              // PopupMenuItem(
              //   child: ListTile(
              //     leading: Icon(
              //         isAudio ? Icons.volume_up : Icons.volume_off_rounded),
              //     title: const Text('Mute/Unmute Audio'),
              //     onTap: () {
              //       setState(() {
              //         isAudio = !isAudio;
              //       });
              //       Navigator.pop(context); // Close the menu
              //     },
              //   ),
              // ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                      showLapMessage ? Icons.message : Icons.speaker_notes_off,
                      color: commonComponentColor),
                  title: const Text(
                    'Lap Alert',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      showLapMessage = !showLapMessage;
                    });
                    Navigator.pop(context); // Close the menu
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Image.asset(
                    isVirbration
                        ? 'assets/images/icons/mobile_vibration.png'
                        : 'assets/images/icons/mobile_no_vibration.png',
                    width: 25.0,
                    height: 25.0,
                    color: commonComponentColor,
                  ),
                  // Icon(
                  //   isVirbration ? Icons.vibration : Icons.phonelink_erase,
                  // ),
                  title: const Text(
                    'Notify',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isVirbration = !isVirbration;
                    });
                    Navigator.pop(context); // Close the menu
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Icons.image,
                    color: commonComponentColor,
                  ),
                  title: const Text(
                    'Wallpaper',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the menu
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const BackgroundPage()),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Icons.bookmark,
                    color: commonComponentColor,
                  ),
                  title: const Text('Bookmark'),
                  onTap: () {
                    Navigator.pop(context); // Close the menu
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const BookmarkPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<SelectedImageProvider>(
        builder: (context, selectedImageProvider, child) {
          return Container(
            decoration: BoxDecoration(
              color: selectedImageProvider.selectedImage ==
                      'assets/images/tasbeeh/noImage.png'
                  ? Colors.green[
                      50] // Set your desired background color when no image is selected
                  : null, // When an image is selected, set decoration to null
              image: selectedImageProvider.selectedImage !=
                      'assets/images/tasbeeh/noImage.png' // Only apply the image if it's not the 'noImage' placeholder
                  ? DecorationImage(
                      image: AssetImage(selectedImageProvider.selectedImage),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(
                            0.3), // Adjust opacity here (0.0 to 1.0)
                        BlendMode
                            .darken, // You can change the blend mode if needed
                      ),
                    )
                  : null, // Don't apply any image decoration when the condition is met
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _resetCounter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _saveCounter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _showSetGoalDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Set Goal',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        ElevatedButton(
                          onPressed: _showAddBookmarkDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Add to Bookmark',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: kIsWeb
                            ? CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 10,
                                backgroundColor: Colors.grey[300],
                                color: Colors.green,
                              )
                            : Platform.isAndroid
                                ? CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 10,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.green,
                                  )
                                : CupertinoActivityIndicator(),
                      ),
                      Text(
                        '$_count',
                        style: TextStyle(
                          color: selectedImageProvider.selectedImage ==
                                  'assets/images/tasbeeh/noImage.png'
                              ? Colors.black
                              : Colors.white,
                          fontSize: 66,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Laps: $_laps',
                        style: TextStyle(
                          color: selectedImageProvider.selectedImage ==
                                  'assets/images/tasbeeh/noImage.png'
                              ? Colors.black
                              : Colors.white,
                          fontSize: 21,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Total Count: ${_target * _laps}',
                        style: TextStyle(
                          color: selectedImageProvider.selectedImage ==
                                  'assets/images/tasbeeh/noImage.png'
                              ? Colors.black
                              : Colors.white,
                          fontSize: 21,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  Row(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _incrementCounter,
                        child: Image.asset(
                          'assets/images/icons/fingerprint.png',
                          height: 60,
                          width: 60,
                          color: Colors.orange[100],
                        ),
                      ),
                    ],
                  ),
                  Row(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
