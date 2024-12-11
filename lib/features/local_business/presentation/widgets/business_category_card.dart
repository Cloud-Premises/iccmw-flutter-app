import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/local_business/data/model/subcategory.dart';
import '../pages/business_list_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusinessCategoryCard extends StatefulWidget {
  final SubCategory subcategory;

  const BusinessCategoryCard({Key? key, required this.subcategory})
      : super(key: key);

  @override
  _BusinessCategoryCardState createState() => _BusinessCategoryCardState();
}

class _BusinessCategoryCardState extends State<BusinessCategoryCard> {
  int businessCount = 0; // Variable to hold the business count

  @override
  void initState() {
    super.initState();
    fetchBusinessCount(widget.subcategory.jsonUrl); // Fetch the business count
  }

  Future<void> fetchBusinessCount(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Print the raw response for debugging
        // print('Raw Response: ${response.body}');

        // Parse the JSON data
        final data = json.decode(response.body);

        int count = 0;

        // Check if we have subcategories data
        if (data['subcategories'] != null &&
            data['subcategories']['data'] != null) {
          // Iterate through the subcategories and count those with matching subcategoriesId
          for (var item in data['subcategories']['data']) {
            if (item['subcategoriesId'] == widget.subcategory.id) {
              // Count only the direct entries in this subcategory
              count += 1; // Increment for each matched subcategory entry
            }
          }
        }

        // Update the state with the fetched count
        setState(() {
          businessCount = count;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print(
          'Error fetching business count: $e'); // Handle the error appropriately
      setState(() {
        businessCount = 0; // Set to 0 in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: listTileColor, // Background color for ListTile
        borderRadius: BorderRadius.circular(15), // Apply border radius
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Shape for the ListTile
          ),
          tileColor:
              Colors.transparent, // Set to transparent to use Material's color
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.subcategory.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 50, color: Colors.white);
              },
            ),
          ),
          title: Text(
            widget.subcategory.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Text(
            '$businessCount Businesses listed', // Display the dynamic count
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: IconButton(
            onPressed: () {
              // Handle subcategory tap, e.g., navigate to business list
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BusinessListPage(subcategory: widget.subcategory),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white),
          ),
          onTap: () {
            // Handle ListTile tap to navigate to business list
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BusinessListPage(subcategory: widget.subcategory),
              ),
            );
          },
        ),
      ),
    );
  }
}
