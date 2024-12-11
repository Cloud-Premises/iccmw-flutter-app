import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:iccmw/features/home_page/presentation/widgets/prayer_table/prayer_row_widget.dart';
import 'package:intl/intl.dart';
import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';

class PrayerListWidget extends StatefulWidget {
  final DateTime selectedDate;
  // final Map<String, dynamic> prayersMonthData;
  const PrayerListWidget({
    super.key,
    required this.selectedDate,
    // required this.prayersMonthData,
  });

  @override
  State<PrayerListWidget> createState() => _PrayerListWidgetState();

  // A method to reload prayers
  static void reloadPrayers() {
    final state =
        _PrayerListWidgetState._instance; // Access the singleton instance
    state?.setPrayer(); // Call the setPrayer method
  }
}

class _PrayerListWidgetState extends State<PrayerListWidget> {
  static _PrayerListWidgetState? _instance; // Singleton instance
  final prayerArray = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  final now = DateTime.now();
  DateTime date = DateTime.now();
  final formatter = DateFormat('EEEE d MMMM yyyy');
  final formatterDay = DateFormat('d');
  final formatterMonth = DateFormat('MMMM');
  final formatterYear = DateFormat('yyyy');
  late String nowDay = formatterDay.format(now);
  late String nowMonth = formatterMonth.format(now);
  late String nowYear = formatterYear.format(now);

  late Map<String, dynamic> prayersData = {};

  @override
  void initState() {
    super.initState();
    _instance = this; // Assign the instance

    // Initialize notification channel with sound
    // AwesomeNotifications().initialize(
    //   null,
    //   [
    //     NotificationChannel(
    //       channelGroupKey: 'iccmw_channel_group',
    //       channelKey: 'iccmw_channel',
    //       channelName: 'ICCMW Notification',
    //       channelDescription: 'ICCMW Notification Channel',
    //       defaultColor: Colors.green,
    //       importance: NotificationImportance.High,
    //       playSound: true,
    //       soundSource: 'azan', // For custom sound
    //       enableVibration: true,
    //     ),
    //   ],
    //   debug: true,
    // );
    // setPrayer();
    setPrayer().then((_) {
      schedulePrayerNotifications(); // Call after prayer data is loaded
    });
  }

  @override
  void dispose() {
    _instance = null; // Clear the instance when disposed
    super.dispose();
  }

  // Add this method outside of build
  DateTime _parseTimeRef(String time, DateTime referenceDate) {
    if (time.trim().isEmpty) {
      return referenceDate;
    }
    try {
      DateFormat timeFormat = DateFormat('hh:mm a');
      DateTime parsedTime = timeFormat.parse(time);
      return DateTime(referenceDate.year, referenceDate.month,
          referenceDate.day, parsedTime.hour, parsedTime.minute);
    } catch (e) {
      return referenceDate;
    }
  }

