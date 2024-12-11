import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iccmw/features/prayer_table/presentation/widgets/prayer_table_list/prayer_card_layout_widget.dart';

class PrayerTableList extends StatefulWidget {
  const PrayerTableList({super.key});

  @override
  State<PrayerTableList> createState() => PrayerTableListState();
}

class PrayerTableListState extends State<PrayerTableList> {
  final PageController _pageController = PageController();
  final now = DateTime.now();
  final formatter = DateFormat('EEEE d MMMM yyyy');
  final formatterDay = DateFormat('dd');
  late String nowDay = formatterDay.format(now);

  // String nowDate = nowToday.toString();

  late Map<String, dynamic> prayersData = {};

  final List<DateTime> dates = List.generate(
    45,
    (index) => DateTime.now().add(Duration(days: index - 0)),
  );
  late int _currentIndex = 0;

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        _currentIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < dates.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 510,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: dates.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final currentDate = dates[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: _goToPrevious,
                              icon: const Icon(Icons.arrow_back_ios),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  // formatter.format(dates[index]),
                                  formatter.format(currentDate),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _goToNext,
                              icon: const Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ),
                      // _buildWidgetCard(
                      //   formatter.format(dates[index]),
                      // )
                      // _buildWidgetCard(currentDate),
                      PrayerCardLayoutWidget(date: currentDate),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
