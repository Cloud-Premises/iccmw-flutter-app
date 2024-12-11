// File: event_page.dart

import 'package:flutter/material.dart';
import 'package:iccmw/features/event_page/presentation/widgets/event_widget.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  final GlobalKey<EventWidgetState> _eventWidgetKey =
      GlobalKey<EventWidgetState>();

  Future<void> _refreshPage() async {
    // Trigger the refreshEvents method in EventWidget
    await _eventWidgetKey.currentState?.refreshEvents();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Required for RefreshIndicator to work
        child: Column(
          children: [
            EventWidget(
              key: _eventWidgetKey, // Assign the GlobalKey to the EventWidget
            ),
          ],
        ),
      ),
    );
  }
}
