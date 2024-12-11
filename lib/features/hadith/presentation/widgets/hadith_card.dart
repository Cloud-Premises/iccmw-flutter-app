import 'package:flutter/material.dart';

class HadithCard extends StatefulWidget {
  const HadithCard({super.key});

  @override
  State<HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends State<HadithCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 200,
      child: Card(
        color: Colors.green[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Book name',
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '1200',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Intern',
              ),
            ),
            Text(
              'data',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
