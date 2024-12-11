import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import for jsonEncode and jsonDecode

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Map<String, dynamic>> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? bookmarksJson = prefs.getStringList('bookmarks');

    if (bookmarksJson != null) {
      List<Map<String, dynamic>> loadedBookmarks = [];
      for (String bookmark in bookmarksJson) {
        try {
          loadedBookmarks.add(jsonDecode(bookmark));
        } catch (e) {
          print("Error decoding bookmark: $bookmark. Error: $e");
        }
      }
      setState(() {
        _bookmarks = loadedBookmarks;
      });
    }
  }

  Future<void> _removeBookmark(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? bookmarks = prefs.getStringList('bookmarks') ?? [];

    bookmarks.removeAt(index); // Remove bookmark at the specified index
    await prefs.setStringList('bookmarks', bookmarks);

    _loadBookmarks(); // Refresh the bookmark list
    _showSnackBar(
        'Bookmark removed successfully!'); // Show confirmation message
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        // backgroundColor: const Color.fromRGBO(0, 153, 51, 1),
        backgroundColor: appBarColor,
        title: Text(
          'Tasbeeh - Bookmarks',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _bookmarks.isEmpty
            ? const Center(child: Text('No bookmarks available.'))
            : ListView.builder(
                itemCount: _bookmarks.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.green,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        _bookmarks[index]['name'], // Display bookmark name
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Count: ${_bookmarks[index]['count']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Laps: ${_bookmarks[index]['laps']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeBookmark(index),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
