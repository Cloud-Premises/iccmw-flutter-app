import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PrayerCardsWidget extends StatefulWidget {
  const PrayerCardsWidget({super.key});
  @override
  State<PrayerCardsWidget> createState() => _PrayerCardsWidgetState();
  // A method to reload prayers
  static void reloadPrayers() {
    final state =
        _PrayerCardsWidgetState._instance; // Access the singleton instance
    state?.setActiveMonth();
    (); // Call the setPrayer method
  }
}

class _PrayerCardsWidgetState extends State<PrayerCardsWidget> {
  static _PrayerCardsWidgetState? _instance; // Singleton instance

  // ignore: unused_field
  late String _currentImage;
  // ignore: unused_field
  late String _formattedDate;

  final Map<String, String> _prayerImages = {
    "Fajr": "assets/images/prayer/fajr.png",
    "Shuruq": "assets/images/prayer/shuruq.png",
    "Dhuhr": "assets/images/prayer/dhuhr.png",
    "Asr": "assets/images/prayer/asr.png",
    "Maghrib": "assets/images/prayer/maghrib.png",
    "Isha": "assets/images/prayer/isha.png",
    "prayer": "assets/images/prayer/isha.png"
  };

  String _activePrayer = '';
  String _activePrayerStartTime = '';
  String _activePrayerEndTime = '';
  String _activePrayerStartClock = '';
  String _activePrayerEndClock = '';
  // ignore: unused_field
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
  // ignore: unused_field
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

