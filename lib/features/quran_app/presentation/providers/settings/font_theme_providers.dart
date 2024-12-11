// font_theme_providers.dart

import 'package:flutter/material.dart';

enum ThemeColors {
  green,
  orange,
  black,
  yellow,
  blue,
}

// Arabic Font Style Provider
class ArabicFontProvider with ChangeNotifier {
  String _arabicFont = 'Uthmani2';

  String get arabicFont => _arabicFont;

  void setArabicFont(String newFont) {
    _arabicFont = newFont;
    notifyListeners();
  }
}

// English Font Style Provider
class EnglishFontProvider with ChangeNotifier {
  String _englishFont = 'Poppins';

  String get englishFont => _englishFont;

  void setEnglishFont(String newFont) {
    _englishFont = newFont;
    notifyListeners();
  }
}

class ThemeColorProvider with ChangeNotifier {
  ThemeColors _selectedColor = ThemeColors.green;

  ThemeColors get selectedColor => _selectedColor;

  Color get themeColor {
    switch (_selectedColor) {
      case ThemeColors.black:
        return Colors.black87;
      case ThemeColors.green:
        return Colors.green[50]!;
      case ThemeColors.orange:
        return Colors.orange[50]!;
      case ThemeColors.yellow:
        return Colors.yellow[50]!;
      case ThemeColors.blue:
        return Colors.blue[50]!;
    }
  }

  Color get themeSelectedColor {
    switch (_selectedColor) {
      case ThemeColors.black:
        return Colors.black87;
      case ThemeColors.green:
        return Colors.green[50]!;
      case ThemeColors.orange:
        return Colors.orange[50]!;
      case ThemeColors.yellow:
        return Colors.yellow[50]!;
      case ThemeColors.blue:
        return Colors.blue[50]!;
    }
  }

  void setThemeColor(ThemeColors newColor) {
    _selectedColor = newColor;
    notifyListeners();
  }
}
