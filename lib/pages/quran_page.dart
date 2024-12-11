import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/quran_app/presentation/pages/juz_page.dart';
import 'package:iccmw/features/quran_app/presentation/pages/setting_page.dart';
import 'package:iccmw/features/quran_app/presentation/pages/surah_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Qur'an",
          style: TextStyle(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          SizedBox(
            width: 16,
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black87,
          labelStyle: TextStyle(
            fontSize: 16, // Increase the font size
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(
              text: 'Surah',
            ),
            Tab(
              text: 'Juz',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SurahPage(),
          JuzPage(),
        ],
      ),
    );
  }
}
