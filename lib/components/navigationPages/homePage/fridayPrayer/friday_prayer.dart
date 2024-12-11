import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class FridayPrayer extends StatefulWidget {
  const FridayPrayer({super.key});

  @override
  State<FridayPrayer> createState() => _FridayPrayerState();
}

class _FridayPrayerState extends State<FridayPrayer> {
  List<Map<String, dynamic>>? _prayerTimes; // Variable to hold prayer times
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  // Function to fetch the prayer times from the JSON
  Future<void> _fetchPrayerTimes() async {
    const url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/homePage/fridayPrayer.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _prayerTimes = List<Map<String, dynamic>>.from(
            data['fridayPrayer'].map((item) => {
                  'title': item['title'] as String,
                  'khudba': item['khudba'] as String,
                  'salah': item['Salah'] as String,
                  'date': item['date'], // Include date as a map
                  'address': item['address'] as String,
                }),
          );
          _isLoading = false; // Update loading state
        });
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (error) {
      // Handle error
      print('Error fetching prayer times: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _isLoading
          ? List.generate(2, (_) => _buildShimmerCard())
          : _prayerTimes!.map((prayer) => _buildPrayerCard(prayer)).toList(),
    );
  }

  // Function to build the prayer card with real data
  Widget _buildPrayerCard(Map<String, dynamic> prayer) {
    Color containerColor = Theme.of(context).colorScheme.primaryContainer;

    final date = prayer['date'] as Map<String, dynamic>;
    // final formattedDate =
    //     '${date['month'].toString().substring(0, 3)} ${date['day']}, ${date['year']}';

    final formattedDate = '${date['month']} ${date['day']}, ${date['year']}';

    // print(date['month'].toString().substring(0,3));
    return Card(
      elevation: 4,
      color: containerColor,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: ListTile(
        // tileColor: containerColor.withOpacity(0.2),
        contentPadding: const EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: 14,
          right: 14,
        ),
        title: Text(
          prayer['title'] ?? '',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 21, color: Colors.black),
        ),

        subtitle: Column(
          children: [
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.calendar_month_outlined, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    // const Icon(Icons.access_time),
                    const SizedBox(width: 10),
                    Text('Khudba: ${prayer['khudba'] ?? ''}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    // const Icon(Icons.access_time),
                    const SizedBox(width: 10),
                    Text('Salah: ${prayer['salah'] ?? ''}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.black),
                const SizedBox(width: 10),
                Text(prayer['address'] ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the shimmer effect during loading
  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          tileColor: Colors.grey[200],
          contentPadding: const EdgeInsets.all(10),
          title: Container(
            width: 150,
            height: 20,
            color: Colors.grey[300], // Placeholder for title
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 20,
                color: Colors.grey[300], // Placeholder for date
              ),
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 20,
                color: Colors.grey[300], // Placeholder for khudba
              ),
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 20,
                color: Colors.grey[300], // Placeholder for salah
              ),
              const SizedBox(height: 10),
              Container(
                width: 200,
                height: 20,
                color: Colors.grey[300], // Placeholder for address
              ),
            ],
          ),
        ),
      ),
    );
  }
}
