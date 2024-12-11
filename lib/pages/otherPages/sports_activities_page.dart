import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/sports_activities_page/presentation/widgets/activities_list_widget.dart';

class SportsActivitiesPage extends StatefulWidget {
  const SportsActivitiesPage({super.key});

  @override
  State<SportsActivitiesPage> createState() => SportsActivitiesPageState();
}

class SportsActivitiesPageState extends State<SportsActivitiesPage> {
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
                image: AssetImage('assets/images/icons/sportsActivity.png'),
                width: 24.0,
                height: 24.0,
                // color: Colors.white,
              ),
              const SizedBox(width: 8.0),
              Text(
                "Sports Activities",
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
            icon: Icon(Icons.arrow_back_ios, color: appBarIconColor),
          ),
        ),
        body: ActivitiesListWidget());
  }
}
