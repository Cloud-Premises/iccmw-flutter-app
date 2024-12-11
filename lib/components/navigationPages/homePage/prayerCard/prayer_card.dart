import 'dart:async';
import 'dart:convert'; // For decoding JSON
import 'package:flutter/material.dart';
import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class PrayerCard extends StatefulWidget {
  const PrayerCard({Key? key}) : super(key: key);

  @override
  State<PrayerCard> createState() => PrayerCardState();
}

class PrayerCardState extends State<PrayerCard> {
  late String _currentImage;
  late String _formattedDate;

  String _activePrayer = '';
  String _activePrayerStartTime = '';
  String _activePrayerEndTime = '';
  String _activePrayerStartClock = '';
  String _activePrayerEndClock = '';
  String _prayerEvent = '';

  // ignore: unused_field
  String _nextPrayer = '';
  // ignore: unused_field
  String _nextPrayerStartTime = '';
  // ignore: unused_field
  String _nextPrayerEndTime = '';
  // ignore: unused_field
  String _nextPrayerStartClock = '';
  // ignore: unused_field
  String _nextPrayerEndClock = '';

  final Map<String, String> cardImages = {
    'day': 'assets/images/card/day.png',
    'sunset': 'assets/images/card/sunset.png',
    'halfMoonNight': 'assets/images/card/halfMoonNight.png',
    'fullMoonNight': 'assets/images/card/fullMoonNight.png',
  };

  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();

