import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:iccmw/components/commonUI/widgets/carousel/carouselWidget.dart';
import 'package:iccmw/components/commonUI/widgets/upcoming_events.dart';

import 'package:iccmw/components/navigationPages/homePage/prayerCard/prayer_card.dart';
import 'package:iccmw/features/app_settings/presentation/providers/card_style_provider.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/home_page/presentation/widgets/allah_names/allah_name_widget.dart';
import 'package:iccmw/features/home_page/presentation/widgets/calendar_widget/calendar_widget.dart';
import 'package:iccmw/features/home_page/presentation/widgets/firday_prayer/firday_prayer_layout_widget.dart';

import 'package:iccmw/features/home_page/presentation/widgets/iccmw_widget.dart';

import 'package:iccmw/features/home_page/presentation/widgets/islamic_data/islamic_date_layout_widget.dart';
import 'package:iccmw/features/home_page/presentation/widgets/pillers_widget.dart';
import 'package:iccmw/features/home_page/presentation/widgets/prayer_cards/prayer_cards_widget.dart';
import 'package:iccmw/features/home_page/presentation/widgets/prayer_cards/prayer_cards_widget_second.dart';

import 'package:iccmw/features/home_page/presentation/widgets/prayer_table/prayer_list_widget.dart';
import 'package:iccmw/features/home_page/presentation/widgets/recent_events/recent_event_widget.dart';
import 'package:iccmw/features/prayer_table/utils/shared_preference_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:iccmw/utils/notification/prayer_manager.dart';
// import 'package:iccmw/utils/notification/prayer_notification.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool gridListToggle = false;

  // final GlobalKey<PrayerCardState> _prayerCardKey =
  //     GlobalKey<PrayerCardState>();
  // final GlobalKey<CarouselwidgetState> carouselWidgetKey =
  //     GlobalKey<CarouselwidgetState>();

  // final GlobalKey<UpcomingEventsState> upcomingEventKey =
  //     GlobalKey<UpcomingEventsState>();
  Future<void> _initializeData() async {
    // This method fetches and caches the data
    await PrayerTimeCache.fetchAndCacheData();
    // await PrayerManager.fetchAndSetPrayerData();

    // await PrayerManager.fetchAndSetPrayerData();
    // await PrayerManager.schedulePrayerNotifications();
    // await _prayerCardKey.currentState?.setActiveMonth();
    // await _prayerCardKey.currentState?.setCurrentImage();
    // await carouselWidgetKey.currentState?.fetchImages();

    PrayerListWidget.reloadPrayers();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final cardStyling = Provider.of<CardStyleProvider>(context).cardStyling;

    DateTime selectedDate = DateTime.now();

    // ignore: unused_element
    void changeDate(int days) {
      setState(() {
        selectedDate = selectedDate.add(Duration(days: days));
        // print(selectedDate);
      });
    }

    return FutureBuilder<void>(
      future: _initializeData(), // Initialize data asynchronously

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while data is being fetched

          return Center(
            child: kIsWeb
                ? CircularProgressIndicator()
                : (Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator()),
          );
        } else if (snapshot.hasError) {
          // Handle errors here
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // If data is ready, build the actual UI
        return RefreshIndicator(
          onRefresh: _initializeData, // Link the refresh method
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 6,
              ),
              // Center(
              //   // margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //   child: Text(
              //     'Welcome to ICCMW',
              //     style: TextStyle(
              //       fontFamily: 'Poppins',
              //       fontSize: 19,
              //       color: Colors.green,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 4,
              // ),
              // IslamicDateLayoutWidget(),
              SizedBox(
                height: 6,
              ),
              gridListToggle ? PrayerCardsWidget() : PrayerCardsWidgetSecond(),
              SizedBox(
                height: 16,
              ),
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.symmetric(horizontal: 18),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(21), // add border radius
              //     child: Container(
              //       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              //       width: double
              //           .infinity, // specify a fixed width for the container
              //       decoration: BoxDecoration(
              //         color: cardColor,
              //       ),
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           IslamicDateLayoutWidget(),
              //           // PrayerListWidget(),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 16,
              // ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21), // add border radius
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    width: double
                        .infinity, // specify a fixed width for the container
                    decoration: BoxDecoration(
                      color: cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IslamicDateLayoutWidget(),
                        // PrayerListWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21), // add border radius
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    width: double
                        .infinity, // specify a fixed width for the container
                    decoration: BoxDecoration(
                      color: cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IccmwWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 16,
              // ),
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.symmetric(horizontal: 18),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(21), // add border radius
              //     child: Container(
              //       padding: EdgeInsets.all(16),
              //       width: double
              //           .infinity, // specify a fixed width for the container
              //       decoration: BoxDecoration(
              //         color: cardColor,
              //       ),
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [DayDurationWidget()],
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 16,
              ),
              // FridayPrayerLayoutWidget
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21), // add border radius
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double
                        .infinity, // specify a fixed width for the container
                    decoration: BoxDecoration(
                      color: cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [FirdayPrayerLayoutWidget()],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21), // add border radius
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double
                        .infinity, // specify a fixed width for the container
                    decoration: BoxDecoration(
                      color: cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Events',
                          style: TextStyle(
                            fontSize: 19,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: headingColorLight,
                          ),
                        ),
                        RecentEventWidget(),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 16,
              ),

              // Pillers of islam
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21), // add border radius
                  child: Container(
                    padding: EdgeInsets.all(24),
                    width: double
                        .infinity, // specify a fixed width for the container
                    decoration: BoxDecoration(
                      // color: Color.fromRGBO(46, 40, 44, 1),
                      color: cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [PillersWidget()],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              // Calendar
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21), // add border radius
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double
                        .infinity, // specify a fixed width for the container
                    decoration: BoxDecoration(
                      color: cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [CalendarWidget()],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              // Hadith
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.symmetric(horizontal: 18),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(21), // add border radius
              //     child: Container(
              //       padding: EdgeInsets.all(16),
              //       width: double
              //           .infinity, // specify a fixed width for the container
              //       decoration: BoxDecoration(
              //         color: cardColor,
              //       ),
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 16,
              // ),
              // 99 Names of Allah
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21), // add border radius
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double
                        .infinity, // specify a fixed width for the container
                    decoration: BoxDecoration(
                      color: cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [AllahNameWidget()],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21), // add border radius
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    width: double
                        .infinity, // specify a fixed width for the container
                    decoration: BoxDecoration(
                      color: cardColor,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Change the Box style."),
                              Switch(
                                value: gridListToggle,
                                onChanged: (value) {
                                  setState(() {
                                    gridListToggle = value;
                                  });
                                },
                                activeColor: commonComponentColor,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
            ],
          )),
        );
      },
    );
  }
}
