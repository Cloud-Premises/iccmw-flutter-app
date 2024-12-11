import 'package:iccmw/components/commonUI/widgets/carousel/carouselWidget.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final GlobalKey<CarouselwidgetState> carouselWidgetKey;

  const ImageCarousel({super.key, required this.carouselWidgetKey});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  @override
  Widget build(BuildContext context) {
    return Carouselwidget(key: widget.carouselWidgetKey);
  }
}
