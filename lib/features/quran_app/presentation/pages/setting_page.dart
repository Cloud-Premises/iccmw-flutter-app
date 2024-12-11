import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/settings/general_settings.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/settings/quran_theme.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/settings/quran_translation.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: appBarColor,
        title: Text(
          "Qur'an Settings",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GeneralSettings(),
            SizedBox(
              height: 12,
            ),
            QuranTheme(),
            SizedBox(
              height: 12,
            ),
            QuranTranslation(),
            SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
