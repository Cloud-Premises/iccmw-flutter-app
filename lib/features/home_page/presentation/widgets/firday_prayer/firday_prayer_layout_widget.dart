import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'firday_prayer_widget.dart'; // Make sure this file exists in the specified path

class FirdayPrayerLayoutWidget extends StatefulWidget {
  const FirdayPrayerLayoutWidget({Key? key}) : super(key: key);

  @override
  State<FirdayPrayerLayoutWidget> createState() =>
      FirdayPrayerLayoutWidgetState();
}

class FirdayPrayerLayoutWidgetState extends State<FirdayPrayerLayoutWidget> {
  List<dynamic> fridayPrayerData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFridayPrayerData();
  }

  Future<void> fetchFridayPrayerData() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/homePage/fridayPrayer.json');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> allFridayPrayers = jsonData['fridayPrayer'];

        // Determine today or the next Friday date
        final DateTime today = DateTime.now();
        DateTime targetFriday = today;

        // If today is not Friday, calculate the date for the next Friday
        if (today.weekday != DateTime.friday) {
          targetFriday = today
              .add(Duration(days: (DateTime.friday - today.weekday + 7) % 7));
        }

        // Filter prayers for today (if Friday) or the next upcoming Friday
        List<dynamic> filteredData = allFridayPrayers.where((prayer) {
          final prayerDate = DateFormat('MMMM d, yyyy').parse(
              "${prayer['date']['month']} ${prayer['date']['day']}, ${prayer['date']['year']}");
          return prayerDate.year == targetFriday.year &&
              prayerDate.month == targetFriday.month &&
              prayerDate.day == targetFriday.day;
        }).toList();

        setState(() {
          fridayPrayerData = filteredData;
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Friday Prayers',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 4),
        isLoading
            ? ShimmerLoadingWidget()
            : fridayPrayerData.isNotEmpty
                ? Column(
                    children: fridayPrayerData.map((prayer) {
                      return FirdayPrayerWidget(
                        title: prayer['title'],
                        prayerType: prayer['prayerType'],
                        prayerDate:
                            '${prayer['date']['month']} ${prayer['date']['day']}, ${prayer['date']['year']}',
                        khatbaPrayerTime: prayer['khatba'],
                        salahPrayerTime: prayer['Salah'],
                        address: prayer['address'],
                      );
                    }).toList(),
                  )
                : Center(
                    child: Text(
                      'No Friday prayer scheduled for today or upcoming Friday.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
      ],
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: double.infinity,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}
