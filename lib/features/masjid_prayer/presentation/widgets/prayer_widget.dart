import 'package:flutter/material.dart';

class PrayerWidget extends StatefulWidget {
  final String prayerName;
  final String prayerTime;
  final bool activePrayer;

  const PrayerWidget({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.activePrayer,
  });

  @override
  State<PrayerWidget> createState() => _PrayerWidgetState();
}

class _PrayerWidgetState extends State<PrayerWidget> {
  @override
  Widget build(BuildContext context) {
    Color containerColor = Theme.of(context).primaryColor;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: widget.activePrayer ? containerColor : Colors.white,
        shape: BoxShape.circle, // Make the container circular
        border: Border.all(
          color: containerColor, // Border color
          width: 2.0, // Border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            spreadRadius: 1, // Spread radius
            blurRadius: 1, // Blur radius
            offset: Offset(0, 3), // Offset in X and Y direction
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.prayerName,
            style: TextStyle(
                fontSize: 14,
                color: widget.activePrayer ? Colors.white : containerColor,
                fontWeight: FontWeight.bold),
          ),
          Text(
            widget.prayerTime,
            style: TextStyle(
                fontSize: 14,
                color: widget.activePrayer ? Colors.white : containerColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
