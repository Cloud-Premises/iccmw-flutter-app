// import 'dart:convert';
// import 'dart:isolate';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';
// import 'package:intl/intl.dart';

// class PrayerManager {
//   static int year = DateTime.now().year;
//   static int currrentMonth = DateTime.now().month;

//   static final List<String> monthArray = [
//     '',
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December',
//   ];

//   static final List<int> daysInMonth = [
//     0,
//     31,
//     28,
//     31,
//     30,
//     31,
//     30,
//     31,
//     31,
//     30,
//     31,
//     30,
//     31,
//   ];

//   static Map<String, dynamic> prayersData = {};

//   /// Adjusts the days in February for leap years.
//   static void adjustForLeapYear(int year) {
//     daysInMonth[2] =
//         (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28;
//   }

//   /// Parses a time string and returns a `DateTime` object relative to the given date.
//   static DateTime parseTime(String time, int year, int month, int day) {
//     if (time.trim().isEmpty) {
//       throw ArgumentError("Time cannot be empty");
//     }

//     try {
//       DateFormat timeFormat = DateFormat('hh:mm a');
//       DateTime parsedTime = timeFormat.parse(time);

//       return DateTime(
//         year,
//         month,
//         day,
//         parsedTime.hour,
//         parsedTime.minute,
//       );
//     } catch (e) {
//       throw FormatException("Error parsing time: $e");
//     }
//   }

//   /// Schedules prayer notifications for all days in the specified years.
//   static void schedulePrayerNotifications(Map<String, dynamic> data) {
//     for (int month = currrentMonth; month <= currrentMonth + 1; month++) {
//       int daysInMonthInt = daysInMonth[month];
//       if (currrentMonth == 12) {
//         currrentMonth = 1;
//         year++;
//       }

//       for (int day = 1; day <= daysInMonthInt; day++) {
//         final List<String> prayerArray = [
//           'Fajr',
//           'Dhuhr',
//           'Asr',
//           'Maghrib',
//           'Isha'
//         ];

//         for (int prayer = 0; prayer < prayerArray.length; prayer++) {
//           if (data['$year']?['${monthArray[month]}'] != null) {
//             try {
//               String? prayerTime = data['$year']['${monthArray[month]}']['$day']
//                   ?[prayerArray[prayer]]?['Adhaan']?['time'];
//               String? prayerClock = data['$year']['${monthArray[month]}']
//                   ['$day']?[prayerArray[prayer]]?['Adhaan']?['clock'];

//               if (prayerTime == null ||
//                   prayerClock == null ||
//                   prayerTime.trim().isEmpty) {
//                 continue;
//               }

//               String prayerStartTime = '$prayerTime $prayerClock';
//               DateTime prayerStartTimeRef =
//                   parseTime(prayerStartTime, year, month, day);

//               int notificationId = year * 10000 +
//                   month * 100 +
//                   day * 10 +
//                   prayerArray.indexOf(prayerArray[prayer]);

//               AwesomeNotifications().createNotification(
//                 content: NotificationContent(
//                   id: notificationId,
//                   channelKey: prayerArray[prayer] == "Fajr"
//                       ? "iccmw_channel_fajrazan"
//                       : 'iccmw_channel_azan',
//                   title: "Prayer Time",
//                   body: "It's prayer time for ${prayerArray[prayer]}",
//                   notificationLayout: NotificationLayout.Default,
//                   criticalAlert: true,
//                   wakeUpScreen: true,
//                   category: NotificationCategory.Alarm,
//                 ),
//                 schedule: NotificationCalendar(
//                   year: prayerStartTimeRef.year,
//                   month: prayerStartTimeRef.month,
//                   day: prayerStartTimeRef.day,
//                   hour: prayerStartTimeRef.hour,
//                   minute: prayerStartTimeRef.minute,
//                   second: 0,
//                   millisecond: 0,
//                   repeats: false,
//                   preciseAlarm: true,
//                 ),
//               );
//             } catch (e) {
//               print(
//                   "Error scheduling notification for $year-$month-$day ${prayerArray[prayer]}: $e");
//             }
//           }
//         }
//       }
//     }
//   }

//   /// Fetches and sets the prayer data using an isolate.
//   static Future<void> fetchAndSetPrayerData() async {
//     final jsonString = await PrayerTimeCache.fetchDataFromCache();
//     if (jsonString == null) {
//       print("Prayer data not found in cache.");
//       return;
//     }

//     try {
//       final Map<String, dynamic> jsonData =
//           await _processDataInIsolate(jsonString);

//       prayersData = jsonData; // Store locally for future use.
//       AwesomeNotifications().cancelAll();
//       schedulePrayerNotifications(prayersData);
//     } catch (e) {
//       print("Error fetching or scheduling prayer data: $e");
//     }
//   }

//   /// Processes the prayer data in an isolate.
//   static Future<Map<String, dynamic>> _processDataInIsolate(
//       String jsonString) async {
//     final receivePort = ReceivePort();
//     await Isolate.spawn(
//         _decodeAndParsePrayerData, [receivePort.sendPort, jsonString]);

//     return await receivePort.first as Map<String, dynamic>;
//   }

//   /// The isolate's entry point function for decoding and parsing prayer data.
//   static void _decodeAndParsePrayerData(List<dynamic> args) {
//     SendPort sendPort = args[0];
//     String jsonString = args[1];

//     try {
//       Map<String, dynamic> jsonData = jsonDecode(jsonString);
//       sendPort.send(jsonData);
//     } catch (e) {
//       print("Error in isolate while decoding JSON: $e");
//       sendPort.send({});
//     }
//   }
// }

