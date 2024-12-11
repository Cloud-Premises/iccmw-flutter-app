// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/prayer_table/prayer_row_widget.dart';
// import 'package:intl/intl.dart';
// import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';

// class PrayerListWidget extends StatefulWidget {
//   const PrayerListWidget({super.key});

//   @override
//   State<PrayerListWidget> createState() => _PrayerListWidgetState();

//   // A method to reload prayers
//   static void reloadPrayers() {
//     final state =
//         _PrayerListWidgetState._instance; // Access the singleton instance
//     state?.setPrayer(); // Call the setPrayer method
//   }
// }

// class _PrayerListWidgetState extends State<PrayerListWidget> {
//   static _PrayerListWidgetState? _instance; // Singleton instance

//   final now = DateTime.now();
//   DateTime date = DateTime.now();
//   final formatter = DateFormat('EEEE d MMMM yyyy');
//   final formatterDay = DateFormat('d');
//   late String nowDay = formatterDay.format(now);

//   late Map<String, dynamic> prayersData = {};
//   final List<DateTime> dates = List.generate(
//     45,
//     (index) => DateTime.now().add(Duration(days: index - 0)),
//   );

//   @override
//   void initState() {
//     super.initState();
//     _instance = this; // Assign the instance
//     setPrayer();
//   }

//   @override
//   void dispose() {
//     _instance = null; // Clear the instance when disposed
//     super.dispose();
//   }

//   Future<void> setPrayer() async {
//     final jsonString = await PrayerTimeCache.fetchDataFromCache();
//     if (jsonString == null) {
//       return;
//     }

//     setState(() {
//       prayersData = jsonDecode(jsonString);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final now = date;
//     final formatterMonth = DateFormat('MMMM');
//     String day = now.day.toString();
//     String month = formatterMonth.format(now);

//     DateTime _parseTimeRef(String time, DateTime referenceDate) {
//       DateFormat timeFormat = DateFormat('hh:mm a');
//       DateTime parsedTime = timeFormat.parse(time);

//       int hour = parsedTime.hour;
//       int minute = parsedTime.minute;

//       return DateTime(referenceDate.year, referenceDate.month,
//           referenceDate.day, hour, minute);
//     }

//     String getTimeCounter(DateTime currentTime, DateTime targetTime) {
//       Duration duration = targetTime.difference(currentTime);

//       if (duration.isNegative) {
//         return "00:00";
//       }

//       String twoDigits(int n) => n.toString().padLeft(2, '0');
//       String hours = twoDigits(duration.inHours);
//       String minutes = twoDigits(duration.inMinutes.remainder(60));
//       String seconds = twoDigits(duration.inSeconds.remainder(60));

//       return "$hours:$minutes:$seconds";
//     }

//     String FajrStartTime = '00:00';
//     String dhuhrStartTime = '00:00';
//     String asrStartTime = '00:00';
//     String maghribStartTime = '00:00';
//     String ishaStartTime = '00:00';

//     String FajrEndTime = '00:00';
//     String dhuhrEndTime = '00:00';
//     String asrEndTime = '00:00';
//     String maghribEndTime = '00:00';
//     String ishaEndTime = '00:00';

//     final prayerArray = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
//     bool isFajrPrayer = false;
//     bool isDhuhrPrayer = false;
//     bool isAsrPrayer = false;
//     bool isMaghribPrayer = false;
//     bool isIshaPrayer = false;

//     String prayerStartTimer = '00:00:00';
//     String prayerEndTimer = '00:00:00';

//     void prayerTime(prayerDay) {
//       FajrStartTime =
//           prayersData[year][month][prayerDay]['Fajr']?['Adhaan']?['time'] ?? '00:00';
//       dhuhrStartTime =
//           prayersData[year][month][prayerDay]['Dhuhr']?['Adhaan']?['time'] ?? '00:00';
//       asrStartTime =
//           prayersData[year][month][prayerDay]['Asr']?['Adhaan']?['time'] ?? '00:00';
//       maghribStartTime = prayersData[year][month][prayerDay]['Maghrib']?['Adhaan']
//               ?['time'] ??
//           '00:00';
//       ishaStartTime =
//           prayersData[year][month][prayerDay]['Isha']?['Adhaan']?['time'] ?? '00:00';

//       FajrEndTime =
//           prayersData[year][month][prayerDay]['Fajr']?['Iqamah']?['time'] ?? '00:00';
//       dhuhrEndTime =
//           prayersData[year][month][prayerDay]['Dhuhr']?['Iqamah']?['time'] ?? '00:00';
//       asrEndTime =
//           prayersData[year][month][prayerDay]['Asr']?['Iqamah']?['time'] ?? '00:00';
//       maghribEndTime =
//           prayersData[year][month][prayerDay]['Maghrib']?['Iqamah']?['time'] ?? '00:00';
//       ishaEndTime =
//           prayersData[year][month][prayerDay]['Isha']?['Iqamah']?['time'] ?? '00:00';

