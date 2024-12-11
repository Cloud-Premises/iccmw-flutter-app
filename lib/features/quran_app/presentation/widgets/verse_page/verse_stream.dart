import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async'; // Import for StreamSubscription

class VerseStream extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String currentVerseText;
  final VoidCallback onPlayPause;
  final bool isPlaying;
  final VoidCallback onPlayNext;
  final VoidCallback onPlayPrevious;
  final int verseId;
  final int verseNumber;

  const VerseStream({
    super.key,
    required this.audioPlayer,
    required this.currentVerseText,
    required this.onPlayPause,
    required this.isPlaying,
    required this.onPlayNext,
    required this.onPlayPrevious,
    required this.verseId,
    required this.verseNumber,
  });

  @override
  _VerseStreamState createState() => _VerseStreamState();
}

class _VerseStreamState extends State<VerseStream> {
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isSeeking = false;
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<Duration> _durationSubscription;

  @override
  void initState() {
    super.initState();

    _positionSubscription =
        widget.audioPlayer.onPositionChanged.listen((position) {
      if (!_isSeeking) {
        setState(() {
          _position = position;
        });
      }
    });

    _durationSubscription =
        widget.audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    super.dispose();
  }

  void _onSeek(double value) {
    final newPosition = Duration(milliseconds: value.toInt());
    if (newPosition.inMilliseconds <= _duration.inMilliseconds) {
      widget.audioPlayer.seek(newPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final durationText = _formatDuration(_duration);
    final positionText = _formatDuration(_position);

    final sliderValue = _position.inMilliseconds
        .toDouble()
        .clamp(0.0, _duration.inMilliseconds.toDouble());
    final sliderMax = _duration.inMilliseconds.toDouble();

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                iconSize: 30,
                onPressed: widget.onPlayPrevious,
              ),
              IconButton(
                icon: Icon(widget.isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 30,
                onPressed: widget.onPlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                iconSize: 30,
                onPressed: widget.onPlayNext,
              ),
            ],
          ),
          Row(
            children: [
              Text(positionText, style: const TextStyle(fontSize: 14)),
              Expanded(
                child: Slider(
                  value: sliderValue,
                  max: sliderMax,
                  onChanged: (value) {
                    setState(() {
                      _isSeeking = true;
                    });
                    _onSeek(value);
                  },
                  onChangeEnd: (value) {
                    setState(() {
                      _isSeeking = false;
                    });
                  },
                ),
              ),
              Text(durationText, style: const TextStyle(fontSize: 14)),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         IconButton(
          //             icon: const Icon(Icons.bookmark), onPressed: () {}),
          //         const Text(
          //           'Bookmark',
          //           style: TextStyle(fontSize: 10),
          //         ),
          //       ],
          //     ),
          //     SizedBox(
          //       width: 6,
          //     ),
          //     Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         IconButton(
          //             icon: const Icon(Icons.bookmark_add_outlined),
          //             onPressed: () {}),
          //         const Text(
          //           'Add Bookmark',
          //           style: TextStyle(fontSize: 10),
          //         ),
          //       ],
          //     ),
          //     SizedBox(
          //       width: 6,
          //     ),
          //     Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         IconButton(
          //           icon: const Icon(Icons.person),
          //           onPressed: () {},
          //         ),
          //         const Text(
          //           'Reciters',
          //           style: TextStyle(fontSize: 10),
          //         ),
          //       ],
          //     ),
          //     SizedBox(
          //       width: 6,
          //     ),
          //     Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         IconButton(
          //           icon: const Icon(Icons.settings),
          //           onPressed: () {},
          //         ),
          //         const Text(
          //           'Settings',
          //           style: TextStyle(fontSize: 10),
          //         ),
          //       ],
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
