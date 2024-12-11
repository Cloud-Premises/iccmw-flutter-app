// import 'dart:convert';

// import 'package:iccmw/components/commonUI/widgets/carousel/carouselWidget.dart';
// import 'package:iccmw/components/commonUI/widgets/upcoming_events.dart';
// import 'package:iccmw/components/navigationPages/homePage/fridayPrayer/friday_prayer.dart';
// import 'package:iccmw/components/navigationPages/homePage/masjidPrayer/masjid_prayer.dart';
// import 'package:iccmw/components/navigationPages/homePage/prayerCard/prayer_card.dart';
// import 'package:iccmw/features/app_settings/presentation/providers/card_style_provider.dart';
// import 'package:iccmw/features/app_settings/presentation/providers/prayer_card_visibility_provider.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/firday_prayer/firday_prayer_layout_widget.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/firday_prayer/firday_prayer_widget.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/iccmw_widget.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/islamic_data/islamic_data_widget.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/islamic_data/islamic_date_layout_widget.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/new_home_widget.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/prayer_table/day_duration_widget.dart';
// import 'package:iccmw/features/home_page/presentation/widgets/prayer_table/prayer_list_widget.dart';
// import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// // components
// import 'package:iccmw/components/navigationPages/homePage/otherWidgets/card_one_style.dart';
// import 'package:iccmw/components/navigationPages/homePage/otherWidgets/card_two_style.dart';
// import 'package:iccmw/components/navigationPages/homePage/prayerTable/prayer_table_grid.dart';
// import 'package:iccmw/components/navigationPages/homePage/prayerTable/prayer_table_list.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   bool gridListToggle = true;

//   final GlobalKey<PrayerCardState> _prayerCardKey =
//       GlobalKey<PrayerCardState>();
//   final GlobalKey<CarouselwidgetState> carouselWidgetKey =
//       GlobalKey<CarouselwidgetState>();

//   final GlobalKey<UpcomingEventsState> upcomingEventKey =
//       GlobalKey<UpcomingEventsState>();
//   Future<void> _initializeData() async {
//     // This method fetches and caches the data
//     await PrayerTimeCache.fetchAndCacheData();
//     await _prayerCardKey.currentState?.setActiveMonth();
//     await _prayerCardKey.currentState?.setCurrentImage();
//     await carouselWidgetKey.currentState?.fetchImages();
//     await setCardVisibility(context);
//   }

//   DateTime _parseTimeRef(String time, DateTime referenceDate) {
//     if (time.trim().isEmpty) {
//       return referenceDate;
//     }
//     try {
//       DateFormat timeFormat = DateFormat('hh:mm a');
//       DateTime parsedTime = timeFormat.parse(time);
//       int hour = parsedTime.hour;
//       int minute = parsedTime.minute;
//       return DateTime(referenceDate.year, referenceDate.month,
//           referenceDate.day, hour, minute);
//     } catch (e) {
//       return referenceDate;
//     }
//   }

//   Future<void> setCardVisibility(BuildContext context) async {
//     final now = DateTime.now();
//     final formatterMonth = DateFormat('MMMM');

//     final jsonString = await PrayerTimeCache.fetchDataFromCache();
//     final activeMonth = formatterMonth.format(now);
//     final day = now.day.toString();

//     if (jsonString == null) {
//       return;
//     }

//     final Map<String, dynamic> jsonData = jsonDecode(jsonString);
//     final prayers = jsonData[activeMonth][day];
//     String prayerIshaEndTime =
//         '${prayers['Isha']['end']['time']} ${prayers['Isha']['end']['clock']}';
//     DateTime prayerIshaEndTimeRef = _parseTimeRef(prayerIshaEndTime, now);
//     // print(prayerIshaEndTimeRef);
//     String midNight = '11:59 PM';
//     DateTime midNightRef = _parseTimeRef(midNight, now);

//     // print(prayerIshaEndTimeRef.isBefore(now) && midNightRef.isAfter(now));
//     if (prayerIshaEndTimeRef.isBefore(now) && midNightRef.isAfter(now)) {
//       Provider.of<PrayerCardVisibilityProvider>(context, listen: false)
//           // .setCardVisibility(false);
//           .setCardVisibility(true);
//       // print('condition 1');
//     } else {
//       // Hide the card if the condition is not met
//       Provider.of<PrayerCardVisibilityProvider>(context, listen: false)
//           .setCardVisibility(true);
//       // print('condition 2');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cardStyling = Provider.of<CardStyleProvider>(context).cardStyling;

