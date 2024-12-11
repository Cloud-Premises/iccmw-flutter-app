import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iccmw/features/prayer_table/presentation/widgets/prayer_table_list/notification_icon_widget.dart';

class PrayerCardWidget extends StatefulWidget {
  final String prayerName;
  final String prayerStartTime; // Format: HH:mm
  final String prayerEndTime; // Format: HH:mm
  final bool isPrayer;

  const PrayerCardWidget({
    super.key,
    required this.prayerName,
    required this.prayerStartTime,
    required this.prayerEndTime,
    required this.isPrayer,
  });

  @override
  State<PrayerCardWidget> createState() => _PrayerCardWidgetState();
}

class _PrayerCardWidgetState extends State<PrayerCardWidget> {
  final Map<String, String> _prayerImages = {
    "Fajr": "assets/images/prayer/fajr.png",
    "Dhuhr": "assets/images/prayer/dhuhr.png",
    "Asr": "assets/images/prayer/asr.png",
    "Maghrib": "assets/images/prayer/maghrib.png",
    "Isha": "assets/images/prayer/isha.png",
  };

  late String prayerStartTimer;
  late String prayerEndTimer;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    prayerStartTimer = widget.isPrayer ? widget.prayerStartTime : '00:00:00';
    prayerEndTimer = widget.isPrayer ? widget.prayerEndTime : '00:00:00';

    if (!widget.isPrayer) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTimers();
    });
  }

  void _updateTimers() {
    DateTime now = DateTime.now();
    DateTime startTime = _parseTime(widget.prayerStartTime);
    DateTime endTime = _parseTime(widget.prayerEndTime);

    Duration startDiff =
        startTime.isAfter(now) ? startTime.difference(now) : Duration.zero;
    Duration endDiff =
        endTime.isAfter(now) ? endTime.difference(now) : Duration.zero;

    setState(() {
      prayerStartTimer = _formatDuration(startDiff);
      prayerEndTimer = _formatDuration(endDiff);
    });
  }

  DateTime _parseTime(String time) {
    try {
      List<String> parts = time.trim().split(':');
      if (parts.length != 2) throw FormatException('Invalid time format');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      // Determine AM or PM based on the prayer name
      if (widget.prayerName == "Fajr") {
        // Fajr is in AM
      } else {
        // Dhuhr, Asr, Maghrib, Isha are in PM
        if (hour < 12) hour += 12; // Convert to 24-hour format
      }
      return DateTime.now().copyWith(hour: hour, minute: minute, second: 0);
    } catch (e) {
      print('Error parsing time: $e');
      return DateTime.now(); // Fallback to current time in case of an error
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitsHours = twoDigits(duration.inHours);
    String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitsHours:$twoDigitsMinutes:$twoDigitsSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool currentPrayer = widget.isPrayer;
    Color containerColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: currentPrayer ? containerColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: currentPrayer
                ? containerColor.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Image.asset(
          _prayerImages[widget.prayerName] ?? '',
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.prayerName,
              style: TextStyle(
                fontSize: currentPrayer
                    ? widget.prayerName == 'Maghrib'
                        ? 17
                        : 19
                    : widget.prayerName == 'Maghrib'
                        ? 21
                        : 24,
                color: currentPrayer ? Colors.white : Colors.black,
              ),
            ),
            Column(
              children: [
                currentPrayer
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            prayerStartTimer,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            prayerEndTimer,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.prayerStartTime,
                      style: currentPrayer
                          ? const TextStyle(fontSize: 21, color: Colors.white)
                          : const TextStyle(fontSize: 21),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.prayerEndTime,
                      style: currentPrayer
                          ? const TextStyle(fontSize: 21, color: Colors.white)
                          : const TextStyle(fontSize: 21),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: NotificationIconWidget(
          prayerName: widget.prayerName,
          currentPrayer: currentPrayer,
        ),
      ),
    );
  }
}
