// lib/widgets/business_card.dart
import 'package:flutter/material.dart';
import 'package:iccmw/features/local_business/presentation/pages/business_detail_page.dart';
// import 'package:iccmw/pages/business_detail_page.dart'; // Make sure to import your detail page

class BusinessCard extends StatelessWidget {
  final String imageUrl;
  final String businessName;
  final String businessDescription;
  final String jsonUrl; // New parameter for jsonUrl
  final int businessId; // New parameter for businessId

  const BusinessCard({
    Key? key,
    required this.imageUrl,
    required this.businessName,
    required this.businessDescription,
    required this.jsonUrl, // Include jsonUrl in the constructor
    required this.businessId, // Include businessId in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to BusinessDetailPage on tap and pass jsonUrl and businessId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailPage(
              imageUrl: imageUrl,
              businessName: businessName,
              businessDescription: businessDescription,
              jsonUrl: jsonUrl, // Pass jsonUrl
              businessId: businessId, // Pass businessId
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(top: 2, right: 4, left: 4),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 130,
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        businessName,
                        style: const TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        businessDescription,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