// import 'dart:convert';
// import 'dart:isolate';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';
// import 'package:intl/intl.dart';

// class PrayerManager {
//   static int year = DateTime.now().year;
//   static int currrentMonth = DateTime.now().month;
//   // static int currrentday = DateTime.now().day;

//   static final List<String> monthArray = [
//     '',
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December',
//   ];

//   static final List<int> daysInMonth = [
//     0,
//     31,
//     28,
//     31,
//     30,
//     31,
//     30,
//     31,
//     31,
//     30,
//     31,
//     30,
//     31,
//   ];

//   static Map<String, dynamic> prayersData = {};

//   /// Adjusts the days in February for leap years.
//   static void adjustForLeapYear(int year) {
//     daysInMonth[2] =
//         (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28;
//   }

//   /// Parses a time string and returns a `DateTime` object relative to the given date.
//   static DateTime parseTime(String time, int year, int month, int day) {
//     if (time.trim().isEmpty) {
//       throw ArgumentError("Time cannot be empty");
//     }

//     try {
//       DateFormat timeFormat = DateFormat('hh:mm a');
//       DateTime parsedTime = timeFormat.parse(time);

//       return DateTime(
//         year,
//         month,
//         day,
//         parsedTime.hour,
//         parsedTime.minute,
//       );
//     } catch (e) {
//       throw FormatException("Error parsing time: $e");
//     }
//   }

//   /// Schedules prayer notifications for all days in the specified years.
//   static void schedulePrayerNotifications(Map<String, dynamic> data) {
//     for (int month = currrentMonth; month < currrentMonth + 1; month++) {
//       int daysInMonthInt = daysInMonth[month];
//       if (currrentMonth == 12) {
//         currrentMonth = 1;
//         year++;
//       }

//       for (int day = 0; day <= daysInMonthInt; day++) {
//         final List<String> prayerArray = [
//           'Fajr',
//           'Dhuhr',
//           'Asr',
//           'Maghrib',
//           'Isha'
//         ];

//         for (int prayer = 0; prayer < prayerArray.length; prayer++) {
//           if (data['$year']?['${monthArray[month]}'] != null) {
//             try {
//               String? prayerTime = data['$year']['${monthArray[month]}']['$day']
//                   ?[prayerArray[prayer]]?['Adhaan']?['time'];
//               String? prayerClock = data['$year']['${monthArray[month]}']
//                   ['$day']?[prayerArray[prayer]]?['Adhaan']?['clock'];

//               if (prayerTime == null ||
//                   prayerClock == null ||
//                   prayerTime.trim().isEmpty) {
//                 continue;
//               }

//               String prayerStartTime = '$prayerTime $prayerClock';
//               DateTime prayerStartTimeRef =
//                   parseTime(prayerStartTime, year, month, day);

//               int notificationId = year * 10000 +
//                   month * 100 +
//                   day * 10 +
//                   prayerArray.indexOf(prayerArray[prayer]);

//               AwesomeNotifications().createNotification(
//                 content: NotificationContent(
//                   id: notificationId,
//                   channelKey: prayerArray[prayer] == "Fajr"
//                       ? "iccmw_channel_fajrazan"
//                       : 'iccmw_channel_azan',
//                   title: "Prayer Time",
//                   body: "It's prayer time for ${prayerArray[prayer]}",
//                   notificationLayout: NotificationLayout.Default,
//                   criticalAlert: true,
//                   wakeUpScreen: true,
//                   category: NotificationCategory.Alarm,
//                 ),
//                 schedule: NotificationCalendar(
//                   year: prayerStartTimeRef.year,
//                   month: prayerStartTimeRef.month,
//                   day: prayerStartTimeRef.day,
//                   hour: prayerStartTimeRef.hour,
//                   minute: prayerStartTimeRef.minute,
//                   second: 0,
//                   millisecond: 0,
//                   repeats: false,
//                   preciseAlarm: true,
//                 ),
//               );
//             } catch (e) {
//               print(
//                   "Error scheduling notification for $year-$month-$day ${prayerArray[prayer]}: $e");
//             }
//           }
//         }
//       }
//     }
//   }

//   /// Fetches and sets the prayer data using an isolate.
//   static Future<void> fetchAndSetPrayerData() async {
//     final jsonString = await PrayerTimeCache.fetchDataFromCache();
//     if (jsonString == null) {
//       print("Prayer data not found in cache.");
//       return;
//     }

//     try {
//       final Map<String, dynamic> jsonData =
//           await _processDataInIsolate(jsonString);

//       prayersData = jsonData; // Store locally for future use.
//       // AwesomeNotifications().cancelAll();
//       schedulePrayerNotifications(prayersData);
//     } catch (e) {
//       print("Error fetching or scheduling prayer data: $e");
//     }
//   }

//   /// Processes the prayer data in an isolate.
//   static Future<Map<String, dynamic>> _processDataInIsolate(
//       String jsonString) async {
//     final receivePort = ReceivePort();
//     await Isolate.spawn(
//         _decodeAndParsePrayerData, [receivePort.sendPort, jsonString]);

//     return await receivePort.first as Map<String, dynamic>;
//   }

//   /// The isolate's entry point function for decoding and parsing prayer data.
//   static void _decodeAndParsePrayerData(List<dynamic> args) {
//     SendPort sendPort = args[0];
//     String jsonString = args[1];

//     try {
//       Map<String, dynamic> jsonData = jsonDecode(jsonString);
//       sendPort.send(jsonData);
//     } catch (e) {
//       print("Error in isolate while decoding JSON: $e");
//       sendPort.send({});
//     }
//   }
// }
