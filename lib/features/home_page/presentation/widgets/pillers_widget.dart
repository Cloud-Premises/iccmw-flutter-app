import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class PillersWidget extends StatelessWidget {
  const PillersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Pillers Of Islam',
          style: TextStyle(
              color: headingColorLight,
              fontSize: 26,
              fontFamily: 'Amita',
              fontWeight: FontWeight.bold),
        ),
        Text(
          'Be sure to hold these pillars of Islam very close to your heart. May Allah guide you on the right path. Take a closer look at these',
          style: TextStyle(
            color: headingColorThree,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // color: const Color.fromRGBO(215, 171, 38, 1),
                color: headingColorLight,
                // color: Colors.amber[700],
                shape: BoxShape.circle, // Makes the container circular
              ),
              alignment: Alignment.center, // Centers the text inside the circle
              child: Text(
                '1',
                style: TextStyle(
                  color: headingColorOne,
                  fontSize: 24,
                  fontFamily: 'Amita',
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shahadah',
                  style: TextStyle(
                    color: headingColorTwo,
                    fontSize: 21,
                    fontFamily: 'Amita',
                  ),
                ),
                Text(
                  'FAITH',
                  style: TextStyle(
                    // color: const Color.fromRGBO(215, 171, 38, 1),
                    color: headingColorLight,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // color: const Color.fromRGBO(215, 171, 38, 1),
                color: headingColorLight,
                // color: Colors.amber[700],
                shape: BoxShape.circle, // Makes the container circular
              ),
              alignment: Alignment.center, // Centers the text inside the circle
              child: Text(
                '2',
                style: TextStyle(
                  color: headingColorOne,
                  fontSize: 24,
                  fontFamily: 'Amita',
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salah',
                  style: TextStyle(
                    color: headingColorTwo,
                    fontSize: 21,
                    fontFamily: 'Amita',
                  ),
                ),
                Text(
                  'PRAYER',
                  style: TextStyle(
                    // color: const Color.fromRGBO(215, 171, 38, 1),
                    color: headingColorLight,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // color: const Color.fromRGBO(215, 171, 38, 1),
                color: headingColorLight,
                // color: Colors.amber[700],
                shape: BoxShape.circle, // Makes the container circular
              ),
              alignment: Alignment.center, // Centers the text inside the circle
              child: Text(
                '3',
                style: TextStyle(
                  color: headingColorOne,
                  fontSize: 24,
                  fontFamily: 'Amita',
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sawm',
                  style: TextStyle(
                    color: headingColorTwo,
                    fontSize: 21,
                    fontFamily: 'Amita',
                  ),
                ),
                Text(
                  'FASTING',
                  style: TextStyle(
                    // color: const Color.fromRGBO(215, 171, 38, 1),
                    color: headingColorLight,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // color: const Color.fromRGBO(215, 171, 38, 1),
                color: headingColorLight,
                // color: Colors.amber[700],
                shape: BoxShape.circle, // Makes the container circular
              ),
              alignment: Alignment.center, // Centers the text inside the circle
              child: Text(
                '4',
                style: TextStyle(
                  color: headingColorOne,
                  fontSize: 24,
                  fontFamily: 'Amita',
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zakat',
                  style: TextStyle(
                    color: headingColorTwo,
                    fontSize: 21,
                    fontFamily: 'Amita',
                  ),
                ),
                Text(
                  'ALMSGIVING',
                  style: TextStyle(
                    // color: const Color.fromRGBO(215, 171, 38, 1),
                    color: headingColorLight,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // color: const Color.fromRGBO(215, 171, 38, 1),
                color: headingColorLight,
                // color: Colors.amber[700],
                shape: BoxShape.circle, // Makes the container circular
              ),
              alignment: Alignment.center, // Centers the text inside the circle
              child: Text(
                '5',
                style: TextStyle(
                  color: headingColorOne,
                  fontSize: 24,
                  fontFamily: 'Amita',
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hajj',
                  style: TextStyle(
                    color: headingColorTwo,
                    fontSize: 21,
                    fontFamily: 'Amita',
                  ),
                ),
                Text(
                  'PILGRIMAGE',
                  style: TextStyle(
                    // color: const Color.fromRGBO(215, 171, 38, 1),
                    color: headingColorLight,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
