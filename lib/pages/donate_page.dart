// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shimmer/shimmer.dart';
// import 'dart:async'; // Import for Timer
// import 'package:url_launcher/url_launcher.dart'; // Import your WebViewPage

// import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

// class DonatePage extends StatefulWidget {
//   const DonatePage({super.key});

//   @override
//   State<DonatePage> createState() => DonatePageState();
// }

// class DonatePageState extends State<DonatePage> {
//   List<dynamic> donations = [];
//   bool isLoading = true; // Add loading state
//   bool hasError = false; // Add error state to track if request fails
//   bool showShimmer = true; // New state to control shimmer duration
//   final int shimmerDuration = 5; // Duration of shimmer effect in seconds
//   Timer? _shimmerTimer; // Timer reference for shimmer

//   @override
//   void initState() {
//     super.initState();
//     startShimmerTimer(); // Start the shimmer timer
//     fetchDonations();
//   }

//   // Timer to stop shimmer after certain duration
//   void startShimmerTimer() {
//     _shimmerTimer = Timer(Duration(seconds: shimmerDuration), () {
//       if (mounted) {
//         // Check if widget is still in the tree
//         setState(() {
//           showShimmer = false; // Stop showing shimmer after duration ends
//         });
//       }
//     });
//   }

//   // Fetch donations data from API
//   Future<void> fetchDonations() async {
//     setState(() {
//       isLoading = true; // Set loading state to true before request
//       hasError = false; // Reset error state
//     });

//     try {
//       final response = await http.get(Uri.parse(
//           'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/donationPage/donation.json'));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (mounted) {
//           // Ensure widget is mounted before calling setState
//           setState(() {
//             donations = data['donation']; // Update donations with fetched data
//             isLoading =
//                 false; // Set loading state to false after request completes
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             hasError = true; // Set error state if request fails
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           hasError = true; // Set error state in case of any exception
//           isLoading = false;
//         });
//       }
//     }
//   }

//   // Refresh the page by re-fetching the donations data
//   Future<void> _refreshDonations() async {
//     await fetchDonations(); // Re-fetch the donations data
//     print('Donations refreshed');
//   }

//   @override
//   void dispose() {
//     _shimmerTimer
//         ?.cancel(); // Cancel the shimmer timer when the widget is disposed
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: _refreshDonations, // Trigger refresh when pulled down
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 12.0,
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 18),
//               child: Column(
//                 children: [
//                   Text(
//                     '"Help Those in Need"',
//                     style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Poppins'),
//                   ),
//                   SizedBox(height: 10), // Optional spacing between texts
//                   Text(
//                     "Believe in Allah and His messenger, and spend (in charity) out of the (substance) whereof He has made you heirs. For, those of you who believe and spend (in charity),- for them is a great Reward. [Quran 57:7]",
//                     style: TextStyle(
//                       fontSize: 16,
//                       // fontWeight: FontWeight.bold,
//                       fontFamily: 'Poppins',
//                       color: Colors.green,
//                     ),
//                     maxLines: null, // Allows the text to take multiple lines
//                     overflow:
//                         TextOverflow.visible, // Optional, to show all text
//                     textAlign: TextAlign.center, // Optional, center the text
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 12.0,
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 18),
//               child: const Text(
//                 'Donation',
//                 textAlign: TextAlign.right,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 12.0,
//             ),
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               child: isLoading &&
//                       showShimmer // Only show shimmer if loading and shimmer timer not ended
//                   ? _buildShimmerEffect() // Show shimmer while loading
//                   : hasError
//                       ? _buildErrorWidget() // Show error message if request fails
//                       : _buildDonationWrap(), // Display donations using Wrap
//             ),
//             const SizedBox(
//               height: 32.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Shimmer effect widget for loading state
//   Widget _buildShimmerEffect() {
//     return Wrap(
//       spacing: 12, // Horizontal spacing between children
//       runSpacing: 12, // Vertical spacing between rows
//       children: List.generate(12, (index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             width: (MediaQuery.of(context).size.width / 2) -
//                 26, // Adjust width to fit 2 columns
//             height: 60, // Adjust height as needed
//             decoration: BoxDecoration(
//               color: cardColor,
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   // Widget to show error message
//   Widget _buildErrorWidget() {
//     return Center(
//       child: Column(
//         children: [
//           const SizedBox(height: 20), // Add some spacing at the top
//           const Text(
//             "No Internet connection",
//             style: TextStyle(fontSize: 18, color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   // Replace GridView with Wrap to display donation data
//   Widget _buildDonationWrap() {
//     return Wrap(
//       spacing: 12, // Horizontal spacing between children
//       runSpacing: 12, // Vertical spacing between rows
//       children: donations
//           .map<Widget>((donation) =>
//               _buildDonationName(donation['title'], donation['link']))
//           .toList(),
//     );
//   }

//   Widget _buildDonationName(String donationName, String link) {
//     void openDonation(BuildContext context, String url) async {
//       final Uri uri = Uri.parse(url);

//       // Check if the URL can be launched
//       if (await canLaunchUrl(uri)) {
//         // Launch the URL in an external application
//         await launchUrl(
//           uri,
//           mode: LaunchMode
//               .externalApplication, // Ensure it opens in an external browser
//         );
//       } else {
//         // Handle the error if the URL cannot be launched
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Could not launch the URL')),
//         );
//       }
//     }

