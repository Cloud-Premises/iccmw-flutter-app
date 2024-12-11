import 'package:flutter/material.dart';
import 'package:iccmw/components/commonUI/widgets/carousel/carouselWidget.dart';
import 'package:iccmw/components/commonUI/widgets/upcoming_events.dart';
import 'package:iccmw/components/navigationPages/homePage/fridayPrayer/friday_prayer.dart';
import 'package:iccmw/components/navigationPages/homePage/masjidPrayer/masjid_prayer.dart';
import 'package:iccmw/components/navigationPages/homePage/prayerCard/prayer_card.dart';
import 'package:iccmw/components/navigationPages/homePage/prayerTable/prayer_table_grid.dart';
import 'package:iccmw/components/navigationPages/homePage/prayerTable/prayer_table_list.dart';

class SimpleHomeWidget extends StatefulWidget {
  const SimpleHomeWidget({super.key});

  @override
  State<SimpleHomeWidget> createState() => _SimpleHomeWidgetState();
}

class _SimpleHomeWidgetState extends State<SimpleHomeWidget> {
  bool gridListToggle = true;

  final GlobalKey<PrayerCardState> _prayerCardKey =
      GlobalKey<PrayerCardState>();
  final GlobalKey<CarouselwidgetState> carouselWidgetKey =
      GlobalKey<CarouselwidgetState>();

  final GlobalKey<UpcomingEventsState> upcomingEventKey =
      GlobalKey<UpcomingEventsState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.0),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to ICCMW',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18),
          child: PrayerCard(key: _prayerCardKey),
        ),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 18),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Prayer Time',
        //          style: TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       SizedBox(height: 4.0),
        //       PrayerCard(key: _prayerCardKey),
        //     ],
        //   ),
        // ),
        // cardStyling
        //     ? CardOneStyle(prayerCardKey: _prayerCardKey)
        //     : CardTwoStyle(prayerCardKey: _prayerCardKey),
        SizedBox(height: 4.0),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'ICCMW Masjid Salah',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4.0),
            MasjidPrayer(),
          ],
        ),
        SizedBox(height: 4.0),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prayer Table',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    gridListToggle = !gridListToggle; // Toggle view
                  });
                },
                icon: Image(
                  image: AssetImage(gridListToggle
                      ? 'assets/images/icons/list.png'
                      : 'assets/images/icons/grid.png'),
                  width: 26.0,
                  height: 26.0,
                ),
              ),
            ],
          ),
        ),
        gridListToggle ? PrayerTableGrid() : PrayerTableList(),

        SizedBox(height: 4.0),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'Friday Prayers',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 4),
        FridayPrayer(),
        SizedBox(height: 8),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'Upcoming Event Updates',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 4),
        UpcomingEvents(key: upcomingEventKey),
        SizedBox(height: 12.0),
        SizedBox(height: 24.0),
      ],
    );
  }
}
