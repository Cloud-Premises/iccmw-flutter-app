import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => AboutUsPageState();
}

class AboutUsPageState extends State<AboutUsPage> {
  List<dynamic> boardOfTrustees = [];

  @override
  void initState() {
    super.initState();
    loadBoardOfTrusteesData();
  }

  Future<void> loadBoardOfTrusteesData() async {
    final String response =
        await rootBundle.loadString('assets/json/boardOfTrustees.json');
    final data = await json.decode(response);
    setState(() {
      boardOfTrustees = data['boardOfTrustees'];
    });
  }

  void openWebView(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    // Check if the URL can be launched
    if (await canLaunchUrl(uri)) {
      // Launch the URL in an external application
      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication, // Ensure it opens in an external browser
      );
    } else {
      // Handle the error if the URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the URL')),
      );
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ICCMWPage(url: url, title: 'ICCMW'),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        // backgroundColor: Theme.of(context).colorScheme.primary,

        title: Row(
          children: [
            const Image(
              image: AssetImage('assets/images/app/iccmwAppLogo.png'),
              width: 24.0,
              height: 24.0,
            ),
            const SizedBox(width: 10.0),
            Text(
              "About us",
              style: TextStyle(
                color: appBarTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: appBarIconColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/app/iccmwLogo.png',
                      height: 100,
                    ),
                    const Text(
                      'Islamic Community Center of Mid-Westchester',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Image.asset(
                      'assets/images/app/masjid.jpg',
                      width: double.infinity,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome to Islamic Community Center of Mid-Westchester',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '2 Grandview Blvd Yonkers, NY 10710',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Islamic Community Center of Mid-Westchester (ICCMW) was first established in February 2012 to meet the needs of our growing community. ICCMW was incorporated as non-profit in State of NY on 03/25/2012..\n\n',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                'ICCMW purchased the property at 2 Grandview Blvd, Yonkers, NY in 2014. It is in a beautiful location just minutes away from major highways. ICCMW serves Muslim communities of SW Yonkers, Hartsdale, Scarsdale, and Eastchester. We are currently having Jummah prayers in the neighboring Church hall across the street from our property. Alhamdullilah we continue to see an increase in our congregation..\n\n',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                'We are currently working with the city to obtain all the legal requirements to convert 2 Grandview blvd into a Masjid/Community Center for Muslims in the area. ICCMW is a tax-deductible 501(c)(3) organization. Our Tax Id is 46-0649530.',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              // Displaying Board of Trustees
              const Text(
                'Board of Trustees:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              boardOfTrustees.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boardOfTrustees.length,
                      itemBuilder: (context, index) {
                        final trustee = boardOfTrustees[index];
                        return Card(
                          color: Colors.white,
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: trustee['image'] != null &&
                                          trustee['image'].isNotEmpty
                                      ? Image.network(
                                          trustee['image'],
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                                Icons.broken_image,
                                                size: 50);
                                          },
                                        )
                                      : const Icon(Icons.broken_image,
                                          size: 50),
                                ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(8.0),
                                //   child: Image.network(trustee['image']),
                                // ),
                                const SizedBox(height: 8),
                                Text(
                                  trustee['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  trustee['designation'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    trustee['about'].length,
                                    (i) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "- ${trustee['about'][i]}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: kIsWeb
                          ? CircularProgressIndicator()
                          : (Platform.isAndroid
                              ? CircularProgressIndicator()
                              : CupertinoActivityIndicator()),
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
