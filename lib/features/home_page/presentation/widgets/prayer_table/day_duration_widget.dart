import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class DayDurationWidget extends StatefulWidget {
  const DayDurationWidget({super.key});

  @override
  State<DayDurationWidget> createState() => _DayDurationWidgetState();
}

class _DayDurationWidgetState extends State<DayDurationWidget> {
  String? sunrise;
  String? sunset;
  String? solarNoon;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSunTimes();
  }

  Future<void> fetchSunTimes() async {
    final url = Uri.parse(
        'https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'];
        setState(() {
          sunrise = results['sunrise'];
          sunset = results['sunset'];
          solarNoon = results['solar_noon'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 14,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget buildSunTimeColumn(String title, String? time) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontFamily: 'Intern',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          time ?? 'Loading...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'Intern',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        isLoading
            ? buildShimmerEffect()
            : buildSunTimeColumn('Sunrise', sunrise),
        Container(
          width: 2,
          height: 32,
          color: Colors.orange,
        ),
        isLoading
            ? buildShimmerEffect()
            : buildSunTimeColumn('Mid Day', solarNoon),
        Container(
          width: 2,
          height: 32,
          color: Colors.orange,
        ),
        isLoading ? buildShimmerEffect() : buildSunTimeColumn('Sunset', sunset),
      ],
    );
  }
}
