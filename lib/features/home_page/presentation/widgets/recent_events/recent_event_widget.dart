import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class RecentEventWidget extends StatefulWidget {
  const RecentEventWidget({super.key});

  @override
  _RecentEventWidgetState createState() => _RecentEventWidgetState();
}

class _RecentEventWidgetState extends State<RecentEventWidget> {
  List<Map<String, dynamic>> events = [];
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  Timer? _pauseTimer;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _startAutoScroll();
  }

  Future<void> _fetchEvents() async {
    const url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/homePage/recentEvents.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          events = (data['RecentEvents'] as List)
              .map((e) => {
                    'heading': e['heading'],
                    'text': (e['text'] as List).join("\n"),
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void _startAutoScroll() {
    const duration =
        Duration(milliseconds: 30); // Adjust speed for smoother scroll
    _scrollTimer = Timer.periodic(duration, (timer) {
      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final currentOffset = _scrollController.offset;

        if (currentOffset < maxScrollExtent) {
          _scrollController.animateTo(
            currentOffset + 1,
            duration: duration,
            curve: Curves.linear,
          );
        } else {
          _scrollController.jumpTo(0); // Reset to top when the end is reached
        }
      }
    });
  }

  void _stopAutoScroll() {
    _scrollTimer?.cancel();
  }

  void _pauseAutoScroll() {
    _stopAutoScroll(); // Stop auto-scroll immediately
    _pauseTimer?.cancel(); // Cancel any existing pause timer
    _pauseTimer = Timer(const Duration(seconds: 2), () {
      _resumeAutoScroll(); // Resume auto-scroll after 2 seconds
    });
  }

  void _resumeAutoScroll() {
    if (_scrollTimer == null || !_scrollTimer!.isActive) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _pauseTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return events.isEmpty
        ? Center(
            child: kIsWeb
                ? CircularProgressIndicator()
                : (Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator()),
          )
        : GestureDetector(
            onPanDown: (_) {
              _pauseAutoScroll(); // Pause scrolling for 2 seconds on touch
            },
            child: Container(
              height: 300,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: List.generate(events.length, (index) {
                      final event = events[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['heading']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event['text']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
  }
}