//     DateTime selectedDate = DateTime.now();

//     void changeDate(int days) {
//       setState(() {
//         selectedDate = selectedDate.add(Duration(days: days));
//         print(selectedDate);
//       });
//     }

//     return FutureBuilder<void>(
//       future: _initializeData(), // Initialize data asynchronously
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Show a loading indicator while data is being fetched
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           // Handle errors here
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         // If data is ready, build the actual UI
//         return RefreshIndicator(
//           onRefresh: _initializeData, // Link the refresh method
//           child: SingleChildScrollView(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Text(
//                   'Welcome to ICCMW',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 19,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               IslamicDateLayoutWidget(),
//               // Container(
//               //   margin: EdgeInsets.symmetric(vertical: 8),
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //     children: [
//               //       IconButton(
//               //         onPressed: () => changeDate(-1), // Go to yesterday
//               //         icon: Icon(Icons.arrow_back_ios_new_rounded,
//               //             color: Colors.amber.),
//               //       ),
//               //       IslamicDataWidget(selectedDate: selectedDate),
//               //       IconButton(
//               //         onPressed: () => changeDate(1), // Go to tomorrow
//               //         icon: Icon(Icons.arrow_forward_ios_rounded,
//               //             color: Colors.amber),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               SizedBox(
//                 height: 4,
//               ),

//               // Container(
//               //   width: double.infinity,
//               //   margin: EdgeInsets.symmetric(horizontal: 18),
//               //   child: Wrap(
//               //     spacing: 10, // space between each item
//               //     runSpacing: 10, // space between rows if needed
//               //     children: [
//               //       ClipRRect(
//               //         borderRadius:
//               //             BorderRadius.circular(21), // add border radius
//               //         child: Container(
//               //           padding: EdgeInsets.all(16),
//               //           width: 160, // specify a fixed width for the container
//               //           height:
//               //               150, // set a fixed height to allow room for the image
//               //           decoration: BoxDecoration(
//               //             // Gradient as the top layer
//               //             gradient: LinearGradient(
//               //               begin: Alignment.topLeft,
//               //               end: Alignment.bottomRight,

