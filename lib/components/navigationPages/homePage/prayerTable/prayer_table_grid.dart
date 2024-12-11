import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iccmw/features/prayer_table/presentation/widgets/prayer_table_grid/prayer_card_layout_widget.dart';

class PrayerTableGrid extends StatefulWidget {
  const PrayerTableGrid({super.key});

  @override
  State<PrayerTableGrid> createState() => PrayerTableGridState();
}

class PrayerTableGridState extends State<PrayerTableGrid> {
  static const int dateRange = 45;
  static const double cardHeight = 350.0;
  static const Duration animationDuration = Duration(milliseconds: 300);

  final PageController _pageController = PageController();
  final DateFormat _dateFormatter = DateFormat('EEEE d MMMM yyyy');
  final List<DateTime> _dates = List.generate(
    dateRange,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  int _currentIndex = 0;

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        --_currentIndex,
        duration: animationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < _dates.length - 1) {
      _pageController.animateToPage(
        ++_currentIndex,
        duration: animationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: cardHeight,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _dates.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final currentDate = _dates[index];
                  return _buildDateCard(currentDate);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(DateTime currentDate) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _goToPrevious,
                icon: Image(
                  image: AssetImage('assets/images/icons/left_arrow.png'),
                  width: 24.0,
                  height: 24.0,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _dateFormatter.format(currentDate),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              IconButton(
                onPressed: _goToNext,
                icon: Image(
                  image: AssetImage('assets/images/icons/right_arrow.png'),
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ],
          ),
        ),
        PrayerCardLayoutWidget(date: currentDate),
      ],
    );
  }
}