//     return GestureDetector(
//       onTap: () {
//         openDonation(context, link);
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => WebViewPage(url: link, title: donationName),
//         //   ),
//         // );
//       },
//       child: Container(
//         width: (MediaQuery.of(context).size.width / 2) - 26, // Adjust width
//         height: 60, // Adjust height as needed
//         decoration: BoxDecoration(
//           // color: Colors.grey[200],
//           // color: Color.fromRGBO(242, 198, 167, 0.25),
//           color: cardColor,

//           borderRadius: BorderRadius.circular(8), // Border radius
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.grey.withOpacity(0.2), // Shadow color
//           //     spreadRadius: 1, // Spread radius
//           //     blurRadius: 1, // Blur radius
//           //     offset: const Offset(0, 2), // Offset in x and y directions
//           //   ),
//           // ],
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           donationName,
//           style: const TextStyle(
//             fontSize: 18,
//             color: const Color.fromRGBO(255, 152, 0, 1),
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'dart:async'; // Import for Timer
import 'package:url_launcher/url_launcher.dart';

import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => DonatePageState();
}

class DonatePageState extends State<DonatePage> {
  List<dynamic> donations = [];
  bool isLoading = true; // Add loading state
  bool hasError = false; // Add error state to track if request fails
  bool showShimmer = true; // New state to control shimmer duration
  final int shimmerDuration = 5; // Duration of shimmer effect in seconds
  Timer? _shimmerTimer; // Timer reference for shimmer

  @override
  void initState() {
    super.initState();
    startShimmerTimer(); // Start the shimmer timer
    fetchDonations();
  }

  // Timer to stop shimmer after certain duration
  void startShimmerTimer() {
    _shimmerTimer = Timer(Duration(seconds: shimmerDuration), () {
      if (mounted) {
        // Check if widget is still in the tree
        setState(() {
          showShimmer = false; // Stop showing shimmer after duration ends
        });
      }
    });
  }

  // Fetch donations data from API
  Future<void> fetchDonations() async {
    setState(() {
      isLoading = true; // Set loading state to true before request
      hasError = false; // Reset error state
    });

    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/donationPage/donation.json'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          // Ensure widget is mounted before calling setState
          setState(() {
            donations = data['donation']; // Update donations with fetched data
            isLoading =
                false; // Set loading state to false after request completes
          });
        }
      } else {
        if (mounted) {
          setState(() {
            hasError = true; // Set error state if request fails
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true; // Set error state in case of any exception
          isLoading = false;
        });
      }
    }
  }

  // Refresh the page by re-fetching the donations data
  Future<void> _refreshDonations() async {
    await fetchDonations(); // Re-fetch the donations data
    print('Donations refreshed');
  }

  @override
  void dispose() {
    _shimmerTimer
        ?.cancel(); // Cancel the shimmer timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshDonations, // Trigger refresh when pulled down
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Text(
                    '"Help Those in Need"',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 10), // Optional spacing between texts
                  Text(
                    "Believe in Allah and His messenger, and spend (in charity) out of the (substance) whereof He has made you heirs. For, those of you who believe and spend (in charity),- for them is a great Reward. [Quran 57:7]",
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.green,
                    ),
                    maxLines: null, // Allows the text to take multiple lines
                    overflow:
                        TextOverflow.visible, // Optional, to show all text
                    textAlign: TextAlign.center, // Optional, center the text
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              child: const Text(
                'Donation',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: isLoading &&
                      showShimmer // Only show shimmer if loading and shimmer timer not ended
                  ? _buildShimmerEffect() // Show shimmer while loading
                  : hasError
                      ? _buildErrorWidget() // Show error message if request fails
                      : _buildDonationWrap(), // Display donations using Wrap
            ),
            const SizedBox(
              height: 32.0,
            ),
          ],
        ),
      ),
    );
  }

  // Shimmer effect widget for loading state
  Widget _buildShimmerEffect() {
    return Wrap(
      spacing: 12, // Horizontal spacing between children
      runSpacing: 12, // Vertical spacing between rows
      children: List.generate(12, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: (MediaQuery.of(context).size.width / 2) -
                26, // Adjust width to fit 2 columns
            height: 60, // Adjust height as needed
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }),
    );
  }

  // Widget to show error message
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20), // Add some spacing at the top
          const Text(
            "No Internet connection",
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Replace GridView with Wrap to display donation data
  Widget _buildDonationWrap() {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the number of columns based on screen size
    int crossAxisCount =
        (screenWidth / 180).floor(); // Adjust 180 based on your column size

    // Ensure at least 1 column is visible
    crossAxisCount = crossAxisCount > 0 ? crossAxisCount : 1;

    void openDonation(BuildContext context, String url) async {
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
    }

    return Wrap(
      spacing: 12, // Horizontal spacing between children
      runSpacing: 12, // Vertical spacing between rows
      children: donations.map<Widget>((donation) {
        return GestureDetector(
          onTap: () {
            openDonation(context, donation['link']);
          },
          child: Container(
            width: (screenWidth / crossAxisCount) -
                26, // Dynamic width for each column
            height: 60, // Adjust height as needed
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              donation['title'],
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(255, 152, 0, 1),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }
}