//               //               colors: [
//               //                 Color.fromRGBO(255, 240, 229,
//               //                     1.5), // rgba(255,240,229,0.8) with transparency
//               //                 Color.fromRGBO(244, 194, 159,
//               //                     0.8), // rgba(244,194,159,0.8) with transparency
//               //               ],
//               //               stops: [
//               //                 0.0,
//               //                 0.45
//               //               ], // equivalent to the CSS gradient percentage
//               //             ),
//               //             // Image as the background layer
//               //             image: DecorationImage(
//               //               image: AssetImage(
//               //                   'assets/images/home_page/masjidNow.png'),
//               //               fit: BoxFit.fitWidth, // fit the image width
//               //               alignment: Alignment
//               //                   .bottomCenter, // align the image at the bottom
//               //             ),
//               //           ),
//               //           child: Column(
//               //             mainAxisAlignment: MainAxisAlignment.center,
//               //             crossAxisAlignment: CrossAxisAlignment.start,
//               //             children: [
//               //               Text(
//               //                 'Now Time is',
//               //                 style: TextStyle(
//               //                   fontFamily: 'Poppins',
//               //                   fontSize: 14,
//               //                 ),
//               //               ),
//               //               Text(
//               //                 'Dhuhur',
//               //                 style: TextStyle(
//               //                   fontFamily: 'Poppins',
//               //                   fontSize: 19,
//               //                   fontWeight: FontWeight.w600,
//               //                   color: Colors.orange,
//               //                 ),
//               //               ),
//               //               Row(
//               //                 mainAxisAlignment: MainAxisAlignment.start,
//               //                 crossAxisAlignment: CrossAxisAlignment.end,
//               //                 children: [
//               //                   Text(
//               //                     '12:27',
//               //                     style: TextStyle(
//               //                       fontFamily: 'Poppins',
//               //                       fontSize: 24,
//               //                       fontWeight: FontWeight.bold,
//               //                     ),
//               //                   ),
//               //                   Text(
//               //                     ' Pm',
//               //                     style: TextStyle(
//               //                       fontFamily: 'Poppins',
//               //                       fontSize: 14,
//               //                       fontWeight: FontWeight.bold,
//               //                     ),
//               //                   ),
//               //                 ],
//               //               ),
//               //               Row(
//               //                 children: [
//               //                   Text(
//               //                     'End Time - ',
//               //                     style: TextStyle(
//               //                       fontFamily: 'Poppins',
//               //                       fontSize: 14,
//               //                     ),
//               //                   ),
//               //                   Text(
//               //                     '3:54 Pm',
//               //                     style: TextStyle(
//               //                       fontFamily: 'Poppins',
//               //                       fontSize: 14,
//               //                       fontWeight: FontWeight.bold,
//               //                     ),
//               //                   ),
//               //                 ],
//               //               ),
//               //               SizedBox(
//               //                 height: 24,
//               //               ),
//               //             ],
//               //           ),
//               //         ),
//               //       ),
//               //       ClipRRect(
//               //         borderRadius:
//               //             BorderRadius.circular(21), // add border radius
//               //         child: Container(
//               //           padding: EdgeInsets.all(16),
//               //           width: 160, // specify a fixed width for the container
//               //           height:
//               //               150, // set a fixed height to allow room for the image
//               //           decoration: BoxDecoration(
//               //             color: Color.fromRGBO(242, 198, 167, 0.25),
//               //             image: DecorationImage(
//               //               image: AssetImage(
//               //                   'assets/images/home_page/masjid.png'),
//               //               fit: BoxFit.fitWidth, // fit the image width
//               //               alignment: Alignment
//               //                   .bottomCenter, // align the image at the bottom
//               //             ),
//               //           ),
//               //           child: Column(
//               //             mainAxisAlignment: MainAxisAlignment.center,
//               //             crossAxisAlignment: CrossAxisAlignment.start,
//               //             children: [
//               //               Text(
//               //                 'Next prayer is',
//               //                 style: TextStyle(
//               //                   fontFamily: 'Poppins',
//               //                   fontSize: 14,
//               //                 ),
//               //               ),
//               //               Text(
//               //                 'Dhuhur',
//               //                 style: TextStyle(
//               //                   fontFamily: 'Poppins',
//               //                   fontSize: 19,
//               //                   fontWeight: FontWeight.w600,
//               //                   color: Colors.amber,
//               //                 ),
//               //               ),
//               //               Row(
//               //                 mainAxisAlignment: MainAxisAlignment.start,
//               //                 crossAxisAlignment: CrossAxisAlignment.end,
//               //                 children: [
//               //                   Text(
//               //                     '12:27',
//               //                     style: TextStyle(
//               //                       fontFamily: 'Poppins',
//               //                       fontSize: 24,
//               //                       fontWeight: FontWeight.w900,
//               //                     ),
//               //                   ),
//               //                   Text(
//               //                     ' Pm',
//               //                     style: TextStyle(
//               //                       fontFamily: 'Poppins',
//               //                       fontSize: 14,
//               //                       fontWeight: FontWeight.bold,
//               //                     ),
//               //                   ),
//               //                 ],
//               //               ),
//               //               Row(
//               //                 children: [
//               //                   Text(
//               //                     'End Time - ',
//               //                     style: TextStyle(
//               //                       fontFamily: 'Poppins',
//               //                       fontSize: 14,
//               //                     ),
//               //                   ),
//               //                   Text(
//               //                     '3:54 Pm',
//               //                     style: TextStyle(
//               //                       fontFamily: 'Poppins',
//               //                       fontSize: 14,
//               //                       fontWeight: FontWeight.bold,
//               //                     ),
//               //                   ),
//               //                 ],
//               //               ),
//               //               SizedBox(
//               //                 height: 24,
//               //               ),
//               //             ],
//               //           ),
//               //         ),
//               //       ),
//               //       SizedBox(
//               //         height: 16,
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // SizedBox(
//               //   height: 16,
//               // ),
//               SizedBox(
//                 height: 16,
//               ),
//               Container(
//                 width: double.infinity,
//                 margin: EdgeInsets.symmetric(horizontal: 18),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(21), // add border radius
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//                     width: double
//                         .infinity, // specify a fixed width for the container
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(242, 198, 167, 0.25),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         IccmwWidget(),
//                         PrayerListWidget(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Container(
//                 width: double.infinity,
//                 margin: EdgeInsets.symmetric(horizontal: 18),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(21), // add border radius
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     width: double
//                         .infinity, // specify a fixed width for the container
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(242, 198, 167, 0.25),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [DayDurationWidget()],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Container(
//                 width: double.infinity,
//                 margin: EdgeInsets.symmetric(horizontal: 18),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(21), // add border radius
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     width: double
//                         .infinity, // specify a fixed width for the container
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(242, 198, 167, 0.25),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [FirdayPrayerLayoutWidget()],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//             ],
//           )),
//         );
//       },
//     );
//   }
// }
