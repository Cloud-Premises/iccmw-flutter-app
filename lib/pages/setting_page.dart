import 'package:iccmw/features/app_settings/presentation/widgets/notifications.dart';
import 'package:iccmw/features/app_settings/presentation/widgets/prayer_notification.dart';
import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class SettingPage extends StatefulWidget {
  // const SettingPage({super.key});

  // final Function(theme_provider.CustomThemeData) onThemeSelected;
  // const SettingPage({super.key, required this.onThemeSelected});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        // backgroundColor: const Color.fromRGBO(0, 153, 51, 1),
        backgroundColor: appBarColor,

        title: Text('Setting',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            )),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
          ),
          child: Column(
            children: [
              SizedBox(height: 12),
              PrayerNotification(),
              SizedBox(height: 4),
              Notifications(),
              // ListTile(
              //   shape: RoundedRectangleBorder(
              //     borderRadius:
              //         BorderRadius.circular(15), // Shape for the ListTile
              //   ),
              //   tileColor:
              //       Colors.green, // Set to transparent to use Material's color
              //   title: Text(
              //     "General Notification",
              //     style: TextStyle(
              //       fontFamily: 'Poppins',
              //       fontSize: 21,
              //       color: Colors.white,
              //     ),
              //   ),
              //   trailing: IconButton(
              //     onPressed: () {
              //       // Handle subcategory tap, e.g., navigate to business list
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => GeneralNotificationPage(),
              //         ),
              //       );
              //     },
              //     icon: const Icon(Icons.arrow_forward_ios_rounded,
              //         color: Colors.white),
              //   ),
              //   onTap: () {
              //     // Handle ListTile tap to navigate to business list
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => GeneralNotificationPage(),
              //       ),
              //     );
              //   },
              // ),

              // Notifications(),
              // SizedBox(height: 12),
              // ListTile(
              //   shape: RoundedRectangleBorder(
              //     borderRadius:
              //         BorderRadius.circular(15), // Shape for the ListTile
              //   ),
              //   tileColor:
              //       Colors.green, // Set to transparent to use Material's color
              //   title: Text(
              //     "Prayer Notification",
              //     style: TextStyle(
              //       fontFamily: 'Poppins',
              //       fontSize: 21,
              //       color: Colors.white,
              //     ),
              //   ),
              //   trailing: IconButton(
              //     onPressed: () {
              //       // Handle subcategory tap, e.g., navigate to business list
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => PrayerNotificationPage(),
              //         ),
              //       );
              //     },
              //     icon: const Icon(Icons.arrow_forward_ios_rounded,
              //         color: Colors.white),
              //   ),
              //   onTap: () {
              //     // Handle ListTile tap to navigate to business list
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => PrayerNotificationPage(),
              //       ),
              //     );
              //   },
              // ),
              // PrayerNotification(),
              SizedBox(height: 19),
            ],
          ),
        ),
      ),
    );
  }
}
