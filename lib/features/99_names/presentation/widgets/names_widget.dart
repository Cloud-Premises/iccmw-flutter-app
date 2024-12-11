// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:audioplayers/audioplayers.dart';

// Global Variables
final AudioPlayer audioPlayer = AudioPlayer();
List<Map<String, dynamic>> names = [];
int currentIndex = 0;
bool isPlaying = false;
Duration currentPosition = Duration.zero;
dynamic selectedReciter;

// Top-level function to handle notification actions
// Future<void> onNotificationActionReceived(ReceivedAction receivedAction) async {
//   switch (receivedAction.buttonKeyPressed) {
//     case 'PLAY_PAUSE':
//       // isPlaying ? isPlaying = false : isPlaying = true;
//       // togglePlayPause();
//       if (isPlaying) {
//         await audioPlayer.pause();
//       } else {
//         if (currentPosition == Duration.zero) {
//           await audioPlayer.play(AssetSource('${selectedReciter['audio']}'));
//         } else {
//           await audioPlayer.resume();
//         }
//       }
//       break;
//     case 'RESET':
//       await audioPlayer.seek(Duration.zero);
//       if (selectedReciter != null) {
//         await audioPlayer.play(AssetSource('${selectedReciter['audio']}'));
//       }
//       currentIndex = 0;
//       isPlaying = true;
//       break;
//     case 'STOP':
//       isPlaying = false;
//       audioPlayer.stop();
//       break;
//     default:
//       break;
//   }
// }

class NamesWidget extends StatefulWidget {
  const NamesWidget({super.key});

  @override
  State<NamesWidget> createState() => _NamesWidgetState();
}

class _NamesWidgetState extends State<NamesWidget> {
  // final AudioPlayer audioPlayer = AudioPlayer();
  // List<Map<String, dynamic>> names = [];
  // int currentIndex = 0;
  // bool isPlaying = false;
  // Duration currentPosition = Duration.zero;
  // dynamic selectedReciter;

  int scrollIndex = 1;
  final ScrollController _scrollController = ScrollController();
  List<dynamic> recitersData = [];
  int selectedId = 1;

  @override
  void initState() {
    super.initState();
    // loadNames();
    loadRecitersData();

    setupAudioPlayer();

    // AwesomeNotifications().setListeners(
    //   onActionReceivedMethod: onNotificationActionReceived,
    // );
  }

  void setupAudioPlayer() {
    audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }

