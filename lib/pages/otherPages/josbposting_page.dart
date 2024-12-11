import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/job_posting_page/presentation/widgets/jobs_list_widget.dart';

class JosbpostingPage extends StatefulWidget {
  const JosbpostingPage({super.key});

  @override
  State<JosbpostingPage> createState() => JosbpostingPageState();
}

class JosbpostingPageState extends State<JosbpostingPage> {
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
                image: AssetImage('assets/images/icons/jobPosting.png'),
                width: 24.0,
                height: 24.0,
                // color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                "Job Posting",
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
        body: JobsListWidget());
  }
}