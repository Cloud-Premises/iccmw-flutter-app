import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  late AudioPlayer _audioPlayer;
  List<Map<String, dynamic>> names = [];
  int currentIndex = 0;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  dynamic selectedReciter;
  List<dynamic> recitersData = [];

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> init() async {
    _audioPlayer = AudioPlayer();
    await loadRecitersData();

    _audioPlayer.onPositionChanged.listen((Duration position) {
      currentPosition = position;
      _updateCurrentNameBasedOnTimestamp(position);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      isPlaying = false;
      currentIndex = 0;
      currentPosition = Duration.zero;
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      isPlaying = state == PlayerState.playing;
    });
  }

  Future<void> loadRecitersData() async {
    final String response = await rootBundle
        .loadString('assets/json/namesOfAllah/namesOfAllahData.json');
    final data = json.decode(response);
    recitersData = data['namesOfAllahData'];
    selectedReciter = recitersData.first;
    await loadNames();
  }

  Future<void> loadNames() async {
    final String response =
        await rootBundle.loadString('${selectedReciter['json']}');
    final data = json.decode(response);
    names = List<Map<String, dynamic>>.from(data['names']);
  }

  void _updateCurrentNameBasedOnTimestamp(Duration position) {
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
          currentIndex = nextIndex;
        }
      }
    }
  }

  Future<void> play() async {
    try {
      if (_audioPlayer.state == PlayerState.disposed) {
        // Reinitialize if disposed
        await init();
      }

      if (currentPosition == Duration.zero ||
          _audioPlayer.state == PlayerState.stopped) {
        // If starting from beginning or after stop
        await _audioPlayer.play(AssetSource('${selectedReciter['audio']}'));
        if (currentIndex > 0) {
          // Seek to the current position if we're not at the start
          await seekToName(currentIndex);
        }
      } else {
        await _audioPlayer.resume();
      }
      isPlaying = true;
    } catch (e) {
      print('Error playing audio: $e');
      // Attempt to recover by reinitializing
      await init();
      await _audioPlayer.play(AssetSource('${selectedReciter['audio']}'));
      if (currentIndex > 0) {
        await seekToName(currentIndex);
      }
      isPlaying = true;
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      isPlaying = false;
    } catch (e) {
      print('Error pausing audio: $e');
      // Handle error if needed
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      currentPosition = Duration.zero;
      isPlaying = false;
      // Don't reset currentIndex here to maintain the last position
    } catch (e) {
      print('Error stopping audio: $e');
      // Handle error if needed
    }
  }

  Future<void> seekToName(int index) async {
    if (names.isEmpty || index >= names.length) return;

    try {
      Map<String, dynamic> timestamp = names[index]['Timestamp'];
      await _audioPlayer.seek(Duration(
        minutes: timestamp['minute'],
        seconds: timestamp['second'],
        milliseconds: timestamp['millisecond'],
      ));
      currentIndex = index;
    } catch (e) {
      print('Error seeking to position: $e');
      // Handle error if needed
    }
  }

  // Optional: Add a method to reset the service state
  Future<void> reset() async {
    try {
      await stop();
      currentIndex = 0;
      currentPosition = Duration.zero;
      isPlaying = false;
    } catch (e) {
      print('Error resetting audio service: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