    // Delay to set the current image and active month
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Exit if the widget is no longer mounted
      setCurrentImage();
      setActiveMonth();
      // setCardVisibility(context); // Uncomment if needed
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Formats a [Duration] into a HH:MM:SS string.
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  /// Sets the current image based on the current hour.
  Future<void> setCurrentImage() async {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 18) {
      _currentImage = cardImages['day']!;
    } else if (hour >= 18 && hour < 20) {
      _currentImage = cardImages['sunset']!;
    } else if (hour >= 20 && hour < 22) {
      _currentImage = cardImages['halfMoonNight']!;
    } else {
      _currentImage = cardImages['fullMoonNight']!;
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Sets the active prayer based on the current date and time.
  Future<void> setActiveMonth() async {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE d MMMM yyyy');
    final formatterMonth = DateFormat('MMMM');
    _formattedDate = formatter.format(now);

    final jsonString = await PrayerTimeCache.fetchDataFromCache();
    final activeMonth = formatterMonth.format(now);
    final day = now.day.toString();

    if (jsonString == null) {
      if (mounted) {
        setState(() {
          _isLoading = false; // Data loaded
          _prayerEvent = 'No Data Available';
        });
      }
      return;
    }

    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    try {
      final prayers = jsonData[activeMonth][day];

      final prayer = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
      for (int i = 0; i < prayer.length; i++) {
        String prayerStartTime =
            '${prayers[prayer[i]]['start']['time']} ${prayers[prayer[i]]['start']['clock']}';
        String prayerEndTime =
            '${prayers[prayer[i]]['end']['time']} ${prayers[prayer[i]]['end']['clock']}';

        DateTime prayerStartTimeRef = _parseTimeRef(prayerStartTime, now);
        DateTime prayerEndTimeRef = _parseTimeRef(prayerEndTime, now);

        // if(){

        // if(mounted){
        //   // Set the active prayer based on the current date and time
        //   setState(() {
        //   });
        // }
        // }

        if (prayerStartTimeRef.isAfter(now) && prayerEndTimeRef.isAfter(now)) {
          if (mounted) {
            setState(() {
              _prayerEvent = 'Upcoming Prayer';
              _activePrayer = prayer[i];
              _activePrayerStartTime = prayers[prayer[i]]['start']['time'];
              _activePrayerEndTime = prayers[prayer[i]]['end']['time'];
              _activePrayerStartClock = prayers[prayer[i]]['start']['clock'];
              _activePrayerEndClock = prayers[prayer[i]]['end']['clock'];
              _isLoading = false; // Data loaded
            });
          }
          _startCountdown('$_activePrayerStartTime $_activePrayerStartClock',
              '$_activePrayerEndTime $_activePrayerEndClock'); // Start countdown here
          return;
        } else if (prayerStartTimeRef.isAtSameMomentAs(now) ||
            (prayerStartTimeRef.isBefore(now) &&
                prayerEndTimeRef.isAfter(now))) {
          if (mounted) {
            setState(() {
              _prayerEvent = 'Now Prayer Time';
              _activePrayer = prayer[i];
              _activePrayerStartTime = prayers[prayer[i]]['start']['time'];
              _activePrayerEndTime = prayers[prayer[i]]['end']['time'];
              _activePrayerStartClock = prayers[prayer[i]]['start']['clock'];
              _activePrayerEndClock = prayers[prayer[i]]['end']['clock'];
              _isLoading = false; // Data loaded
            });
          }
          _startCountdown('$_activePrayerStartTime $_activePrayerStartClock',
              '$_activePrayerEndTime $_activePrayerEndClock'); // Start countdown here
          return;
        }
      }

      // If no prayer time matches, update the state accordingly
      if (mounted) {
        setState(() {
          _isLoading = true;
          _prayerEvent = 'No Upcoming Prayers';
        });
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        setState(() {
          _isLoading = false; // Data loaded with error
          _prayerEvent = 'Error Loading Prayers';
        });
      }
    }
  }

  /// Parses a time string into a [DateTime] object based on a reference date.
  DateTime _parseTimeRef(String time, DateTime referenceDate) {
    if (time.trim().isEmpty) {
      return referenceDate;
    }
    try {
      DateFormat timeFormat = DateFormat('hh:mm a');
      DateTime parsedTime = timeFormat.parse(time);
      int hour = parsedTime.hour;
      int minute = parsedTime.minute;
      return DateTime(referenceDate.year, referenceDate.month,
          referenceDate.day, hour, minute);
    } catch (e) {
      return referenceDate;
    }
  }

  /// Calculates and updates the remaining time until the next prayer time.
  void _calculateRemainingTime(String startTime, String endTime) {
    DateTime now = DateTime.now();
    DateTime startTimeRef = _parseTimeRef(startTime, now);
    DateTime endTimeRef = _parseTimeRef(endTime, now);

    if (mounted) {
      if (startTimeRef.isAfter(now)) {
        setState(() {
          _remainingTime = startTimeRef.difference(now);
        });
      } else {
        setState(() {
          _remainingTime = endTimeRef.difference(now);
        });
      }
    }
  }

  /// Starts a countdown timer between [startTime] and [endTime].
  void _startCountdown(String startTime, String endTime) {
    _calculateRemainingTime(startTime, endTime);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      _calculateRemainingTime(startTime, endTime);

      if (_remainingTime.isNegative || _remainingTime == Duration.zero) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _remainingTime = Duration.zero;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildShimmerEffect();
    }

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        // height: 140.0,
        width: double.infinity,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                _currentImage,
                width: double.infinity,
                height: 145.0,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                // color: Colors.black.withOpacity(0.6),
                color: Colors.black.withOpacity(0.4),
                // color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15.0),
              ),
              height: 145.0,
              width: double.infinity,
            ),
            Positioned(
              left: 16.0,
              top: 0.0,
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formattedDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _activePrayer,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          children: [
                            Text(
                              _prayerEvent,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildPrayerTime('From', _activePrayerStartTime,
                            _activePrayerStartClock),
                        const SizedBox(width: 6.0),
                        const Text('—',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0)),
                        const SizedBox(width: 8.0),
                        _buildPrayerTime(
                            'To', _activePrayerEndTime, _activePrayerEndClock),
                        const SizedBox(width: 16.0),
                        _buildTimeCounter(
                          '$_activePrayerStartTime $_activePrayerStartClock',
                          '$_activePrayerEndTime $_activePrayerEndClock',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the shimmer effect displayed while data is loading.
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 125.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 8.0),
              Container(
                width: 200,
                height: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 8.0),
              Container(
                width: 125,
                height: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the prayer time section with a label and time.
  Widget _buildPrayerTime(String label, String time, String clock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
        Row(
          children: [
            Text(
              time,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              clock,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the countdown timer displaying remaining time.
  Widget _buildTimeCounter(String startTime, String endTime) {
    DateTime now = DateTime.now();
    DateTime startTimeRef = _parseTimeRef(startTime, now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          startTimeRef.isAfter(now) ? 'Start in' : 'End in',
          style: const TextStyle(color: Colors.white, fontSize: 12.0),
        ),
        Text(
          _formatDuration(_remainingTime),
          style: const TextStyle(
              color: Colors.white, fontSize: 21.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
