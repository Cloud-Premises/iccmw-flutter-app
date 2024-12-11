import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class SportsWidget extends StatefulWidget {
  const SportsWidget({super.key});

  @override
  State<SportsWidget> createState() => _SportsWidgetState();
}

class _SportsWidgetState extends State<SportsWidget> {
  late Future<SportsData> futureSportsData;

  @override
  void initState() {
    super.initState();
    futureSportsData = fetchSportsData();
  }

  Future<SportsData> fetchSportsData() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/sporstActivitiesPage/sports.json'));

    if (response.statusCode == 200) {
      return SportsData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load sports data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SportsData>(
      future: futureSportsData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data!;
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.imageUrl.isNotEmpty)
                    Image.network(data.imageUrl, width: double.infinity),

                  const SizedBox(height: 4),
                  Text(
                    data.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(data.description),
                  const SizedBox(height: 4),
                  // ListView.builder is removed from Column, replace it with a ListView directly
                  ListView.builder(
                    itemCount: data.sportsList.length,
                    shrinkWrap: true, // Add this to limit the height
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 3,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            data.sportsList[index],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 24,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              height: 16,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < 5; i++) // Create multiple shimmer items
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 6,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 16,
                      width: 100, // Adjust the width as needed
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SportsData {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> sportsList;

  SportsData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sportsList,
  });

  factory SportsData.fromJson(Map<String, dynamic> json) {
    return SportsData(
      title: json['sports']['title'],
      description: json['sports']['description'],
      imageUrl: json['sports']['imageUrl'],
      sportsList: List<String>.from(json['sports']['sportsList']),
    );
  }
}
