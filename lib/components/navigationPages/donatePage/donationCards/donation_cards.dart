import 'package:flutter/material.dart';

class DonationCards extends StatefulWidget {
  const DonationCards({super.key});

  @override
  State<DonationCards> createState() => DonationCardsState();
}

class DonationCardsState extends State<DonationCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.red, // You can replace 'blue' with any color you prefer
      child: Text('card'),
    );
  }
}
