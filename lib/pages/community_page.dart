// File: community_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shimmer/shimmer.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/communityPage/community.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<String> imageUrls = List<String>.from(data['ImageUrl']);
        setState(() {
          _imageUrls = imageUrls;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  void openImageViewer(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewGalleryScreen(
          imageUrls: _imageUrls,
          initialIndex: index,
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 6, // Placeholder for loading shimmer items
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
        shrinkWrap:
            true, // This makes sure the grid takes only as much space as needed
        physics:
            NeverScrollableScrollPhysics(), // Disable scrolling for shimmer
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Community',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Text(
              "Community",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            _imageUrls.isEmpty
                ? buildShimmer() // Shimmer effect while loading
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _imageUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => openImageViewer(index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(_imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                    shrinkWrap:
                        true, // Ensures GridView takes only required space
                    physics:
                        NeverScrollableScrollPhysics(), // Disable scrolling inside SingleChildScrollView
                  ),
          ],
        ),
      ),
    );
  }
}

class PhotoViewGalleryScreen extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const PhotoViewGalleryScreen(
      {Key? key, required this.imageUrls, required this.initialIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Photo Viewer',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        itemCount: imageUrls.length,
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrls[index]),
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[index]),
          );
        },
        pageController: PageController(initialPage: initialIndex),
        onPageChanged: (index) {},
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}
