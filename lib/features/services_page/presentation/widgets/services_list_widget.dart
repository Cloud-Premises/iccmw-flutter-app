import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:iccmw/features/services_page/presentation/widgets/services_listTile_widget.dart';

class ServicesListWidget extends StatefulWidget {
  const ServicesListWidget({super.key});

  @override
  State<ServicesListWidget> createState() => _ServicesListWidgetState();
}

class _ServicesListWidgetState extends State<ServicesListWidget> {
  List<Map<String, dynamic>> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/servicesPage/services.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final servicesList = jsonData['services'] as List;

        setState(() {
          services = servicesList
              .map(
                  (service) => {'id': service['id'], 'title': service['title']})
              .toList();
          isLoading = false;
        });
      } else {
        // print('Failed to load services');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // print('Error fetching services: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchServices, // Call fetchServices when refreshing
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 4),
            isLoading ? buildShimmerLoading() : buildServicesList(),
          ],
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

  Widget buildServicesList() {
    return Column(
      children: services
          .map((service) => ServicesListtileWidget(
                serviceTitle: service['title'],
                serviceId: service['id'],
              ))
          .toList(),
    );
  }
}