  void schedulePrayerNotifications() {
    if (!mounted) return;

    final now = DateTime.now();

    for (String prayer in prayerArray) {
      String prayerStartTime =
          '${prayersData[prayer]?['Adhaan']?['time']} ${prayersData[prayer]?['Adhaan']?['clock']}';

      // Skip if time string is empty
      if (prayerStartTime.trim().isEmpty) continue;

      DateTime prayerStartTimeRef = _parseTimeRef(prayerStartTime, now);

      // Schedule notification only if prayer time is in the future today
      if (prayerStartTimeRef.isAfter(now) &&
          prayerStartTimeRef.day == now.day &&
          prayerStartTimeRef.month == now.month &&
          prayerStartTimeRef.year == now.year) {
        int notificationId = prayerArray.indexOf(prayer) + 1;

        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notificationId,
            channelKey: prayer == "Fajr"
                ? "iccmw_channel_fajrazan"
                : 'iccmw_channel_azan',
            title: "Prayer Time",
            body: "It's prayer time for $prayer",
            notificationLayout: NotificationLayout.Default,
            criticalAlert: true,
            wakeUpScreen: true,
            category: NotificationCategory.Alarm,
            // customSound:  'resource://raw/azan_audio',
          ),
          schedule: NotificationCalendar(
            day: prayerStartTimeRef.day,
            hour: prayerStartTimeRef.hour,
            minute: prayerStartTimeRef.minute,
            second: 0,
            millisecond: 0,
            repeats: false,
            preciseAlarm: true,
          ),
        );
      }
    }
  }

  // void schedulePrayerNotifications() {
  //   if (!mounted) return;

  //   final now = DateTime.now();

  //   for (String prayer in prayerArray) {
  //     String prayerStartTime =
  //         '${prayersData[prayer]?['Adhaan']?['time']} ${prayersData[prayer]?['Adhaan']?['clock']}';

  //     // Skip if time string is empty
  //     if (prayerStartTime.trim().isEmpty) continue;

  //     DateTime prayerStartTimeRef = _parseTimeRef(prayerStartTime, now);

  //     // Schedule notification only if prayer time is in the future today
  //     if (prayerStartTimeRef.isAfter(now) &&
  //         prayerStartTimeRef.day == now.day &&
  //         prayerStartTimeRef.month == now.month &&
  //         prayerStartTimeRef.year == now.year) {
  //       int notificationId = prayerArray.indexOf(prayer) + 1;

  //       AwesomeNotifications().createNotification(
  //         content: NotificationContent(
  //           id: notificationId,
  //           channelKey: 'iccmw_channel',
  //           title: "Prayer Time",
  //           body: "It's prayer time for $prayer",
  //           notificationLayout: NotificationLayout.Default,
  //         ),
  //         schedule: NotificationCalendar(
  //           hour: prayerStartTimeRef.hour,
  //           minute: prayerStartTimeRef.minute,
  //           second: 0,
  //           millisecond: 0,
  //           repeats: false,
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<void> setPrayer() async {
    final jsonString = await PrayerTimeCache.fetchDataFromCache();
    if (jsonString == null) {
      return;
    }
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    try {
      // Format the date components
      final String activeMonth =
          DateFormat('MMMM').format(widget.selectedDate); // Full month name
      final String activeYear =
          DateFormat('yyyy').format(widget.selectedDate); // Year
      final String activeDay =
          DateFormat('d').format(widget.selectedDate); // Day of the month

      setState(() {
        prayersData = jsonData[activeYear][activeMonth][activeDay];
        // print(prayersData);
      });
    } catch (e) {
      // Handle error
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
// Helper function to convert month number to name
    final String activeMonth =
        DateFormat('MMMM').format(widget.selectedDate); // Full month name
    final String activeYear =
        DateFormat('yyyy').format(widget.selectedDate); // Year
    final String activeDay = widget.selectedDate.day.toString();
    final now = DateTime.now();

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
    // DateTime _parseTimeRef(String time, DateTime referenceDate) {
    //   try {
    //     if (time.isEmpty) throw FormatException("Empty time string");

    //     DateFormat timeFormat = DateFormat('hh:mm a');
    //     DateTime parsedTime = timeFormat.parse(time);

    //     return DateTime(referenceDate.year, referenceDate.month,
    //         referenceDate.day, parsedTime.hour, parsedTime.minute);
    //   } catch (e) {
    //     // debugPrint("Error parsing time: $e");
    //     return DateTime(
    //         referenceDate.year, referenceDate.month, referenceDate.day, 0, 0);
    //   }
    // }

    // DateTime _parseTimeRef(String time, DateTime referenceDate) {
    //   try {
    //     if (time.isEmpty || time == '00:00') {
    //       // Handle empty or default time (optional: return current date or fallback time)
    //       return DateTime(
    //           referenceDate.year, referenceDate.month, referenceDate.day, 0, 0);
    //     }

    //     DateFormat timeFormat = DateFormat('hh:mm a');
    //     DateTime parsedTime = timeFormat.parse(time);

    //     return DateTime(referenceDate.year, referenceDate.month,
    //         referenceDate.day, parsedTime.hour, parsedTime.minute);
    //   } catch (e) {
    //     // debugPrint("Error parsing time: $e");
    //     return DateTime(
    //         referenceDate.year, referenceDate.month, referenceDate.day, 0, 0);
    //   }
    // }

    String getTimeCounter(DateTime currentTime, DateTime targetTime) {
      Duration duration = targetTime.difference(currentTime);

      if (duration.isNegative) {
        return "00:00";
      }

      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String hours = twoDigits(duration.inHours);
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      String seconds = twoDigits(duration.inSeconds.remainder(60));

      return "$hours:$minutes:$seconds";
    }

    String fajrStartTime = '00:00';
    String shuruqStartTime = '00:00';
    String dhuhrStartTime = '00:00';
    String asrStartTime = '00:00';
    String maghribStartTime = '00:00';
    String ishaStartTime = '00:00';

    String fajrEndTime = '00:00';
    String dhuhrEndTime = '00:00';
    String asrEndTime = '00:00';
    String maghribEndTime = '00:00';
    String ishaEndTime = '00:00';

    String fajrStartClock = '';
    String shuruqStartClock = '';
    String dhuhrStartClock = '';
    String asrStartClock = '';
    String maghribStartClock = '';
    String ishaStartClock = '';

    String fajrEndClock = '';
    String dhuhrEndClock = '';
    String asrEndClock = '';
    String maghribEndClock = '';
    String ishaEndClock = '';

    bool isFajrPrayer = false;
    bool isShuruqPrayer = false;
    bool isDhuhrPrayer = false;
    bool isAsrPrayer = false;
    bool isMaghribPrayer = false;
    bool isIshaPrayer = false;
    // final prayerArray = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    // ignore: unused_local_variable
    String prayerStartTimer = '00:00:00';

    // ignore: unused_local_variable
    String prayerEndTimer = '00:00:00';

    void prayerTime(prayerDay, activeMonth, activeYear) {
      fajrStartTime = prayersData['Fajr']?['Adhaan']?['time'] ?? '00:00';
      fajrStartClock = prayersData['Fajr']?['Adhaan']?['clock'] ?? '';

      shuruqStartTime = prayersData['Sunrise']?['time'] ?? '00:00';
      shuruqStartClock = prayersData['Sunrise']?['clock'] ?? '';

      dhuhrStartTime = prayersData['Dhuhr']?['Adhaan']?['time'] ?? '00:00';
      dhuhrStartClock = prayersData['Dhuhr']?['Adhaan']?['clock'] ?? '';

      asrStartTime = prayersData['Asr']?['Adhaan']?['time'] ?? '00:00';
      asrStartClock = prayersData['Asr']?['Adhaan']?['clock'] ?? '';

      maghribStartTime = prayersData['Maghrib']?['Adhaan']?['time'] ?? '00:00';
      maghribStartClock = prayersData['Maghrib']?['Adhaan']?['clock'] ?? '';

      ishaStartTime = prayersData['Isha']?['Adhaan']?['time'] ?? '00:00';
      ishaStartClock = prayersData['Isha']?['Adhaan']?['clock'] ?? '';

      fajrEndTime = prayersData['Fajr']?['Iqamah']?['time'] ?? '00:00';
      fajrEndClock = prayersData['Fajr']?['Iqamah']?['clock'] ?? '';

      dhuhrEndTime = prayersData['Dhuhr']?['Iqamah']?['time'] ?? '00:00';
      dhuhrEndClock = prayersData['Dhuhr']?['Iqamah']?['clock'] ?? '';

      asrEndTime = prayersData['Asr']?['Iqamah']?['time'] ?? '00:00';
      asrEndClock = prayersData['Asr']?['Iqamah']?['clock'] ?? '';

      maghribEndTime = prayersData['Maghrib']?['Iqamah']?['time'] ?? '00:00';
      maghribEndClock = prayersData['Maghrib']?['Iqamah']?['clock'] ?? '';

      ishaEndTime = prayersData['Isha']?['Iqamah']?['time'] ?? '00:00';
      ishaEndClock = prayersData['Isha']?['Iqamah']?['clock'] ?? '';

      for (int i = 0; i < prayerArray.length; i++) {
        String prayerStartTime =
            '${prayersData[prayerArray[i]]?['Adhaan']?['time']} ${prayersData[prayerArray[i]]?['Adhaan']?['clock']}';
        String prayerEndTime =
            '${prayersData[prayerArray[i]]?['Iqamah']?['time']} ${prayersData[prayerArray[i]]?['Iqamah']?['clock']}';
        // print(prayerStartTime);

        // Check if time string is null or empty before parsing
        if (prayerStartTime.isEmpty || prayerEndTime.isEmpty) {
          continue; // Skip this prayer or handle it accordingly
        }
        final String specificTimeOne =
            "${ishaEndTime = prayersData['Isha']?['Iqamah']?['time'] ?? '00:00'} ${ishaEndClock = prayersData['Isha']?['Iqamah']?['clock'] ?? ''}";
        final String specificTimeTwo = "11:59 PM";
        DateTime prayerStartTimeRef = _parseTimeRef(prayerStartTime, now);
        // print(prayerStartTimeRef);
        DateTime prayerEndTimeRef = _parseTimeRef(prayerEndTime, now);

        DateTime timeOne = _parseTimeRef(specificTimeOne, now);
        DateTime timeTwo = _parseTimeRef(specificTimeTwo, now);
        // print(timeOne);
        // print(timeOne.isBefore(now) && timeTwo.isAfter(now));
        // DateTime sunriseTimeRef =
        //     _parseTimeRef(prayersData['Sunrise']?['time'], now);

        // if (sunriseTimeRef.isAtSameMomentAs(now) ||
        //     sunriseTimeRef.isAfter(now)) {
        //   isShuruqPrayer = true;
        //   prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
        // }
        if (prayerStartTimeRef.isAtSameMomentAs(now) ||
            (prayerStartTimeRef.isBefore(now) &&
                prayerEndTimeRef.isAfter(now))) {
          if (nowDay == activeDay &&
              nowMonth == activeMonth &&
              nowYear == activeYear) {
            switch (prayerArray[i]) {
              case 'Fajr':
                isFajrPrayer = true;
                prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Shuruq':
                isShuruqPrayer = true;
                prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Dhuhr':
                isDhuhrPrayer = true;
                prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Asr':
                isAsrPrayer = true;
                prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Maghrib':
                isMaghribPrayer = true;
                prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Isha':
                isIshaPrayer = true;
                prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
            }
          }
        } else if (prayerStartTimeRef.isAfter(now) &&
            prayerEndTimeRef.isAfter(now)) {
          // print(month == nowMonth);
          // print(month);
          // print(activeMonth);
          if (nowDay == activeDay &&
              nowMonth == activeMonth &&
              nowYear == activeYear) {
            switch (prayerArray[i]) {
              case 'Fajr':
                isFajrPrayer = true;
                prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Shuruq':
                isShuruqPrayer = true;
                prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Dhuhr':
                isDhuhrPrayer = true;
                prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Asr':
                isAsrPrayer = true;
                prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Maghrib':
                isMaghribPrayer = true;
                prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
              case 'Isha':
                isIshaPrayer = true;
                prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
                return;
            }
          }
        } else if (timeOne.isBefore(now) && timeTwo.isAfter(now)) {
          int nowDayInt = int.parse(nowDay);
          nowDayInt += 1;
          String nowDayStr = nowDayInt.toString();
          if (nowDayStr == activeDay &&
              nowMonth == activeMonth &&
              nowYear == activeYear) {
            isFajrPrayer = true;
          }
        }
      }
    }

    // if (prayersData[year].containsKey(month) &&
    //     prayersData[year][month].containsKey(day)) {
    //   prayerTime(day);
    // }
    if (mounted) {
      prayerTime(activeDay, activeMonth, activeYear);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Row(
                  children: [
                    Text(
                      'BEGINNING TIME',
                      style: TextStyle(
                        fontFamily: 'Intern',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 42,
                    ),
                    Text(
                      'JAMMAT',
                      style: TextStyle(
                          fontFamily: 'Intern',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: const Color.fromRGBO(255, 152, 0, 0.7),
          ),
          PrayerRowWidget(
            prayerName: "Fajr",
            prayerStartTime: '$fajrStartTime $fajrStartClock',
            prayerEndTime: '$fajrEndTime $fajrEndClock',
            isPrayer: isFajrPrayer,
          ),
          PrayerRowWidget(
            prayerName: "Shuruq",
            prayerStartTime: '$shuruqStartTime $shuruqStartClock',
            prayerEndTime: '',
            isPrayer: isShuruqPrayer,
          ),
          PrayerRowWidget(
            prayerName: "Dhuhr",
            prayerStartTime: '$dhuhrStartTime $dhuhrStartClock',
            prayerEndTime: '$dhuhrEndTime $dhuhrEndClock',
            isPrayer: isDhuhrPrayer,
          ),
          PrayerRowWidget(
            prayerName: "Asr",
            prayerStartTime: '$asrStartTime $asrStartClock',
            prayerEndTime: '$asrEndTime $asrEndClock',
            isPrayer: isAsrPrayer,
          ),
          PrayerRowWidget(
            prayerName: "Maghrib",
            prayerStartTime: '$maghribStartTime $maghribStartClock',
            prayerEndTime: '$maghribEndTime $maghribEndClock',
            isPrayer: isMaghribPrayer,
          ),
          PrayerRowWidget(
            prayerName: "Isha",
            prayerStartTime: '$ishaStartTime $ishaStartClock',
            prayerEndTime: '$ishaEndTime $ishaEndClock',
            isPrayer: isIshaPrayer,
          ),
        ],
      ),
    );
  }
}
