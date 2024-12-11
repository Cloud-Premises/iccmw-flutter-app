import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/event_page/presentation/pages/event_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => EventsPageState();
}

class EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: appBarColor,
          title: Row(
            children: [
              Image(
                image: AssetImage('assets/images/icons/calendarCheck.png'),
                width: 24.0,
                height: 24.0,
                // color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                "Events",
                style: TextStyle(
                  color: appBarTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: appBarIconColor,
            ),
          ),
        ),
        body: EventPage());
  }
}
