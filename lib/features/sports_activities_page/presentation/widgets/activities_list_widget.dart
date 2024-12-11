import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iccmw/features/sports_activities_page/presentation/widgets/activities_listTile_widget.dart';
import 'package:iccmw/features/sports_activities_page/presentation/widgets/sports_widget.dart';
import 'package:shimmer/shimmer.dart';

class ActivitiesListWidget extends StatefulWidget {
  const ActivitiesListWidget({super.key});

  @override
  State<ActivitiesListWidget> createState() => _ActivitiesListWidgetState();
}

class _ActivitiesListWidgetState extends State<ActivitiesListWidget> {
  List<Map<String, dynamic>> sports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSports();
  }

  Future<void> fetchSports() async {
    final url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/sporstActivitiesPage/sportsActivities.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final sportsList = jsonData['sportsActivities'] as List;

        setState(() {
          sports = sportsList
              .map((sports) => {'id': sports['id'], 'title': sports['title']})
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to load Sports');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching Sports: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchSports, // Call fetchSports when refreshing
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SportsWidget(),
              const SizedBox(height: 4),
              const Text(
                'Upcoming Sports Activities',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              isLoading ? buildShimmerLoading() : buildSportsList(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShimmerLoading() {
    return Column(
      children: List.generate(5, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 50.0,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }

  Widget buildSportsList() {
    return Column(
      children: sports
          .map((sports) => ActivitiesListtileWidget(
                sportsTitle: sports['title'],
                sportsId: sports['id'],
              ))
          .toList(),
    );
  }
}
