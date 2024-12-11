import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/tasbeeh/presentation/providers/select_image_provider.dart';
import 'package:provider/provider.dart';

class BackgroudPage extends StatefulWidget {
  const BackgroudPage({super.key});

  @override
  State<BackgroudPage> createState() => _BackgroudPageState();
}

class _BackgroudPageState extends State<BackgroudPage> {
  // List of background images
  final List<String> backgroundImage = [
    'assets/images/tasbeeh/image1.png',
    'assets/images/tasbeeh/image2.png',
    'assets/images/tasbeeh/image3.png',
    'assets/images/tasbeeh/image4.png',
    'assets/images/tasbeeh/image5.png',
    'assets/images/tasbeeh/image6.png',
    'assets/images/tasbeeh/image7.png',
    'assets/images/tasbeeh/image8.png',
    'assets/images/tasbeeh/image10.png',
    // "assets/images/tasbeeh/noImage.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        // backgroundColor: const Color.fromRGBO(0, 153, 51, 1),
        backgroundColor: appBarColor,
        title: Text(
          'Tasbeeh - Background Image',
          style: TextStyle(
            color: appBarTextColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: appBarIconColor,
          ),
        ),
      ),
      body: Consumer<SelectedImageProvider>(
        // Consumer to listen to the selected image
        builder: (context, selectedImageProvider, child) {
          return GridView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 images per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: backgroundImage.length,
            itemBuilder: (context, index) {
              final image = backgroundImage[index];
              final isSelected = selectedImageProvider.selectedImage == image;

              return GestureDetector(
                onTap: () {
                  // Update the selected image when an image is tapped
                  selectedImageProvider.selectedImage = image;
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? Colors.green
                          : Colors.transparent, // Green border if selected
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
