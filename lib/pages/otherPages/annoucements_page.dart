import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class AnnoucementsPage extends StatefulWidget {
  const AnnoucementsPage({super.key});

  @override
  State<AnnoucementsPage> createState() => AnnoucementsPageState();
}

class AnnoucementsPageState extends State<AnnoucementsPage> {
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
              image: AssetImage('assets/images/icons/marketing.png'),
              width: 24.0,
              height: 24.0,
              color: Colors.white,
            ),
            SizedBox(width: 10.0),
            Text(
              "Annoucements",
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
      body: const Center(
        child: Text("No Data"),
      ),
    );
  }
}
