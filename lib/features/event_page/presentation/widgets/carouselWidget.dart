// // File: lib/widgets/carousel_widget.dart
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:shimmer/shimmer.dart';

// class CarouselWidget extends StatefulWidget {
//   final List<String> images;

//   const CarouselWidget({
//     Key? key,
//     required this.images,
//   }) : super(key: key);

//   @override
//   State<CarouselWidget> createState() => _CarouselWidgetState();
// }

// class _CarouselWidgetState extends State<CarouselWidget> {
//   int activeIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (widget.images.isEmpty)
//           const Text('No images available')
//         else
//           buildCarouselSlider(),
//       ],
//     );
//   }

//   // Carousel slider for images
//   Widget buildCarouselSlider() {
//     return Column(
//       children: [
//         CarouselSlider.builder(
//           itemCount: widget.images.length,
//           itemBuilder: (context, index, realIndex) {
//             final urlImage = widget.images[index];
//             return buildImage(context, urlImage, index);
//           },
//           options: CarouselOptions(
//             autoPlay: true,
//             height: 300, // Increased height for better visibility
//             viewportFraction: 0.9, // Slightly increased for better scaling
//             aspectRatio: 16 / 9,
//             autoPlayInterval: const Duration(seconds: 5),
//             enableInfiniteScroll: true,
//             enlargeCenterPage: true,
//             autoPlayCurve: Curves.fastOutSlowIn,
//             onPageChanged: (index, reason) =>
//                 setState(() => activeIndex = index),
//           ),
//         ),
//         const SizedBox(height: 12),
//         buildIndicator(),
//       ],
//     );
//   }

//   // Image widget with CachedNetworkImage
//   Widget buildImage(BuildContext context, String urlImage, int index) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => FullScreenImageViewer(
//               images: widget.images,
//               initialIndex: index,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: CachedNetworkImage(
//             imageUrl: urlImage,
//             fit: BoxFit.cover,
//             placeholder: (context, url) => buildShimmerEffect(height: 300),
//             errorWidget: (context, url, error) => const Center(
//               child: Text(
//                 'No Image Found',
//                 style:
//                     TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Reusable shimmer effect widget for loading state
//   Widget buildShimmerEffect({required double height}) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         height: height,
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }

//   // Indicator for carousel images
//   Widget buildIndicator() => AnimatedSmoothIndicator(
//         effect: const ExpandingDotsEffect(
//           dotWidth: 8,
//           dotHeight: 8,
//           activeDotColor: Colors.blue,
//         ),
//         activeIndex: activeIndex,
//         count: widget.images.length,
//       );
// }

// class FullScreenImageViewer extends StatelessWidget {
//   final List<String> images;
//   final int initialIndex;

//   const FullScreenImageViewer({
//     Key? key,
//     required this.images,
//     this.initialIndex = 0,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Allows the image to extend behind the app bar
//       extendBodyBehindAppBar: true,
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: PhotoViewGallery.builder(
//         scrollPhysics: const BouncingScrollPhysics(),
//         builder: (BuildContext context, int index) {
//           return PhotoViewGalleryPageOptions(
//             imageProvider: NetworkImage(images[index]),
//             initialScale: PhotoViewComputedScale.contained,
//             heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
//           );
//         },
//         itemCount: images.length,
//         loadingBuilder: (context, event) {
//           // Always show shimmer effect while loading
//           return buildShimmerEffectForFullScreenImage();
//         },
//         backgroundDecoration: const BoxDecoration(
//           color: Colors.black,
//         ),
//         pageController: PageController(initialPage: initialIndex),
//       ),
//     );
//   }

//   // Shimmer effect for full-screen images
//   Widget buildShimmerEffectForFullScreenImage() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         color: Colors.grey[300],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shimmer/shimmer.dart';

class CarouselWidget extends StatefulWidget {
  final List<String> images;

  const CarouselWidget({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    // _initializeVideoControllers();
  }

  // Future<void> _initializeVideoControllers() async {
  //   // Initialize video controllers only for video URLs
  //   _videoControllers = widget.images.map((url) {
  //     if (url.endsWith('.mp4')) {
  //       // ignore: deprecated_member_use
  //       return VideoPlayerController.network(url)
  //         ..initialize().then((_) {
  //           setState(() {}); // Update state once the video is loaded
  //         });
  //     }
  //     return null;
  //   }).toList();
  // }

  @override
  void dispose() {
    // for (var controller in _videoControllers) {
    //   controller?.dispose(); // Dispose all video controllers
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.images.isEmpty)
          const Text('No images available')
        else
          buildCarouselSlider(),
      ],
    );
  }

  Widget buildCarouselSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            final urlImage = widget.images[index];
            return buildImage(context, urlImage, index);
          },
          options: CarouselOptions(
            autoPlay: true,
            height: 300, // Adjusted height for video display
            viewportFraction: 0.9,
            aspectRatio: 16 / 9,
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

  Widget buildImage(BuildContext context, String urlImage, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageViewer(
              images: widget.images,
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
            placeholder: (context, url) => buildShimmerEffect(height: 300),
            errorWidget: (context, url, error) => const Center(
              child: Text(
                'No Image Found',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildVideoPlayer(int index) {
  //   // final videoController = _videoControllers[index];

  //   if (videoController == null || !videoController.value.isInitialized) {
  //     return Center(child: buildShimmerEffect(height: 300)); // Show loading state
  //   }

  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         videoController.value.isPlaying ? videoController.pause() : videoController.play();
  //       });
  //     },
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         AspectRatio(
  //           aspectRatio: videoController.value.aspectRatio,
  //           child: VideoPlayer(videoController),
  //         ),
  //         if (!videoController.value.isPlaying)
  //           const Icon(
  //             Icons.play_arrow,
  //             color: Colors.white,
  //             size: 50.0,
  //           ),
  //       ],
  //     ),
  //   );
  // }

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

  Widget buildIndicator() => AnimatedSmoothIndicator(
        effect: const ExpandingDotsEffect(
          dotWidth: 8,
          dotHeight: 8,
          activeDotColor: Colors.blue,
        ),
        activeIndex: activeIndex,
        count: widget.images.length,
      );
}

class FullScreenImageViewer extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageViewer({
    Key? key,
    required this.images,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
        loadingBuilder: (context, event) =>
            buildShimmerEffectForFullScreenImage(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }

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
