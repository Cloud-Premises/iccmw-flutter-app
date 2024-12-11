import 'package:flutter/material.dart';

class SelectedImageProvider extends ChangeNotifier {
  String _selectedImage = 'assets/images/tasbeeh/image3.png';

  String get selectedImage => _selectedImage;

  set selectedImage(String newImage) {
    _selectedImage = newImage;
    notifyListeners(); // Notify listeners when the image changes
  }
}
