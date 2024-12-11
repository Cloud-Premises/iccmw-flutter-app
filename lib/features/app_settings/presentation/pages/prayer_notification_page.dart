import 'package:flutter/material.dart';
import 'package:iccmw/features/app_settings/presentation/widgets/prayer_notification.dart';

class PrayerNotificationPage extends StatefulWidget {
  const PrayerNotificationPage({super.key});

  @override
  State<PrayerNotificationPage> createState() => _PrayerNotificationPageState();
}

class _PrayerNotificationPageState extends State<PrayerNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: const Color.fromRGBO(0, 153, 51, 1),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Prayer Notification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrayerNotification(),
          ],
        ),
      ),
    );
  }
}
