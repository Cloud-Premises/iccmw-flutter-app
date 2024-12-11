// lib/features/social_media_page/presentation/pages/social_media_list_page.dart

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iccmw/features/social_media_page/presentation/widgets/social_media_widget.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class SocialMediaListPage extends StatefulWidget {
  const SocialMediaListPage({super.key});

  @override
  State<SocialMediaListPage> createState() => SocialMediaListPageState();
}

class SocialMediaListPageState extends State<SocialMediaListPage> {
  late Future<List<Map<String, dynamic>>> _socialMediaList;

  @override
  void initState() {
    super.initState();
    _socialMediaList = fetchSocialMedia();
  }

  Future<List<Map<String, dynamic>>> fetchSocialMedia() async {
    final url = Uri.parse(
      'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/socialMediaPage/socialMedia.json',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> socialMediaJson = jsonData['socialMedia'];
      return socialMediaJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load social media data');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _socialMediaList = fetchSocialMedia(); // Fetch new data
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _socialMediaList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: kIsWeb
                ? CircularProgressIndicator()
                : (Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator()),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No social media data found.'));
        } else {
          final socialMediaList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshData, // Handle refresh
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WhatsApp Groups & Community',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Generate a list of SocialMediaWidget
                    ...socialMediaList.map(
                      (item) => SocialMediaWidget(
                        title: item['title'] ?? '',
                        description: item['description'] ?? '',
                        socialMediaIcon: item['icon'],
                        socialMediaUrl: item['mediaUrl'] ?? '',
                        qrImageUrl: item['qrImageUrl'] ?? '',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
