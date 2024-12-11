// quran_font.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/settings_providers.dart';
import 'package:iccmw/features/quran_reciter/data/models/reciter_model.dart';
import 'package:iccmw/features/quran_reciter/presentation/providers/reciters_provider.dart';
import 'package:provider/provider.dart';

class QuranTheme extends StatefulWidget {
  const QuranTheme({super.key});

  @override
  State<QuranTheme> createState() => _QuranThemeState();
}

class _QuranThemeState extends State<QuranTheme> {
  String translation = '';
  String translitration = '';
  String translationJson = '19';

  @override
  void initState() {
    super.initState();
    Provider.of<QuranSettingsProviders>(context, listen: false).loadVerseText();

    _loadTranslations();
    _loadTranslitration();
  }

  Future<void> _loadTranslations() async {
    final String response = await rootBundle
        .loadString('assets/json/quranCom/resources/$translationJson.json');
    final data = json.decode(response);

    // Get the first translation text
    final firstText = data[0]['text_verse'];

    setState(() {
      translation = firstText;
    });
  }

  Future<void> _loadTranslitration() async {
    final String response =
        await rootBundle.loadString('assets/json/quranCom/resources/57.json');
    final data = json.decode(response);

    // Get the first translation text
    final firstText = data[0]['text_verse'];

    setState(() {
      translitration = firstText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProviders = Provider.of<QuranSettingsProviders>(context);
    final reciterProviders = Provider.of<ReciterProvider>(context);

    if (settingsProviders.selectedTranslation?.id != null) {
      setState(() {
        translationJson = '${settingsProviders.selectedTranslation?.id}';
        // print(quranTranslationProvider.selectedTranslation?.id);
        _loadTranslations();
      });
    }

    Color getFillColor(ThemeColors color) {
      switch (color) {
        case ThemeColors.black:
          return Colors.black87;
        case ThemeColors.green:
          return Colors.green[50]!;
        case ThemeColors.orange:
          return Colors.orange[50]!;
        case ThemeColors.blue:
          return Colors.blue[50]!;
        case ThemeColors.yellow:
          return Colors.yellow[50]!;
        default:
          return Colors.transparent;
      }
    }

    Widget buildColorRadio(ThemeColors color) {
      final isSelected = settingsProviders.selectedColor == color;

      return GestureDetector(
        onTap: () {
          settingsProviders.setThemeColor(color);
        },
        child: Container(
          width: 24,
          height: 24,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getFillColor(color),
            border: isSelected
                ? Border.all(
                    color:
                        color == Colors.black87 ? Colors.white : Colors.black,
                    width: 2,
                  )
                : null,
          ),
        ),
      );
    }

    void showTranslationDropdownDialog({
      required BuildContext context,
    }) {
      final provider =
          Provider.of<QuranSettingsProviders>(context, listen: false);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Quran Translation',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: DropdownButton<int>(
                isExpanded: true,
                value: provider.selectedTranslation?.id,
                items: provider.englishTranslations.map<DropdownMenuItem<int>>(
                  (translation) {
                    return DropdownMenuItem<int>(
                      value: translation.id,
                      child: Text(translation.authorName),
                    );
                  },
                ).toList(),
                onChanged: (int? selectedId) {
                  if (selectedId != null) {
                    provider.setSelectedTranslationById(selectedId);
                    Navigator.pop(context); // Close the dialog after selection
                  }
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog button
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    void showReciterDropdownDialog({
      required BuildContext context,
    }) {
      final reciterProvider =
          Provider.of<ReciterProvider>(context, listen: false);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: reciterProvider.fetchReciters(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to load reciters: ${snapshot.error}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                );
              }

              return AlertDialog(
                title: Text(
                  'Select Reciter',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: DropdownButton<ReciterModel>(
                    isExpanded: true,
                    value: reciterProvider.selectedReciter,
                    items: reciterProvider.reciterList
                        ?.map<DropdownMenuItem<ReciterModel>>(
                      (reciter) {
                        return DropdownMenuItem<ReciterModel>(
                          value: reciter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${reciter.id}.  ',
                                  ),
                                  Text(
                                    reciter.reciterNameEng,
                                  ),
                                ],
                              ),
                              reciter.reciterNameEng ==
                                      reciterProvider
                                          .selectedReciter?.reciterNameEng
                                  ? Icon(
                                      Icons.check_box,
                                      color: commonComponentColor,
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (ReciterModel? selectedReciter) {
                      if (selectedReciter != null) {
                        reciterProvider.selectReciter(selectedReciter);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    // void showReciternDropdownDialog({
    //   required BuildContext context,
    // }) {
    //   final provider =
    //       Provider.of<QuranSettingsProviders>(context, listen: false);

    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text(
    //           'Select Reciter',
    //           style: TextStyle(
    //             fontSize: 18,
    //             fontFamily: 'Poppins',
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //         content: SizedBox(
    //           width: double.maxFinite,
    //           child: DropdownButton<int>(
    //             isExpanded: true,
    //             value: provider.selectedTranslation?.id,
    //             items: provider.englishTranslations.map<DropdownMenuItem<int>>(
    //               (translation) {
    //                 return DropdownMenuItem<int>(
    //                   value: translation.id,
    //                   child: Text(translation.authorName),
    //                 );
    //               },
    //             ).toList(),
    //             onChanged: (int? selectedId) {
    //               if (selectedId != null) {
    //                 provider.setSelectedTranslationById(selectedId);
    //                 Navigator.pop(context); // Close the dialog after selection
    //               }
    //             },
    //           ),
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.pop(context), // Close dialog button
    //             child: Text(
    //               'Cancel',
    //               style: TextStyle(
    //                 color: Colors.red,
    //               ),
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Qur'an Theme",
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: settingsProviders.themeColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    settingsProviders.firstVerseText,
                    style: TextStyle(
                      fontSize: 28,
                      color: settingsProviders.themeColor == Colors.black87
                          ? Colors.white
                          : Colors.black87,
                      fontFamily: settingsProviders.arabicFont,
                    ),
                  ),
                  SizedBox(height: 8),
                  settingsProviders.isTransliterationEnabled
                      ? Text(
                          // "Bismillaahir Rahmaanir Raheem",
                          translitration,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            color:
                                settingsProviders.themeColor == Colors.black87
                                    ? Colors.white
                                    : Colors.black87,
                            fontFamily: settingsProviders.englishFont,
                          ),
                        )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                  SizedBox(height: 8),
                  settingsProviders.isTranslationEnabled
                      ? Text(
                          translation,
                          // '${quranTranslationProvider.englishTranslations}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            color:
                                settingsProviders.themeColor == Colors.black87
                                    ? Colors.white
                                    : Colors.black87,
                            fontFamily: settingsProviders.englishFont,
                          ),
                        )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Theme Color',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            buildColorRadio(ThemeColors.green),
                            buildColorRadio(ThemeColors.orange),
                            buildColorRadio(ThemeColors.yellow),
                            buildColorRadio(ThemeColors.blue),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 0.8, color: dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Arabic Script',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButton<String>(
                        value: settingsProviders.currentScript,
                        items: settingsProviders.availableScripts
                            .map<DropdownMenuItem<String>>((String script) {
                          return DropdownMenuItem<String>(
                            value: script,
                            child: Text(script.replaceAll('.json', '')),
                          );
                        }).toList(),
                        onChanged: (String? newScript) {
                          if (newScript != null) {
                            settingsProviders.setScript(newScript);
                          }
                        },
                      ),
                    ],
                  ),
                  Divider(thickness: 0.8, color: dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Arabic Font Style',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButton<String>(
                        value: settingsProviders.arabicFont,
                        items: <String>[
                          'Uthmani2',
                          'NotoNaskhArabic',
                          'AyatQuran',
                          'Pdms',
                          'AlMajeedQuranic',
                          'ArabQuranIslamic'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            settingsProviders.setArabicFont(newValue);
                          }
                        },
                      ),
                    ],
                  ),
                  Divider(thickness: 0.8, color: dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'English Font Style',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButton<String>(
                        value: settingsProviders.englishFont,
                        items: <String>[
                          'Poppins',
                          'Mermaid',
                          'Intern',
                          'Amita',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            settingsProviders.setEnglishFont(newValue);
                          }
                        },
                      ),
                    ],
                  ),
                  Divider(thickness: 0.8, color: dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'English Translation By',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              '${settingsProviders.selectedTranslation?.authorName}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: null, // Allow unlimited lines
                              overflow: TextOverflow
                                  .visible, // This ensures text will wrap and not be truncated
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              primaryButtonBackgroundColor, // Change button color here
                          foregroundColor:
                              primaryButtonForegroundColor, // Change text color
                        ),
                        onPressed: () {
                          showTranslationDropdownDialog(
                            context: context,
                          );
                          // print(quranTranslationProvider
                          //     .englishTranslations.first.authorName);
                          // print(quranTranslationProvider
                          //     .selectedTranslation?.name);
                        },
                        child: Text('Change'),
                      )
                    ],
                  ),
                  Divider(thickness: 0.8, color: dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Qur'an Reciter",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              // '${reciterProviders.selectedTranslation?.authorName}',
                              '${reciterProviders.selectedReciter?.reciterNameEng}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: null, // Allow unlimited lines
                              overflow: TextOverflow
                                  .visible, // This ensures text will wrap and not be truncated
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              primaryButtonBackgroundColor, // Change button color here
                          foregroundColor:
                              primaryButtonForegroundColor, // Change text color
                        ),
                        onPressed: () {
                          showReciterDropdownDialog(
                            context: context,
                          );
                        },
                        child: Text('Change'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
