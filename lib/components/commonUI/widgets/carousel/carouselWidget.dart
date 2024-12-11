import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Carouselwidget extends StatefulWidget {
  // const Carouselwidget({super.key});

  @override
  // ignore: overridden_fields
  final GlobalKey<CarouselwidgetState> key;

  const Carouselwidget({required this.key}) : super(key: key);

  @override
  State<Carouselwidget> createState() => CarouselwidgetState();
}

class CarouselwidgetState extends State<Carouselwidget> {
  int activeIndex = 0;
  List<String> urlImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    const url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/homePage/announcement.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            urlImages = List<String>.from(jsonData['ImageUrl']);
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error fetching images: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          buildShimmerEffect(
              height: 200) // Display shimmer effect while loading
        else if (urlImages.isNotEmpty)
          buildCarouselSlider()
        else
          const Text('No images available'),
      ],
    );
  }

  // Carousel slider for images
  Widget buildCarouselSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: urlImages.length,
          itemBuilder: (context, index, realIndex) {
            final urlImage = urlImages[index];
            return buildImage(context, urlImage, index);
          },
          options: CarouselOptions(
            autoPlay: true,
            height: 200,
            viewportFraction: .5,
            aspectRatio: 2.0,
            autoPlayInterval: const Duration(seconds: 5),
            enableInfiniteScroll: true,
            enlargeCenterPage: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) =>
                setState(() => activeIndex = index),
          ),
        ),
        const SizedBox(height: 12),
        buildIndicator(),
      ],
    );
  }

  // Image widget with CachedNetworkImage
  Widget buildImage(BuildContext context, String urlImage, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageViewer(
              images: urlImages,
              initialIndex: index,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: urlImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => buildShimmerEffect(height: 200),
            errorWidget: (context, url, error) => const Center(
              child: Text(
                'Failed to load image',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable shimmer effect widget for loading state
  Widget buildShimmerEffect({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Indicator for carousel images
  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      effect: const ExpandingDotsEffect(
        dotWidth: 8,
        dotHeight: 8,
        activeDotColor: Colors.blue,
      ),
      activeIndex: activeIndex,
      count: urlImages.length,
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
          );
        },
        itemCount: images.length,
        loadingBuilder: (context, event) {
          // Always show shimmer effect while loading
          return buildShimmerEffectForFullScreenImage();
        },
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }

  // Shimmer effect for full-screen images
  Widget buildShimmerEffectForFullScreenImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.grey[300],
      ),
    );
  }
}
