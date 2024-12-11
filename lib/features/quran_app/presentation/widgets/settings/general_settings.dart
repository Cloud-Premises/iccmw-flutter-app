import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/general_setting_provider.dart';
import 'package:provider/provider.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralSettingProvider>(
      builder: (context, settingsProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General Settings",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Container(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Surah Arabic Title',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.6,
                            child: Switch(
                              activeColor: commonComponentColor,
                              value: settingsProvider.surahTitle,
                              onChanged: (value) {
                                settingsProvider.toggleSurahTitle(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 0.8,
                        color: dividerColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Juz Arabic Title',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.6,
                            child: Switch(
                              activeColor: commonComponentColor,
                              value: settingsProvider.juzTitle,
                              onChanged: (value) {
                                settingsProvider.toggleJuzTitle(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(height: 12),
            // Container(
            //   width: double.infinity,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: Container(
            //       padding: EdgeInsets.symmetric(
            //         horizontal: 16,
            //       ),
            //       decoration: BoxDecoration(
            //         color: cardColor,
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             'Juz Arabic Title',
            //             style: TextStyle(
            //               fontSize: 16,
            //               fontFamily: 'Poppins',
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //           Transform.scale(
            //             scale: 0.6,
            //             child: Switch(
            //               value: settingsProvider.juzTitle,
            //               onChanged: (value) {
            //                 settingsProvider.toggleJuzTitle(value);
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