  Future<void> setActiveMonth() async {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE d MMMM yyyy');
    final formatterMonth = DateFormat('MMMM');
    final formatterYear = DateFormat('yyyy');
    _formattedDate = formatter.format(now);

    final jsonString = await PrayerTimeCache.fetchDataFromCache();
    final activeMonth = formatterMonth.format(now);
    final activeYear = formatterYear.format(now);
    final day = now.day.toString();

    // print(activeYear);

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
      final prayers = jsonData[activeYear][activeMonth][day];
      // print(prayers);
      final prayer = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
      for (int i = 0; i < prayer.length; i++) {
        String prayerStartTime =
            '${prayers[prayer[i]]['Adhaan']['time']} ${prayers[prayer[i]]['Adhaan']['clock']}';
        String prayerEndTime =
            '${prayers[prayer[i]]['Iqamah']['time']} ${prayers[prayer[i]]['Iqamah']['clock']}';

        DateTime prayerStartTimeRef = _parseTimeRef(prayerStartTime, now);
        DateTime prayerEndTimeRef = _parseTimeRef(prayerEndTime, now);

        if (prayerStartTimeRef.isAfter(now) && prayerEndTimeRef.isAfter(now)) {
          if (mounted) {
            setState(() {
              _prayerEvent = 'Next Prayer';
              _activePrayer = prayer[i];
              _activePrayerStartTime = prayers[prayer[i]]['Adhaan']['time'];
              _activePrayerEndTime = prayers[prayer[i]]['Iqamah']['time'];
              _activePrayerStartClock = prayers[prayer[i]]['Adhaan']['clock'];
              _activePrayerEndClock = prayers[prayer[i]]['Iqamah']['clock'];
              _isLoading = false; // Data loaded

              // Next Prayer
              _nextPrayer = prayer[i + 1];
              _nextPrayerStartTime = prayers[prayer[i + 1]]['Adhaan']['time'];
              _nextPrayerEndTime = prayers[prayer[i + 1]]['Iqamah']['time'];
              _nextPrayerStartClock = prayers[prayer[i + 1]]['Adhaan']['clock'];
              _nextPrayerEndClock = prayers[prayer[i]]['Iqamah']['clock'];
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
              _prayerEvent = 'Now Prayer';
              _activePrayer = prayer[i];
              _activePrayerStartTime = prayers[prayer[i]]['Adhaan']['time'];
              _activePrayerEndTime = prayers[prayer[i]]['Iqamah']['time'];
              _activePrayerStartClock = prayers[prayer[i]]['Adhaan']['clock'];
              _activePrayerEndClock = prayers[prayer[i]]['Iqamah']['clock'];
              _isLoading = false; // Data loaded

              // Next Prayer
              _nextPrayer = prayer[i + 1];
              _nextPrayerStartTime = prayers[prayer[i + 1]]['Adhaan']['time'];
              _nextPrayerEndTime = prayers[prayer[i + 1]]['Iqamah']['time'];
              _nextPrayerStartClock = prayers[prayer[i + 1]]['Adhaan']['clock'];
              _nextPrayerEndClock = prayers[prayer[i]]['Iqamah']['clock'];
            });
          }
          _startCountdown('$_activePrayerStartTime $_activePrayerStartClock',
              '$_activePrayerEndTime $_activePrayerEndClock'); // Start countdown here
          return;
        } else {
          if (mounted) {
            // print(prayer);
            DateTime tomorrow = now.add(Duration(days: 1));
            String tomorrowDay = tomorrow.day.toString();
            final prayersNextDay =
                jsonData[activeYear][activeMonth][tomorrowDay];
            // print(prayersNextDay);
            // Next Prayer
            // print(prayer[i]);
            // print(prayers[prayer[1]]);
            // print('_nextPrayerStartTime');
            // print(prayer[i + 1]);
            // prayer[i + 1];
            setState(() {
              // Next Prayer
              prayer[i + 1];

              _nextPrayer = prayer[0];
              _nextPrayerStartTime =
                  prayersNextDay[prayer[0]]['Adhaan']['time'];
              _nextPrayerStartClock =
                  prayersNextDay[prayer[0]]['Adhaan']['clock'];
              _nextPrayerEndTime = prayers[prayer[0]]['Iqamah']['time'];
              _nextPrayerEndClock = prayers[prayer[0]]['Iqamah']['clock'];
            });
          }
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
          _prayerEvent = 'Next Prayer';
        });
      }
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

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: GridView.count(
        crossAxisCount: 2, // Specify number of columns
        crossAxisSpacing: 20, // space between columns
        mainAxisSpacing: 20, // space between rows
        shrinkWrap: true, // Prevent the grid from taking up infinite height
        physics: NeverScrollableScrollPhysics(), // Disable scrolling
        children: [
          _buildPrayerCardStyleTwo(
            eventTitle: _prayerEvent,
            title: 'BEGINNING TIME',
            prayerName: _activePrayer == "" ? "$_nextPrayer" : _activePrayer,
            time: _activePrayer == ""
                ? "${_nextPrayerStartTime}"
                : "${_activePrayerStartTime} ",
            timeClock: _activePrayer == ""
                ? "${_nextPrayerStartClock}"
                : "${_activePrayerStartClock} ",
            endTime: '',
            gradientColors: [
              cardGradientColorOne,
              cardGradientColorTwo,
              // Color.fromRGBO(255, 240, 229, 1.5),
              // Color.fromRGBO(244, 194, 159, 0.8),
            ],
            imagePath: 'assets/images/home_page/masjidNow.png',
            textColor: headingColorLight,
          ),
          _buildPrayerCardStyleTwo(
            eventTitle: _prayerEvent,
            title: 'JAMMAT TIME',
            prayerName: _activePrayer == "" ? "$_nextPrayer" : _activePrayer,
            time: _activePrayer == ""
                ? "${_nextPrayerEndTime}"
                : "${_activePrayerEndTime} ",
            timeClock: _activePrayer == ""
                ? "${_nextPrayerEndClock}"
                : "${_activePrayerEndClock} ",
            endTime: '',
            gradientColors: [
              cardColor, cardColor,
              // Color.fromRGBO(242, 198, 167, 0.25),
              // Color.fromRGBO(242, 198, 167, 0.25),
            ],
            imagePath: 'assets/images/home_page/masjidNow.png',
            textColor: headingColorLight,
          )
          // _buildPrayerCard(
          //   title: 'Now Time is',
          //   prayerName: _activePrayer,
          //   time: "${_activePrayerStartTime} ",
          //   timeClock: "${_activePrayerEndClock}",
          //   endTime: '${_activePrayerEndTime} ${_activePrayerEndClock}',
          //   gradientColors: [
          //     Color.fromRGBO(255, 240, 229, 1.5),
          //     Color.fromRGBO(244, 194, 159, 0.8),
          //   ],
          //   imagePath: 'assets/images/home_page/masjidNow.png',
          //   textColor: Colors.orange,
          // ),
          // _buildPrayerCard(
          //   title: 'Next prayer is',
          //   prayerName: _nextPrayer,
          //   time: '${_nextPrayerStartTime}',
          //   timeClock: "${_nextPrayerStartClock}",
          //   endTime: '${_nextPrayerEndTime} ${_nextPrayerEndClock}',
          //   gradientColors: [
          //     Color.fromRGBO(242, 198, 167, 0.25),
          //     Color.fromRGBO(242, 198, 167, 0.25),
          //   ],
          //   imagePath: 'assets/images/home_page/masjid.png',
          //   textColor: Colors.orange,
          // ),
        ],
      ),
    );
  }

  Widget _buildPrayerCardStyleTwo({
    required String eventTitle,
    required String title,
    required String prayerName,
    required String time,
    required String timeClock,
    required String endTime,
    required List<Color> gradientColors,
    required String imagePath,
    required Color textColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(21),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
            stops: [0.0, 0.55], // Adjust as needed
          ),
        ),
        child: Stack(
          children: [
            // Positioned Image at the bottom
            Positioned.fill(
              bottom: 0,
              child: Image.asset(
                imagePath,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            // Content on top of the image
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventTitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        _prayerImages[prayerName] ?? '',
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 8),
                      Text(
                        prayerName,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: prayerName == 'Maghrib' ? 16 : 21,
                          fontWeight: FontWeight.bold,
                          color: headingColorFour,
                        ),
                      ),
                      // Image.asset(
                      //   _prayerImages[prayerName] ?? '',
                      //   height: 27,
                      //   fit: BoxFit.cover,
                      // ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'BEGINNING TIME',
                  //       style: TextStyle(
                  //         fontFamily: 'Poppins',
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black54,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        time.startsWith('0') ? time.substring(1) : time,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' $timeClock',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   'JAMMAT',
                  //   style: TextStyle(
                  //     fontFamily: 'Poppins',
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black54,
                  //   ),
                  // ),
                  Text(
                    endTime.startsWith('0') ? endTime.substring(1) : endTime,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [],
                  // ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: GridView.count(
          crossAxisCount: 2, // Specify number of columns
          crossAxisSpacing: 10, // Space between columns
          mainAxisSpacing: 10, // Space between rows
          shrinkWrap: true, // Prevent the grid from taking up infinite height
          physics: NeverScrollableScrollPhysics(), // Disable scrolling
          children: [
            _buildShimmerCard(),
            _buildShimmerCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
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
    );
  }
}
