import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/social_media_page/presentation/pages/social_media_list_page.dart';

class SocialMediaPage extends StatefulWidget {
  const SocialMediaPage({super.key});

  @override
  State<SocialMediaPage> createState() => SocialMediaPageState();
}

class SocialMediaPageState extends State<SocialMediaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: appBarColor,

          title: Row(
            children: [
              Image(
                image: AssetImage('assets/images/icons/whatsapp.png'),
                width: 24.0,
                height: 24.0,
                // color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                "Join Whatsapp Groups",
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
        body: SocialMediaListPage());
  }
}
