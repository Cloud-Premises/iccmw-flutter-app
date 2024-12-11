import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/general_setting_provider.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/sura_widget.dart';
import 'package:iccmw/features/quran_app/data/model/sura_model.dart';
import 'package:iccmw/features/quran_app/presentation/widgets/sura_widget_arabic.dart';
import 'package:provider/provider.dart'; // Make sure to import the Sura model

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  List<Sura> _suras = [];

  @override
  void initState() {
    super.initState();
    _loadSuraData();
  }

  Future<void> _loadSuraData() async {
    final String response =
        await rootBundle.loadString('assets/json/quranCom/surah/surah.json');
    final data = json.decode(response);
    final List<dynamic> suraList = data['chapters'];

    setState(() {
      _suras = suraList.map((json) => Sura.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralSettingProvider>(
        builder: (context, generalSettingProvider, child) {
      return ListView.builder(
        itemCount: _suras.length,
        itemBuilder: (context, index) {
          final sura = _suras[index];
          return generalSettingProvider.surahTitle
              ? SuraWidgetArabic(
                  leading: sura.id,
                  title: sura.nameSimple,
                  arabicTitle: sura.nameArabic,
                  subtitle: sura.translatedName.name,
                  numberOfAyat: sura.versesCount,
                )
              : SuraWidget(
                  leading: sura.id,
                  title: sura.nameSimple,
                  subtitle: sura.translatedName.name,
                  numberOfAyat: sura.versesCount,
                );
        },
      );
    });
  }
}
