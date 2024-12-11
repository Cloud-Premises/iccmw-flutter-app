import 'package:iccmw/components/navigationPages/homePage/imageCarousel/image_carousel.dart';
import 'package:flutter/material.dart';
import 'package:iccmw/components/commonUI/widgets/carousel/carouselWidget.dart';
import 'package:iccmw/components/navigationPages/homePage/prayerCard/prayer_card.dart';
// import 'package:iccmw/components/commonUI/widgets/carousel/carouselWidget.dart';
import 'package:iccmw/features/app_settings/presentation/providers/prayer_card_visibility_provider.dart';
import 'package:provider/provider.dart';

class CardOneStyle extends StatefulWidget {
  // const CardOneStyle({super.key});
  final GlobalKey<PrayerCardState> prayerCardKey;
  // final GlobalKey<CarouselwidgetState> carouselWidgetKey;

  const CardOneStyle({super.key, required this.prayerCardKey});

  @override
  State<CardOneStyle> createState() => _CardOneStyleState();
}

class _CardOneStyleState extends State<CardOneStyle> {
  final GlobalKey<CarouselwidgetState> carouselWidgetKey =
      GlobalKey<CarouselwidgetState>();
  @override
  Widget build(BuildContext context) {
    final isCardVisible =
        context.watch<PrayerCardVisibilityProvider>().isCardVisible;
    return Column(
      children: [
        isCardVisible
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prayer Time',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    PrayerCard(key: widget.prayerCardKey),
                  ],
                ))
            : const SizedBox(
                height: 0.0,
              ),
        const SizedBox(
          height: 12.0,
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              child: const Text(
                'Annoucements',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12.0,
        ),
        ImageCarousel(carouselWidgetKey: carouselWidgetKey),
      ],
    );
  }
}
