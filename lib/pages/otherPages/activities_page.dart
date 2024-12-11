import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => ActivitiesPageState();
}

class ActivitiesPageState extends State<ActivitiesPage> {
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
              const Image(
                image: AssetImage('assets/images/icons/calendarCheck.png'),
                width: 24.0,
                height: 24.0,
                // color: Colors.white,
              ),
              const SizedBox(width: 8.0),
              Text(
                "Activity Page",
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
        body: Center(
          child: Text('No data'),
        ));
  }
}
