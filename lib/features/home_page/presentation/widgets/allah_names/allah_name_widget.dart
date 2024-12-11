// File: lib/features/home_page/presentation/widgets/allah_names/allah_name_widget.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:iccmw/features/99_names/presentation/pages/allah_names_page.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/home_page/presentation/widgets/allah_names/name_widget.dart';
import 'package:shimmer/shimmer.dart';

class AllahNameWidget extends StatefulWidget {
  const AllahNameWidget({super.key});

  @override
  State<AllahNameWidget> createState() => _AllahNameWidgetState();
}

class _AllahNameWidgetState extends State<AllahNameWidget> {
  List<Map<String, dynamic>> names = [];
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    loadNames();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadNames() async {
    final String response = await rootBundle
        .loadString('assets/json/namesOfAllah/default/namesOfAllah.json');
    final data = json.decode(response);
    setState(() {
      names = List<Map<String, dynamic>>.from(data['names']);
    });
  }

  void previousName() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void nextName() {
    if (currentIndex < names.length - 1) {
      setState(() {
        currentIndex++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 24,
                  width: 150,
                  color: Colors.white,
                ),
                Icon(
                  Icons.fullscreen,
                  color: commonComponentColor,
                  size: 36,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios_rounded,
                  color: commonComponentColor,
                  size: 36,
                ),
                Column(
                  children: [
                    Container(
                      height: 62,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 24,
                      width: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 160,
                      color: Colors.white,
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: commonComponentColor,
                  size: 36,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '99 Names of Allah',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: headingColorLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllahNamesPage()),
                );
              },
              icon: const Icon(
                Icons.fullscreen,
                color: Colors.orange,
                size: 36,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        NamesWidget(),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     IconButton(
        //       onPressed: previousName,
        //       icon: const Icon(
        //         Icons.arrow_back_ios_rounded,
        //         color: Colors.orange,
        //         size: 36,
        //       ),
        //     ),
        //     Expanded(
        //       child: SizedBox(
        //         height: 220, // Adjust this height as needed
        //         child: PageView.builder(
        //           controller: _pageController,
        //           itemCount: names.length,
        //           onPageChanged: (index) {
        //             setState(() {
        //               currentIndex =
        //                   index; // Update currentIndex based on page changes
        //             });
        //           },
        //           itemBuilder: (context, index) {
        //             final nameData = names[index];
        //             return Column(
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   nameData['Name'] ?? '',
        //                   style: const TextStyle(
        //                     fontFamily: 'Pdms',
        //                     fontSize: 64,
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 ),
        //                 const SizedBox(height: 4),
        //                 Text(
        //                   nameData['Transliteration'] ?? '',
        //                   style: const TextStyle(
        //                     fontFamily: 'Poppins',
        //                     fontSize: 24,
        //                     fontWeight: FontWeight.bold,
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 ),
        //                 const SizedBox(height: 4),
        //                 Text(
        //                   nameData['Meaning'] ?? '',
        //                   style: const TextStyle(
        //                     fontFamily: 'Poppins',
        //                     fontSize: 16,
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 ),
        //               ],
        //             );
        //           },
        //         ),
        //       ),
        //     ),
        //     IconButton(
        //       onPressed: nextName,
        //       icon: const Icon(
        //         Icons.arrow_forward_ios_rounded,
        //         color: Colors.orange,
        //         size: 36,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
