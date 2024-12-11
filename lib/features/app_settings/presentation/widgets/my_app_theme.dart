import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart'
    as theme_provider; // Import with alias
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class MyAppTheme extends StatefulWidget {
  final Function(theme_provider.CustomThemeData)
      onThemeSelected; // Add callback parameter

  const MyAppTheme({super.key, required this.onThemeSelected});

  @override
  State<MyAppTheme> createState() => _MyAppThemeState();
}

class _MyAppThemeState extends State<MyAppTheme> {
  late Future<List<theme_provider.CustomThemeData>> _themes;
  theme_provider.CustomThemeData? _selectedTheme;

  @override
  void initState() {
    super.initState();
    _themes = theme_provider.ThemeDataProvider().loadThemes();
    _loadSelectedTheme();
  }

  // Load the selected theme from shared preferences
  Future<void> _loadSelectedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedThemeId = prefs.getInt('selectedThemeId');
    final themes = await _themes;

    if (selectedThemeId != null) {
      setState(() {
        _selectedTheme = themes.firstWhere(
          (theme) => theme.id == selectedThemeId,
          orElse: () => themes.first,
        );
      });
    }
  }

  void _selectTheme(theme_provider.CustomThemeData theme) {
    setState(() {
      _selectedTheme = theme;
    });
    widget.onThemeSelected(theme); // Notify parent widget to change the theme
    _saveSelectedTheme(theme); // Save the selected theme
  }

  // Save the selected theme to shared preferences
  Future<void> _saveSelectedTheme(theme_provider.CustomThemeData theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedThemeId', theme.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<theme_provider.CustomThemeData>>(
      future: _themes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: kIsWeb
                ? CircularProgressIndicator()
                : (Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final themes = snapshot.data!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My App Theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const Divider(
                height: 2,
                color: Colors.black26,
              ),
              const SizedBox(height: 12),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8.0,
                runSpacing: 8.0,
                children: themes.map((theme) {
                  return GestureDetector(
                    onTap: () => _selectTheme(theme),
                    child: SizedBox(
                      width: 42,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 21,
                                decoration: BoxDecoration(
                                  color: theme.color1,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 21,
                                decoration: BoxDecoration(
                                  color: theme.color2,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                          if (_selectedTheme == theme)
                            Positioned(
                              top: 10,
                              left: 0,
                              child: Image.asset(
                                'assets/images/icons/check.png',
                                width: 19,
                                height: 19,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 30,
              ),
              // WidgetDemo(),
            ],
          ),
        );
      },
    );
  }
}
