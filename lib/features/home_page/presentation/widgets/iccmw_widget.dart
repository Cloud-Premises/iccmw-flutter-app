import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:url_launcher/url_launcher.dart';

class IccmwWidget extends StatelessWidget {
  const IccmwWidget({super.key});

  void openGoogleMaps(BuildContext context, Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch $url")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => openGoogleMaps(context,
                Uri.parse('https://maps.app.goo.gl/94w8pwRC4mjabUKZ8')),
            icon: Icon(Icons.location_on),
            color: commonComponentColor,
          ),
          Expanded(
            // Use Expanded to allow text to take remaining space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ICCMW',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: headingColorLight,
                  ),
                  softWrap: true, // Allow soft wrapping
                  overflow: TextOverflow.visible, // Handle overflow
                ),
                Text(
                  'Islamic Community Center of Mid-Westchester',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: headingColorDark,
                  ),
                  softWrap: true, // Allow soft wrapping
                  overflow: TextOverflow.visible, // Handle overflow
                ),
                Text(
                  '2 Grandview Blvd Yonkers, NY 10710',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: headingColorThree,
                  ),
                  softWrap: true, // Allow soft wrapping
                  overflow: TextOverflow.visible, // Handle overflow
                ),
                Row(
                  children: [
                    Text(
                      'Timing',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),

                      softWrap: true, // Allow soft wrapping
                      overflow: TextOverflow.visible, // Handle overflow
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '5:30 AM - 8:30 PM',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                      softWrap: true, // Allow soft wrapping
                      overflow: TextOverflow.visible, // Handle overflow
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
