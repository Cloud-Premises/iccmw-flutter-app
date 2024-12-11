// // lib/features/social_media_page/presentation/pages/qr_code_page.dart

// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// // import 'package:path_provider/path_provider.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:path/path.dart' as path;
// import 'package:permission_handler/permission_handler.dart';

// class QRCodePage extends StatelessWidget {
//   final String qrImageUrl;

//   const QRCodePage({Key? key, required this.qrImageUrl}) : super(key: key);

//   Future<void> _downloadImage(BuildContext context) async {
//     // Check and request storage permission
//     if (await Permission.storage.request().isGranted) {
//       try {
//         // Get the image from the URL
//         final response = await http.get(Uri.parse(qrImageUrl));
//         if (response.statusCode == 200) {
//           // Get the Download directory of the device
//           final directory = Directory('/storage/emulated/0/Download/');
//           // Specify the path to save the image in the Download directory
//           final filePath = path.join(directory.path, 'whatsappQr.png');

//           // Create the Download directory if it doesn't exist
//           await directory.create(recursive: true);

//           // Write the image to a file
//           final file = File(filePath);
//           await file.writeAsBytes(response.bodyBytes);

//           // Show a toast message
//           Fluttertoast.showToast(
//             msg: "QR Code image downloaded to $filePath",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.black54,
//             textColor: Colors.white,
//           );
//         } else {
//           Fluttertoast.showToast(
//             msg: "Failed to download image.",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//           );
//         }
//       } catch (e) {
//         Fluttertoast.showToast(
//           msg: "Error: $e",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "Storage permission denied.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: const Text(
//           'QR Code',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.download, color: Colors.white),
//             onPressed: () =>
//                 _downloadImage(context), // Call the download function
//           ),
//         ],
//       ),
//       body: PhotoView(
//         imageProvider: NetworkImage(qrImageUrl),
//         backgroundDecoration: BoxDecoration(
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class QRCodePage extends StatelessWidget {
  final String qrImageUrl;

  const QRCodePage({Key? key, required this.qrImageUrl}) : super(key: key);

  Future<void> _downloadImage(BuildContext context) async {
    // Check and request storage permission
    if (await Permission.storage.request().isGranted) {
      try {
        // Get the image from the URL
        final response = await http.get(Uri.parse(qrImageUrl));
        if (response.statusCode == 200) {
          // Get the Download directory of the device
          final directory = Directory('/storage/emulated/0/Download/');
          // Specify the path to save the image in the Download directory
          final filePath = path.join(directory.path, 'whatsappQr.png');

          // Create the Download directory if it doesn't exist
          await directory.create(recursive: true);

          // Write the image to a file
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          // Show a snackbar message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("QR Code image downloaded to $filePath"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to download image."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Storage permission denied."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'QR Code',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () =>
                _downloadImage(context), // Call the download function
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: NetworkImage(qrImageUrl),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}
