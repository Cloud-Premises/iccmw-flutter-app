import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/settings_providers.dart';
import 'package:provider/provider.dart';

class QuranTranslation extends StatefulWidget {
  const QuranTranslation({super.key});

  @override
  State<QuranTranslation> createState() => _QuranTranslationState();
}

class _QuranTranslationState extends State<QuranTranslation> {
  @override
  Widget build(BuildContext context) {
    // final translationProvider = Provider.of<TranslationProvider>(context);
    // final transliterationProvider =
    // Provider.of<TransliterationProvider>(context);
    final settingsProviders = Provider.of<QuranSettingsProviders>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Translation",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Container(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              width: double.infinity, // specify a fixed width for the container
              decoration: BoxDecoration(
                // color: Color.fromRGBO(242, 198, 167, 0.25),
                color: cardColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'English Translation',
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
                          value: settingsProviders.isTranslationEnabled,
                          onChanged: (value) {
                            setState(() {
                              settingsProviders.isTranslationEnabled =
                                  !settingsProviders.isTranslationEnabled;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.5,
                    color: dividerColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'English Transliteration',
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
                          value: settingsProviders.isTransliterationEnabled,
                          onChanged: (value) {
                            setState(() {
                              settingsProviders.isTransliterationEnabled =
                                  !settingsProviders.isTransliterationEnabled;
                            });
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
      ],
    );
  }
}
