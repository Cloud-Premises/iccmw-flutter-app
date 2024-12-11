import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    bool isNotification = false;

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        // backgroundColor: const Color.fromRGBO(0, 153, 51, 1),

        backgroundColor: appBarColor,
        title: Row(
          children: [
            Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Notification',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: 19,
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
      body: SingleChildScrollView(
        child: !isNotification
            // ignore: dead_code
            ? Container(
                width: double.infinity,
                height: 600,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'No Notification',
                        style: TextStyle(
                          fontSize: 21,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            // ignore: dead_code
            : Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            'Notification 1',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Notification 1',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
