import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iccmw/features/masjid_prayer/presentation/widgets/prayer_widget.dart';
import 'package:shimmer/shimmer.dart';

class MasjidPrayer extends StatefulWidget {
  const MasjidPrayer({super.key});

  @override
  State<MasjidPrayer> createState() => _MasjidPrayerState();
}

class _MasjidPrayerState extends State<MasjidPrayer> {
  Map<String, dynamic>? prayerTimes;

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  Future<void> _fetchPrayerTimes() async {
    final url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/homePage/masjidSalah.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _parsePrayerTimes(data);
      } else {
        print('Failed to load prayer times');
      }
    } catch (e) {
      print('Error fetching prayer times: $e');
    }
  }

  void _parsePrayerTimes(Map<String, dynamic> data) {
    final today = DateFormat('d').format(DateTime.now());
    final currentMonth = DateFormat('MMMM').format(DateTime.now());
    if (data[currentMonth] != null && data[currentMonth][today] != null) {
      setState(() {
        prayerTimes = data[currentMonth][today];
      });
    }
  }

  bool _isActivePrayer(String prayerName, String time, String clock) {
    final now = DateTime.now();
    final prayerTime = DateFormat("hh:mm a").parse('$time $clock');

    // Check if the prayer time is upcoming or active
    return prayerTime.add(const Duration(minutes: 50)).isAfter(now);
  }

  @override
  Widget build(BuildContext context) {
    Color containerColor = Theme.of(context).colorScheme.secondaryContainer;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: prayerTimes == null
          ? SizedBox(
              height: 100,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      5,
                      (index) => Container(
                        width: 100,
                        height: 80,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: prayerTimes!.entries.map((entry) {
                  final prayerName = entry.key;
                  final prayerTime = entry.value['start']['time'];
                  final clock = entry.value['start']['clock'];

                  // Determine if this prayer is active or upcoming
                  final activePrayer =
                      _isActivePrayer(prayerName, prayerTime, clock);

                  return Row(
                    children: [
                      SizedBox(width: 16),
                      PrayerWidget(
                        prayerName: prayerName,
                        prayerTime: '$prayerTime $clock',
                        activePrayer: activePrayer,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
