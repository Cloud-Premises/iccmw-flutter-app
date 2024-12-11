// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:iccmw/features/home_page/presentation/widgets/allah_names/audio_player_service.dart';

// Modify the notification action handler
// Future<void> onNotificationActionReceived(ReceivedAction receivedAction) async {
//   final audioService = AudioPlayerService();

//   switch (receivedAction.buttonKeyPressed) {
//     case 'PLAY_PAUSE':
//       if (audioService.isPlaying) {
//         await audioService.pause();
//       } else {
//         await audioService.play();
//       }
//       break;
//     case 'RESET':
//       await audioService.seekToName(0);
//       await audioService.play();
//       break;
//     case 'STOP':
//       await audioService.stop();
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
  late final AudioPlayerService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioPlayerService();
    _audioService.init().then((_) {
      if (mounted) setState(() {});
    });

    setupAudioPlayer();

    // AwesomeNotifications().setListeners(
    //   onActionReceivedMethod: onNotificationActionReceived,
    // );
  }

  void setupAudioPlayer() {
    _audioService.audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {});
      }
    });

    _audioService.audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });

    _audioService.audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {});
        if (_audioService.isPlaying) {
          // sendNotification();
        }
      }
    });
  }

  // void sendNotification() {
  //   final nameData = _audioService.names.isNotEmpty
  //       ? _audioService.names[_audioService.currentIndex]
  //       : {};
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
  //         label: _audioService.isPlaying ? 'Play/Pause' : 'Play',
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
  //         label: _audioService.isPlaying ? 'Stop' : '',
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
                  itemCount: _audioService.recitersData.length,
                  itemBuilder: (context, index) {
                    final reciter = _audioService.recitersData[index];
                    return ListTile(
                      leading: Text(
                        '${reciter['id']}', // Display reciter ID
                        style: TextStyle(fontSize: 16),
                      ),
                      title: Text(
                        reciter['reciter'],
                        style: TextStyle(fontSize: 16, fontFamily: "Poppins"),
                      ),
                      trailing: _audioService.selectedReciter == reciter
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : null,
                      onTap: () {
                        setDialogState(() {
                          _audioService.selectedReciter =
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
                    _audioService.loadNames();
                    _audioService.seekToName(0); // Seek to the beginning
                    // audioPlayer.play(AssetSource(
                    //     '${selectedReciter['audio']}')); // Play from the start

                    setState(() {
                      _audioService.currentIndex = 0; // Reset current index
                      // isPlaying = false; // Set playing state
                    });
                    if (_audioService.isPlaying) {
                      _audioService.play();

                      setState(() {
                        _audioService.currentIndex = 0; // Reset current index
                        _audioService.isPlaying = true; // Set playing state
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

  // Load JSON data from assets
  Future<void> loadRecitersData() async {
    final String response = await rootBundle
        .loadString('assets/json/namesOfAllah/namesOfAllahData.json');
    final data = json.decode(response);
    setState(() {
      _audioService.recitersData = data['namesOfAllahData'];
      _audioService.selectedReciter = _audioService.recitersData.first;
    });
    _audioService.loadNames();
  }

  Future<void> loadNames() async {
    final String response = await rootBundle
        // .loadString('assets/json/namesOfAllah/default/namesOfAllah.json');
        .loadString('${_audioService.selectedReciter['json']}');
    final data = json.decode(response);

    setState(() {
      _audioService.names = List<Map<String, dynamic>>.from(data['names']);
    });
  }

  // Update the togglePlayPause method
  Future<void> togglePlayPause() async {
    if (_audioService.isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play();
    }
  }

  // Update previous/next methods
  void previousName() async {
    if (_audioService.names.isEmpty) return;
    int newIndex =
        (_audioService.currentIndex - 1) % _audioService.names.length;
    await _audioService.seekToName(newIndex);
  }

  void nextName() async {
    if (_audioService.names.isEmpty) return;
    int newIndex =
        (_audioService.currentIndex + 1) % _audioService.names.length;
    await _audioService.seekToName(newIndex);
  }

  @override
  void dispose() {
    // No need to dispose audioPlayer here as it's managed by the service
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_audioService.names.isEmpty) {
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
                  color: Colors.orange.withOpacity(0.3),
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
                  color: Colors.orange.withOpacity(0.3),
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
                  color: Colors.orange.withOpacity(0.3),
                  size: 36,
                ),
              ],
            ),
          ],
        ),
      );
    }

    final nameData = _audioService.names[_audioService.currentIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: nextName,
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.orange,
                size: 36,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Wrap the text widgets in AnimatedSwitcher for animation
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      nameData['Name'] ?? '',
                      key: ValueKey<String>(nameData['Name'] ?? ''),
                      style: const TextStyle(
                        fontFamily: 'Pdms',
                        fontSize: 64,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      nameData['Transliteration'] ?? '',
                      key: ValueKey<String>(nameData['Transliteration'] ?? ''),
                      style: const TextStyle(
                        fontFamily: 'Mermaid',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      nameData['Meaning'] ?? '',
                      key: ValueKey<String>(nameData['Meaning'] ?? ''),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: showRecitersDialog,
                        icon: Icon(
                          Icons.audio_file_rounded,
                          color: Colors.orange,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: togglePlayPause,
                        icon: Icon(
                          _audioService.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.orange,
                          size: 48,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _audioService
                              .seekToName(0); // Seek to the beginning
                          await _audioService.play(); // Play from the start
                          setState(() {
                            _audioService.currentIndex =
                                0; // Reset current index
                            _audioService.isPlaying = true; // Set playing state
                          });
                        },
                        icon: const Icon(
                          Icons.replay,
                          color: Colors.orange,
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
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.orange,
                size: 36,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
