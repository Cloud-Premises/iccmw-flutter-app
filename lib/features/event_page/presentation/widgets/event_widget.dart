// File: lib/widgets/event_widget.dart
import 'package:flutter/material.dart';
import 'package:iccmw/features/event_page/presentation/widgets/carouselWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class EventWidget extends StatefulWidget {
  const EventWidget({Key? key}) : super(key: key);

  @override
  State<EventWidget> createState() => EventWidgetState();
}

class EventWidgetState extends State<EventWidget> {
  List<dynamic> events = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // Public method to allow reloading events from outside the widget
  Future<void> refreshEvents() async {
    await _loadEvents();
  }

  Future<void> _loadEvents() async {
    final url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/eventPage/eventPage.json';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          events = jsonData['events'];
          // Sort events by date in descending order
          events.sort((a, b) {
            DateTime dateA = _parseEventDate(a['date']);
            DateTime dateB = _parseEventDate(b['date']);
            return dateB.compareTo(dateA); // Descending order
          });
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load events. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while fetching events.';
        isLoading = false;
      });
    }
  }

  DateTime _parseEventDate(Map<String, dynamic> dateMap) {
    int year = dateMap['year'] ?? 0;
    int month = _getMonthIndex(dateMap['month'] ?? '');
    int day = dateMap['day'] ?? 0;

    return DateTime(year, month, day);
  }

  int _getMonthIndex(String month) {
    switch (month.toLowerCase()) {
      case 'january':
        return 1;
      case 'february':
        return 2;
      case 'march':
        return 3;
      case 'april':
        return 4;
      case 'may':
        return 5;
      case 'june':
        return 6;
      case 'july':
        return 7;
      case 'august':
        return 8;
      case 'september':
        return 9;
      case 'october':
        return 10;
      case 'november':
        return 11;
      case 'december':
        return 12;
      default:
        return 0; // Invalid month
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading
          ? _buildShimmerEffect() // Show shimmer effect while loading
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : Column(
                  children: [
                    ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable inner ListView scrolling
                      shrinkWrap:
                          true, // Let ListView take only as much height as needed
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        final title = event['title'] ?? 'No Title';
                        final dateMap = event['date'] ?? {};
                        final month = dateMap['month'] ?? 'Unknown';
                        final day = dateMap['day'] ?? 0;
                        final year = dateMap['year'] ?? 0;
                        final images = event['images'] != null
                            ? List<String>.from(event['images'])
                            : <String>[];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Event Title
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Event Date
                                  Text(
                                    '$month $day, $year',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Carousel of Images
                                  SizedBox(
                                    height: 320,
                                    child: ClipRect(
                                        child: CarouselWidget(images: images)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: List.generate(5, (index) => _buildShimmerCard()),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 15.0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
