import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/general_setting_provider.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/juz_widget.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/juz_widget_arabic.dart';
import 'package:provider/provider.dart'; // For rootBundle to load JSON

class JuzPage extends StatefulWidget {
  const JuzPage({Key? key}) : super(key: key);

  @override
  State<JuzPage> createState() => _JuzPageState();
}

class _JuzPageState extends State<JuzPage> {
  List<dynamic> _juzList = [];

  @override
  void initState() {
    super.initState();
    _loadJuzData();
  }

  Future<void> _loadJuzData() async {
    // Load JSON data from the local asset file
    String jsonString = await rootBundle.loadString('assets/json/juz.json');
    setState(() {
      _juzList = json.decode(jsonString)['juz'];
    });
  }

  @override

  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: _juzList.map<Widget>((juz) {
  //         return JuzWidget(
  //             juzName: juz['name'],
  //             // juzArabicTitle: juz['arabic_title'],
  //             juzNumber: juz['verse_number'],
  //             juzSuraName: juz['sura_name'],
  //             juzEndSuraName: juz['end_sura_name'],
  //             juzVerseKeyStart: juz['verse_key_start'],
  //             juzVerseKeyEnd: juz['verse_key_end']);
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Consumer<GeneralSettingProvider>(
        builder: (context, generalSettingProvider, child) {
      return SingleChildScrollView(
        child: generalSettingProvider.juzTitle
            ? Column(
                children: _juzList.map<Widget>((juz) {
                  return JuzWidgetArabic(
                    juzName: juz['name'],
                    juzArabicTitle: juz['arabic_title'],
                    juzNumber: juz['verse_number'],
                    juzSuraName: juz['sura_name'],
                    juzEndSuraName: juz['end_sura_name'],
                    juzVerseKeyStart: juz['verse_key_start'],
                    juzVerseKeyEnd: juz['verse_key_end'],
                    juzVerseStartId: juz['verse_start_id'],
                    juzVerseEndId: juz['verse_end_id'],
                  );
                }).toList(),
              )
            : Column(
                children: _juzList.map<Widget>((juz) {
                  return JuzWidget(
                    juzName: juz['name'],
                    juzNumber: juz['verse_number'],
                    juzSuraName: juz['sura_name'],
                    juzEndSuraName: juz['end_sura_name'],
                    juzVerseKeyStart: juz['verse_key_start'],
                    juzVerseKeyEnd: juz['verse_key_end'],
                    juzVerseStartId: juz['verse_start_id'],
                    juzVerseEndId: juz['verse_end_id'],
                  );
                }).toList(),
              ),
      );
    });
  }
}
