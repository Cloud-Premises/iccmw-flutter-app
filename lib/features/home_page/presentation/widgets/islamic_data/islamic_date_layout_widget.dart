// import 'package:flutter/material.dart';
// import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/islamic_data/islamic_data_widget.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/prayer_table/prayer_list_widget.dart';
// import 'package:intl/intl.dart';

// class IslamicDateLayoutWidget extends StatefulWidget {
//   const IslamicDateLayoutWidget({super.key});

//   @override
//   State<IslamicDateLayoutWidget> createState() =>
//       IslamicDateLayoutWidgetState();
// }

// class IslamicDateLayoutWidgetState extends State<IslamicDateLayoutWidget> {
//   final PageController _pageController = PageController();
//   final now = DateTime.now();
//   final formatter = DateFormat('EEEE d MMMM yyyy');
//   final formatterDay = DateFormat('dd');
//   late String nowDay = formatterDay.format(now);

//   // String nowDate = nowToday.toString();

//   late Map<String, dynamic> prayersData = {};

//   final List<DateTime> dates = List.generate(
//     460,
//     (index) => DateTime.now().add(Duration(days: index - 0)),
//   );
//   late int _currentIndex = 0;

//   void _goToPrevious() {
//     if (_currentIndex > 0) {
//       _pageController.animateToPage(
//         _currentIndex - 1,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _goToNext() {
//     if (_currentIndex < dates.length - 1) {
//       _pageController.animateToPage(
//         _currentIndex + 1,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SizedBox(
//         height: 350,
//         width: double.infinity,
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: dates.length,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentIndex = index;
//                   });
//                 },
//                 itemBuilder: (context, index) {
//                   final currentDate = dates[index];
//                   // print(currentDate);
//                   return Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               onPressed: _goToPrevious,
//                               // icon: const Icon(Icons.arrow_back_ios),
//                               icon: Icon(
//                                 Icons.arrow_back_ios_new_rounded,
//                                 color: commonComponentColor,
//                               ),
//                             ),
//                             IslamicDataWidget(selectedDate: currentDate),
//                             IconButton(
//                               onPressed: _goToNext,
//                               icon: Icon(
//                                 Icons.arrow_forward_ios_rounded,
//                                 color: commonComponentColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                           child: PrayerListWidget(selectedDate: currentDate)),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/home_page/presentation/widgets/islamic_data/islamic_data_widget.dart';
import 'package:iccmw/features/home_page/presentation/widgets/prayer_table/prayer_list_widget.dart';
import 'package:intl/intl.dart';

class IslamicDateLayoutWidget extends StatefulWidget {
  const IslamicDateLayoutWidget({super.key});

  @override
  State<IslamicDateLayoutWidget> createState() =>
      IslamicDateLayoutWidgetState();
}

class IslamicDateLayoutWidgetState extends State<IslamicDateLayoutWidget> {
  final PageController _pageController = PageController();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('EEEE d MMMM yyyy');
  final DateFormat formatterDay = DateFormat('dd');
  late String nowDay = formatterDay.format(now);
  final bool dateBool = false;

  late Map<String, dynamic> prayersData = {};
  late List<DateTime> dates = []; // Make the dates list nullable initially

  late int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    final currentTime = DateTime.now();
    dates = List.generate(
      460,
      (index) => (currentTime.hour >= 20 && currentTime.hour < 24)
          ? DateTime.now().add(Duration(days: index + 1))
          : DateTime.now().add(Duration(days: index)),
    );
  }

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
        height: 350,
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
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: _goToPrevious,
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: commonComponentColor,
                              ),
                            ),
                            IslamicDataWidget(selectedDate: currentDate),
                            IconButton(
                              onPressed: _goToNext,
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: commonComponentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: PrayerListWidget(selectedDate: currentDate)),
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
