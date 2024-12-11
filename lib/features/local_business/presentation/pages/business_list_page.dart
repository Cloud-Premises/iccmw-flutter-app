// lib/pages/business_list_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/local_business/data/model/subcategory.dart';
import 'package:iccmw/features/local_business/presentation/widgets/business_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class BusinessListPage extends StatefulWidget {
  final SubCategory subcategory;

  const BusinessListPage({Key? key, required this.subcategory})
      : super(key: key);

  @override
  _BusinessListPageState createState() => _BusinessListPageState();
}

class _BusinessListPageState extends State<BusinessListPage> {
  List<dynamic> businesses = []; // List to hold fetched businesses
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchBusinesses(widget
        .subcategory.jsonUrl); // Fetch businesses when the widget initializes
  }

  Future<void> fetchBusinesses(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parse the JSON data
        final data = json.decode(response.body);

        // Check if data is present
        if (data['subcategories'] != null &&
            data['subcategories']['data'] != null) {
          // Filter businesses by matching subcategory ID
          businesses = data['subcategories']['data'].where((business) {
            return business['subcategoriesId'] == widget.subcategory.id;
          }).toList();
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching businesses: $e'); // Handle the error appropriately
      businesses = []; // Set to empty list in case of an error
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: Text(
          '${widget.subcategory.name} Businesses',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(
              child: kIsWeb
                  ? CircularProgressIndicator()
                  : (Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator()),
            ) // Show loading indicator
          : businesses.isEmpty
              ? Center(
                  child: Text(
                      "No Business listed")) // Show message if no businesses
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: businesses.length,
                  itemBuilder: (context, index) {
                    final business = businesses[index];
                    // Get the image URL, or use the default image if not available
                    String imageUrl = business['imageUrl'] != ''
                        ? business['imageUrl']
                        : 'https://i.imgur.com/eVOkjHc.png';

                    return BusinessCard(
                      imageUrl: imageUrl,
                      businessName:
                          business['title'], // Assuming 'title' exists
                      businessDescription: business['description'] != null
                          ? '${business['description']}'
                          : " ", // Provide a description
                      jsonUrl: widget.subcategory.jsonUrl, // Pass jsonUrl
                      businessId: business['id'], // Pass businessId
                    );
                  },
                ),
    );
  }
}
