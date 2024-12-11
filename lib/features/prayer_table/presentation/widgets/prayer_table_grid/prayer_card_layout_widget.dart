import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iccmw/features/prayer_table/presentation/widgets/prayer_table_grid/prayer_card_widget.dart';
import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';

class PrayerCardLayoutWidget extends StatefulWidget {
  final DateTime date;
  const PrayerCardLayoutWidget({
    super.key,
    required this.date,
  });

  @override
  State<PrayerCardLayoutWidget> createState() => _PrayerCardLayoutWidgetState();
}

class _PrayerCardLayoutWidgetState extends State<PrayerCardLayoutWidget> {
  final now = DateTime.now();
  final formatter = DateFormat('EEEE d MMMM yyyy');
  final formatterDay = DateFormat('d');
  late String nowDay = formatterDay.format(now);

  // String nowDate = nowToday.toString();
  late Map<String, dynamic> prayersData = {};
  final List<DateTime> dates = List.generate(
    45,
    (index) => DateTime.now().add(Duration(days: index - 0)),
  );

  @override

  // Widget _buildWidgetCard(DateTime date)

  void initState() {
    super.initState();
    setPrayer();
  }

  Future<void> setPrayer() async {
    final jsonString = await PrayerTimeCache.fetchDataFromCache();
    if (jsonString == null) {
      // print('No data found in cache');
      return;
    }

    setState(() {
      // jsonString to JsonData
      prayersData = jsonDecode(jsonString);
    });
    // print('prayersData');
  }

  @override
  Widget build(BuildContext context) {
    // String formattedDate = formatter.format(widget.date);
    final now = widget.date;
    final formatterMonth = DateFormat('MMMM');
    // print(now);
    // print(prayersData);
    // Split the string based on spaces
    // List<String> dateParts = date;
    // print(dateParts);
    // Assign the parts to different variables
    // String dayOfWeek = dateParts[0];
    String day = now.day.toString();
    String month = formatterMonth.format(now);

    // print('---------------------------- day then nowday');
    // print(day);
    // print(nowDay);
    // print(activeMonth);
    // String month = dateParts[2];
    // String year = dateParts[3];

    // // Print the result
    // print('Day of Week: $dayOfWeek');
    // print('Day: $day');
    // print('Month: $month');
    // print('Year: $year');
    // print(date);

    // Helper function to parse time and convert it to DateTime
    DateTime _parseTimeRef(String time, DateTime referenceDate) {
      DateFormat timeFormat = DateFormat('hh:mm a');
      DateTime parsedTime = timeFormat.parse(time);

      // Extract the hour and minute from the parsed time
      int hour = parsedTime.hour;
      int minute = parsedTime.minute;

      // Create a DateTime object based on the reference date with parsed time
      return DateTime(referenceDate.year, referenceDate.month,
          referenceDate.day, hour, minute);
    }

    String getTimeCounter(DateTime currentTime, DateTime targetTime) {
      Duration duration = targetTime.difference(currentTime);

      // If target time is in the past, return "00:00"
      if (duration.isNegative) {
        return "00:00";
      }

      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String hours = twoDigits(duration.inHours);
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      String seconds = twoDigits(duration.inSeconds.remainder(60));

      return "$hours:$minutes:$seconds"; // Format as "HH:MM:SS"
    }

    // Define variables outside the if block with default values
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
    // Assign values if prayersData contains the required information

    void prayerTime(prayerDay) {
      FajrStartTime =
          prayersData[month][prayerDay]['Fajr']?['start']?['time'] ?? '00:00';
      dhuhrStartTime =
          prayersData[month][prayerDay]['Dhuhr']?['start']?['time'] ?? '00:00';
      asrStartTime =
          prayersData[month][prayerDay]['Asr']?['start']?['time'] ?? '00:00';
      maghribStartTime = prayersData[month][prayerDay]['Maghrib']?['start']
              ?['time'] ??
          '00:00';
      ishaStartTime =
          prayersData[month][prayerDay]['Isha']?['start']?['time'] ?? '00:00';

      FajrEndTime =
          prayersData[month][prayerDay]['Fajr']?['end']?['time'] ?? '00:00';
      dhuhrEndTime =
          prayersData[month][prayerDay]['Dhuhr']?['end']?['time'] ?? '00:00';
      asrEndTime =
          prayersData[month][prayerDay]['Asr']?['end']?['time'] ?? '00:00';
      maghribEndTime =
          prayersData[month][prayerDay]['Maghrib']?['end']?['time'] ?? '00:00';
      ishaEndTime =
          prayersData[month][prayerDay]['Isha']?['end']?['time'] ?? '00:00';

      for (int i = 0; i < prayerArray.length; i++) {
        String prayerStartTime =
            '${prayersData[month][prayerDay][prayerArray[i]]?['start']?['time']} ${prayersData[month][prayerDay][prayerArray[i]]?['start']?['clock']}';
        String prayerEndTime =
            '${prayersData[month][prayerDay][prayerArray[i]]?['end']?['time']} ${prayersData[month][prayerDay][prayerArray[i]]?['end']?['clock']}';

        // print(prayerStartTime);
        DateTime prayerStartTimeRef = _parseTimeRef(prayerStartTime, now);
        DateTime prayerEndTimeRef = _parseTimeRef(prayerEndTime, now);

        if (prayerStartTimeRef.isAtSameMomentAs(now) ||
            (prayerStartTimeRef.isBefore(now) &&
                prayerEndTimeRef.isAfter(now))) {
          // print('Now Prayer Time');

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
          if (day == nowDay) {
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

    if (prayersData.containsKey(month) && prayersData[month].containsKey(day)) {
      prayerTime(day);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20) ,
      child: Wrap(
        spacing: 12, // Spacing between items horizontally
        runSpacing: 12, // Spacing between items vertically
        children: [
          PrayerCardWidget(
            prayerName: "Fajr",
            prayerStartTime: FajrStartTime,
            prayerEndTime: FajrEndTime,
            isPrayer: isFajrPrayer,
          ),
          PrayerCardWidget(
            prayerName: "Dhuhr",
            prayerStartTime: dhuhrStartTime,
            prayerEndTime: dhuhrEndTime,
            isPrayer: isDhuhrPrayer,
          ),
          PrayerCardWidget(
            prayerName: "Asr",
            prayerStartTime: asrStartTime,
            prayerEndTime: asrEndTime,
            isPrayer: isAsrPrayer,
          ),
          PrayerCardWidget(
            prayerName: "Maghrib",
            prayerStartTime: maghribStartTime,
            prayerEndTime: maghribEndTime,
            isPrayer: isMaghribPrayer,
          ),
          PrayerCardWidget(
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
