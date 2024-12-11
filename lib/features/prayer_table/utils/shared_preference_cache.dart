import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PrayerTimeCache {
  static const String _prayerTimeCacheKey = 'prayer_time_cache';

  // Step 1: Check if cache is empty or has data
  static Future<bool> isCacheEmpty() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_prayerTimeCacheKey);
    print(data == null ? 'Cache is empty' : 'Cache has data');
    return data == null;
  }

  // Step 2: Store JSON in cache
  static Future<void> cacheData(String jsonData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prayerTimeCacheKey, jsonData);
    print('Data cached successfully');
  }

  // Step 3: Fetch data from the server and store it in cache if empty
  static Future<void> fetchAndCacheData() async {
    if (await isCacheEmpty()) {
      final data = await fetchDataFromServer();
      if (data != null) {
        await cacheData(data);
      } else {
        print('Failed to fetch data');
      }
    } else {
      print('Data already exists in cache, no need to fetch');
    }
  }

  // Step 4: Fetch and update cache on refresh
  static Future<void> updateCacheOnRefresh() async {
    final data = await fetchDataFromServer();
    if (data != null) {
      await cacheData(data);
      print('Cache updated successfully on refresh');
    } else {
      print('Failed to update cache on refresh');
    }
  }

  // Helper function to fetch data from server
  static Future<String?> fetchDataFromServer() async {
    const url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/homePage/prayerTime.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // print('Data fetched from server successfully');
        return response.body;
      } else {
        // print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching data: $e');
      return null;
    }
  }

  static Future<String?> fetchDataFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_prayerTimeCacheKey);
    print(data == null ? 'No data in cache' : 'Data fetched from cache');
    return data;
  }
}