//       for (int i = 0; i < prayerArray.length; i++) {
//         String prayerStartTime =
//             '${prayersData[year][month][prayerDay][prayerArray[i]]?['Adhaan']?['time']} ${prayersData[year][month][prayerDay][prayerArray[i]]?['Adhaan']?['clock']}';
//         String prayerEndTime =
//             '${prayersData[year][month][prayerDay][prayerArray[i]]?['Iqamah']?['time']} ${prayersData[year][month][prayerDay][prayerArray[i]]?['Iqamah']?['clock']}';

//         DateTime prayerStartTimeRef = _parseTimeRef(prayerStartTime, now);
//         DateTime prayerEndTimeRef = _parseTimeRef(prayerEndTime, now);

//         if (prayerStartTimeRef.isAtSameMomentAs(now) ||
//             (prayerStartTimeRef.isBefore(now) &&
//                 prayerEndTimeRef.isAfter(now))) {
//           if (day == nowDay) {
//             switch (prayerArray[i]) {
//               case 'Fajr':
//                 isFajrPrayer = true;
//                 prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//               case 'Dhuhr':
//                 isDhuhrPrayer = true;
//                 prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//               case 'Asr':
//                 isAsrPrayer = true;
//                 prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//               case 'Maghrib':
//                 isMaghribPrayer = true;
//                 prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//               case 'Isha':
//                 isIshaPrayer = true;
//                 prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//             }
//           }
//         } else if (prayerStartTimeRef.isAfter(now) &&
//             prayerEndTimeRef.isAfter(now)) {
//           if (day == nowDay) {
//             switch (prayerArray[i]) {
//               case 'Fajr':
//                 isFajrPrayer = true;
//                 prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//               case 'Dhuhr':
//                 isDhuhrPrayer = true;
//                 prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//               case 'Asr':
//                 isAsrPrayer = true;
//                 prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//               case 'Maghrib':
//                 isMaghribPrayer = true;
//                 prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//               case 'Isha':
//                 isIshaPrayer = true;
//                 prayerStartTimer = getTimeCounter(now, prayerEndTimeRef);
//                 return;
//             }
//           }
//         }
//       }
//     }