      if (names.isNotEmpty) {
        int nextIndex = (currentIndex + 1) % names.length;
        if (nextIndex < names.length) {
          Map<String, dynamic> nextTimestamp = names[nextIndex]['Timestamp'];
          Duration nextNameTime = Duration(
            minutes: nextTimestamp['minute'],
            seconds: nextTimestamp['second'],
            milliseconds: nextTimestamp['millisecond'],
          );

          if (position >= nextNameTime) {
            setState(() {
              currentIndex = nextIndex;
            });
            _scrollToGridPosition();
          }
        }
      }
    });

    audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          currentIndex = 0;
          currentPosition = Duration.zero;
        });
      }
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
      if (isPlaying) {
        // sendNotification();
      }
    });
  }

  // void sendNotification() {
  //   final nameData = names.isNotEmpty ? names[currentIndex] : {};
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: 1,
  //       channelKey: 'iccmw_channel',
  //       title: "ICCMW - 99 Names of Allah - ${nameData['Name'] ?? 'Name'}",
  //       body: "Now playing ${nameData['Name'] ?? '99 Names of Allah'}.",
  //       // autoDismissible: false, // Make it sticky and non-removable
  //       icon: 'resource://drawable/notification_icon_drawer',
  //       locked: true,
  //     ),
  //     actionButtons: [
  //       NotificationActionButton(
  //         key: 'PLAY_PAUSE',
  //         label: isPlaying ? 'Play/Pause' : 'Play',
  //         // icon: 'resource://drawable/notification_icon_drawer',
  //         actionType: ActionType.Default,
  //         autoDismissible: false,
  //       ),
  //       NotificationActionButton(
  //         key: 'RESET',
  //         label: 'Reset',
  //         actionType: ActionType.Default,
  //       ),
  //       NotificationActionButton(
  //         key: 'STOP',
  //         label: isPlaying ? 'Stop' : '',
  //         // icon: 'assets/notification/audio/stop.png',
  //         actionType: ActionType.Default,
  //         autoDismissible: true,
  //       ),
  //     ],
  //   );
  // }

  // void cancelNotification() {
  //   AwesomeNotifications().cancel(1);
  // }

  void showRecitersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text("Select Reciter"),
              content: Container(
                height: 200,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: recitersData.length,
                  itemBuilder: (context, index) {
                    final reciter = recitersData[index];
                    return ListTile(
                      leading: Text(
                        '${reciter['id']}', // Display reciter ID
                        style: TextStyle(fontSize: 16),
                      ),
                      title: Text(
                        reciter['reciter'],
                        style: TextStyle(fontSize: 16, fontFamily: "Poppins"),
                      ),
                      trailing: selectedReciter == reciter
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : null,
                      onTap: () {
                        setDialogState(() {
                          selectedReciter =
                              reciter; // Update the selected reciter object
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Use the selected reciter data for saving or further processing
                    // print("Selected Reciter: ${selectedReciter['reciter']}");
                    // print("Selected Audio: ${selectedReciter['audio']}");
                    // print("Selected JSON: ${selectedReciter['json']}");
                    Navigator.of(context).pop();
                    loadNames();
                    audioPlayer.seek(Duration.zero); // Seek to the beginning
                    // audioPlayer.play(AssetSource(
                    //     '${selectedReciter['audio']}')); // Play from the start

                    setState(() {
                      currentIndex = 0; // Reset current index
                      // isPlaying = false; // Set playing state
                    });
                    if (isPlaying) {
                      audioPlayer
                          .play(AssetSource('${selectedReciter['audio']}'));

                      setState(() {
                        currentIndex = 0; // Reset current index
                        isPlaying = true; // Set playing state
                      });
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> loadRecitersData() async {
    final String response = await rootBundle
        .loadString('assets/json/namesOfAllah/namesOfAllahData.json');
    final data = json.decode(response);
    setState(() {
      recitersData = data['namesOfAllahData'];
      selectedReciter = recitersData.first;
    });
    loadNames();
  }

  Future<void> loadNames() async {
    final String response = await rootBundle
        // .loadString('assets/json/namesOfAllah/default/namesOfAllah.json');
        .loadString('${selectedReciter['json']}');

    final data = json.decode(response);
    setState(() {
      names = List<Map<String, dynamic>>.from(data['names']);
    });
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      if (currentPosition == Duration.zero) {
        // await audioPlayer.play(AssetSource('audio/allah_names.mp3'));
        await audioPlayer.play(AssetSource('${selectedReciter['audio']}'));
      } else {
        await audioPlayer.resume();
      }
    }
  }

  void previousName() async {
    if (names.isEmpty) return;

    setState(() {
      currentIndex = (currentIndex - 1) % names.length;
    });

    if (isPlaying) {
      Map<String, dynamic> timestamp = names[currentIndex]['Timestamp'];
      await audioPlayer.seek(Duration(
        minutes: timestamp['minute'],
        seconds: timestamp['second'],
        milliseconds: timestamp['millisecond'],
      ));
    }
  }

  void nextName() async {
    if (names.isEmpty) return;

    setState(() {
      currentIndex = (currentIndex + 1) % names.length;
    });

    if (isPlaying) {
      Map<String, dynamic> timestamp = names[currentIndex]['Timestamp'];
      await audioPlayer.seek(Duration(
        minutes: timestamp['minute'],
        seconds: timestamp['second'],
        milliseconds: timestamp['millisecond'],
      ));
    }
  }

  // Scroll logic for when currentIndex is a multiple of 9
  void _scrollToGridPosition() {
    if (currentIndex % 9 == 0) {
      // print(currentIndex);
      // print(scrollIndex);

      double offset = scrollIndex * 280.0; // Fixed offset for multiples of 9
      setState(() {
        scrollIndex++;
        if (currentIndex == 99) {
          scrollIndex = 1;
        }
      });

      // Only scroll by the fixed offset when currentIndex is a multiple of 9
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          offset,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    isPlaying = false;
    // cancelNotification();
    audioPlayer.stop();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 24,
                  width: 150,
                  color: Colors.white,
                ),
                Icon(
                  Icons.fullscreen,
                  color: headingColorLight.withOpacity(0.3),
                  size: 36,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios_rounded,
                  color: headingColorLight.withOpacity(0.3),
                  size: 36,
                ),
                Column(
                  children: [
                    Container(
                      height: 62,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 24,
                      width: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 160,
                      color: Colors.white,
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: headingColorLight.withOpacity(0.3),
                  size: 36,
                ),
              ],
            ),
          ],
        ),
      );
    }

    final nameData = names[currentIndex];

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                // color: Color.fromRGBO(242, 198, 167, 0.25),
                color: cardColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        // onPressed: previousName,
                        onPressed: nextName,
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: headingColorLight,
                          size: 36,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              nameData['Name'] ?? '',
                              style: const TextStyle(
                                fontFamily: 'Pdms',
                                fontSize: 72,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              nameData['Transliteration'] ?? '',
                              style: const TextStyle(
                                fontFamily: 'Mermaid',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              nameData['Meaning'] ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: showRecitersDialog,
                                  icon: Icon(
                                    Icons.audio_file_rounded,
                                    color: headingColorLight,
                                    size: 28,
                                  ),
                                ),
                                IconButton(
                                  onPressed: togglePlayPause,
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                    color: headingColorLight,
                                    size: 48,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await audioPlayer.seek(Duration.zero);
                                    await audioPlayer.play(AssetSource(
                                        '${selectedReciter['audio']}'));
                                    setState(() {
                                      currentIndex = 0;
                                      isPlaying = true;
                                      if (currentIndex == 0) {
                                        scrollIndex = 0;
                                      }
                                    });
                                    _scrollToGridPosition();
                                  },
                                  icon: Icon(
                                    Icons.replay,
                                    color: headingColorLight,
                                    size: 28,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: previousName,
                        // onPressed: nextName,
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: headingColorLight,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 300,
          margin: EdgeInsets.symmetric(horizontal: 18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cardColor,
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: GridView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                  ),
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    String allahName = names[index]['Name'] ?? 'Unknown';
                    bool currentName = nameData['Name'] == names[index]['Name'];
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: currentName
                                ? commonComponentDarlColor
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              allahName,
                              style: TextStyle(
                                color: currentName
                                    ? headingColorLight
                                    : commonComponentDarlColor,
                                fontSize: 28,
                                fontFamily: 'Pdms',
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