//     if (prayersData.containsKey(month) && prayersData[year][month].containsKey(day)) {
//       prayerTime(day);
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           PrayerRowWidget(
//             prayerName: "Fajr",
//             prayerStartTime: FajrStartTime,
//             prayerEndTime: FajrEndTime,
//             isPrayer: isFajrPrayer,
//           ),
//           PrayerRowWidget(
//             prayerName: "Dhuhr",
//             prayerStartTime: dhuhrStartTime,
//             prayerEndTime: dhuhrEndTime,
//             isPrayer: isDhuhrPrayer,
//           ),
//           PrayerRowWidget(
//             prayerName: "Asr",
//             prayerStartTime: asrStartTime,
//             prayerEndTime: asrEndTime,
//             isPrayer: isAsrPrayer,
//           ),
//           PrayerRowWidget(
//             prayerName: "Maghrib",
//             prayerStartTime: maghribStartTime,
//             prayerEndTime: maghribEndTime,
//             isPrayer: isMaghribPrayer,
//           ),
//           PrayerRowWidget(
//             prayerName: "Isha",
//             prayerStartTime: ishaStartTime,
//             prayerEndTime: ishaEndTime,
//             isPrayer: isIshaPrayer,
//           ),
//         ],
//       ),
//     );
//   }
// }
// prayer_list_widget.dart

import 'dart:convert';
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
  final List<DateTime> dates = List.generate(
    45,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  void initState() {
    super.initState();
    _instance = this; // Assign the instance
    setPrayer();
  }

  @override
  void dispose() {
    _instance = null; // Clear the instance when disposed
    super.dispose();
  }

  Future<void> setPrayer() async {
    final jsonString = await PrayerTimeCache.fetchDataFromCache();
    if (jsonString == null) {
      return;
    }

    setState(() {
      prayersData = jsonDecode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final now = widget.selectedDate;
    // final now = DateTime.now();
    // final formatterMonth = DateFormat('MMMM');
    // final formatterYear = DateFormat('yyyy');

    // String day = now.day.toString();
    // String month = formatterMonth.format(now);
    // String year = formatterYear.format(now);
    String _getMonthName(int month) {
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return months[month - 1];
    }

    DateTime currentDate = DateTime.parse('${widget.selectedDate}');

    String year = currentDate.year.toString();
    String month = _getMonthName(currentDate.month);
    String day = currentDate.day.toString().padLeft(1, '0');

    // print(prayersData['2024']['November'][1]);

// Helper function to convert month number to name

    DateTime _parseTimeRef(String time, DateTime referenceDate) {
      try {
        if (time.isEmpty) throw FormatException("Empty time string");

        DateFormat timeFormat = DateFormat('hh:mm a');
        DateTime parsedTime = timeFormat.parse(time);

        return DateTime(referenceDate.year, referenceDate.month,
            referenceDate.day, parsedTime.hour, parsedTime.minute);
      } catch (e) {
        debugPrint("Error parsing time: $e");
        return DateTime(
            referenceDate.year, referenceDate.month, referenceDate.day, 0, 0);
      }
    }

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

    String FajrStartTime = '00:00';
    String dhuhrStartTime = '00:00';
    String asrStartTime = '00:00';
    String maghribStartTime = '00:00';
    String ishaStartTime = '00:00';

    String FajrEndTime = '00:00';
    String dhuhrEndTime = '00:00';
    String asrEndTime = '00:00';
    String maghribEndTime = '00:00';
    String ishaEndTime = '00:00';

    final prayerArray = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    bool isFajrPrayer = false;
    bool isDhuhrPrayer = false;
    bool isAsrPrayer = false;
    bool isMaghribPrayer = false;
    bool isIshaPrayer = false;

    // ignore: unused_local_variable
    String prayerStartTimer = '00:00:00';

    // ignore: unused_local_variable
    String prayerEndTimer = '00:00:00';

    void prayerTime(prayerDay) {
      FajrStartTime = prayersData[year][month][prayerDay]['Fajr']?['Adhaan']
              ?['time'] ??
          '00:00';

      dhuhrStartTime = prayersData[year][month][prayerDay]['Dhuhr']?['Adhaan']
              ?['time'] ??
          '00:00';
      asrStartTime = prayersData[year][month][prayerDay]['Asr']?['Adhaan']
              ?['time'] ??
          '00:00';
      maghribStartTime = prayersData[year][month][prayerDay]['Maghrib']
              ?['Adhaan']?['time'] ??
          '00:00';
      ishaStartTime = prayersData[year][month][prayerDay]['Isha']?['Adhaan']
              ?['time'] ??
          '00:00';

      FajrEndTime = prayersData[year][month][prayerDay]['Fajr']?['Iqamah']
              ?['time'] ??
          '00:00';
      dhuhrEndTime = prayersData[year][month][prayerDay]['Dhuhr']?['Iqamah']
              ?['time'] ??
          '00:00';
      asrEndTime = prayersData[year][month][prayerDay]['Asr']?['Iqamah']
              ?['time'] ??
          '00:00';
      maghribEndTime = prayersData[year][month][prayerDay]['Maghrib']?['Iqamah']
              ?['time'] ??
          '00:00';
      ishaEndTime = prayersData[year][month][prayerDay]['Isha']?['Iqamah']
              ?['time'] ??
          '00:00';

      for (int i = 0; i < prayerArray.length; i++) {
        String prayerStartTime =
            '${prayersData[year][month][prayerDay][prayerArray[i]]?['Adhaan']?['time']} ${prayersData[year][month][prayerDay][prayerArray[i]]?['Adhaan']?['clock']}';
        String prayerEndTime =
            '${prayersData[year][month][prayerDay][prayerArray[i]]?['Iqamah']?['time']} ${prayersData[year][month][prayerDay][prayerArray[i]]?['Iqamah']?['clock']}';

        DateTime prayerStartTimeRef = _parseTimeRef(prayerStartTime, now);
        DateTime prayerEndTimeRef = _parseTimeRef(prayerEndTime, now);

        if (prayerStartTimeRef.isAtSameMomentAs(now) ||
            (prayerStartTimeRef.isBefore(now) &&
                prayerEndTimeRef.isAfter(now))) {
          if (day == nowDay) {
            switch (prayerArray[i]) {
              case 'Fajr':
                isFajrPrayer = true;
                prayerEndTimer = getTimeCounter(now, prayerEndTimeRef);
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
          // print(nowMonth);
          if (day == nowDay && month == nowMonth) {
            switch (prayerArray[i]) {
              case 'Fajr':
                isFajrPrayer = true;
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
        }
      }
    }

    if (prayersData[year].containsKey(month) &&
        prayersData[year][month].containsKey(day)) {
      prayerTime(day);
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
                      'BEGINS',
                      style: TextStyle(
                        fontFamily: 'Intern',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 42,
                    ),
                    Text(
                      'JAMAT',
                      style: TextStyle(
                          fontFamily: 'Intern',
                          fontSize: 14,
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
            prayerStartTime: FajrStartTime,
            prayerEndTime: FajrEndTime,
            isPrayer: isFajrPrayer,
          ),
          PrayerRowWidget(
            prayerName: "Dhuhr",
            prayerStartTime: dhuhrStartTime,
            prayerEndTime: dhuhrEndTime,
            isPrayer: isDhuhrPrayer,
          ),
          PrayerRowWidget(
            prayerName: "Asr",
            prayerStartTime: asrStartTime,
            prayerEndTime: asrEndTime,
            isPrayer: isAsrPrayer,
          ),
          PrayerRowWidget(
            prayerName: "Maghrib",
            prayerStartTime: maghribStartTime,
            prayerEndTime: maghribEndTime,
            isPrayer: isMaghribPrayer,
          ),
          PrayerRowWidget(
            prayerName: "Isha",
            prayerStartTime: ishaStartTime,
            prayerEndTime: ishaEndTime,
            isPrayer: isIshaPrayer,
          ),
        ],
      ),
    );
  }
}
