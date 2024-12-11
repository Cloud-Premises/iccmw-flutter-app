import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class GridCategoriesPage extends StatefulWidget {
  @override
  _GridCategoriesPageState createState() => _GridCategoriesPageState();
}

class _GridCategoriesPageState extends State<GridCategoriesPage> {
  List segments = [];
  List categories = [];
  List relations = [];
  List titles = [];
  List duas = [];
  Map<String, List<Map<String, dynamic>>> segmentCategories = {};
  Map<int, String> iconMap = {}; // Maps category_id to icon path
  int? _selectedCategoryId; // To keep track of the selected category

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadIcons() async {
    String data = await rootBundle.loadString('assets/json/duaIcons.json');
    final jsonResult = json.decode(data) as Map<String, dynamic>;

    setState(() {
      iconMap = jsonResult.map((key, value) => MapEntry(int.parse(key), value));
    });
  }

  Future<void> loadJsonData() async {
    String data = await rootBundle.loadString('assets/json/dua.json');
    final jsonResult = json.decode(data);

    await loadIcons(); // Load icons after loading the dua data

    setState(() {
      segments = jsonResult['segments'];
      categories = jsonResult['categories'];
      relations = jsonResult['relations'];
      titles = jsonResult['titles'];
      duas = jsonResult['duas'];

      updateSegmentCategories();
    });
  }

  void updateSegmentCategories() {
    segmentCategories.clear();

    for (var relation in relations) {
      final categoryId = relation['category_id'];
      final category =
          categories.firstWhere((c) => c['category_id'] == categoryId);
      final segmentId = relation['segment_id'];
      final segment = segments.firstWhere((s) => s['segment_id'] == segmentId);

      if (!segmentCategories.containsKey(segment['en_segment'])) {
        segmentCategories[segment['en_segment']] = [];
      }

      if (!segmentCategories[segment['en_segment']]!.contains(category)) {
        segmentCategories[segment['en_segment']]!.add(category);
      }
    }

    // Ensure that "Toilet" is always the very last category
    // segmentCategories.forEach((segment, categoryList) {
    //   final toiletCategory = categoryList
    //       .where((category) => category['en_category'] == 'Toilet')
    //       .toList();
    //   categoryList
    //       .removeWhere((category) => category['en_category'] == 'Toilet');
    //   categoryList.addAll(toiletCategory); // Add "Toilet" back at the end
    // });
  }

  @override
  Widget build(BuildContext context) {
    // final filteredTitles = _selectedCategoryId == null
    //     ? []
    //     : relations
    //         .where((relation) => relation['category_id'] == _selectedCategoryId)
    //         .map((relation) => titles.firstWhere(
    //             (title) => title['title_id'] == relation['title_id']))
    //         .toSet() // Convert to Set to remove duplicates
    //         .toList();

    // Print the total count of items to ensure it's correct
    int totalItems =
        segmentCategories.values.fold(0, (sum, item) => sum + item.length);
    // print('Total number of items: $totalItems'); // Debugging statement

    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the number of columns based on screen size
    int crossAxisCount =
        (screenWidth / 180).floor(); // Adjust 180 based on your column size

    // Ensure at least 1 column is visible
    crossAxisCount = crossAxisCount > 0 ? crossAxisCount : 1;

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/icons/dua.png',
              height: 42,
              width: 42,
            ),
            SizedBox(width: 20),
            Text(
              'Dua ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.5,
              ),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                List<Map<String, dynamic>> allCategories =
                    segmentCategories.values.expand((e) => e).toList();
                final category = allCategories[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryId = category['category_id'];
                    });
                    final filteredTitles = _selectedCategoryId == null
                        ? []
                        : relations
                            .where((relation) =>
                                relation['category_id'] == _selectedCategoryId)
                            .map((relation) => titles.firstWhere((title) =>
                                title['title_id'] == relation['title_id']))
                            .toSet() // Convert to Set to remove duplicates
                            .toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DuasListPage(
                          categoryId: category['category_id'] ?? '',
                          categoryName: category['en_category'] ?? '',
                          titles: filteredTitles,
                          duas: duas, // Passing duas data as well
                          relations: relations,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          iconMap[category['category_id']] ?? '',
                          width: 42,
                          height: 42,
                        ),
                        SizedBox(height: 8),
                        Text(
                          category['en_category'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: headingColorFour,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DuasListPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final List titles;
  final List duas;
  final relations;

  const DuasListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.titles,
    required this.duas,
    required this.relations,
  });

  @override
  Widget build(BuildContext context) {
    // print(titles);
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          final title = titles[index];
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                title['ar_title'] ?? '',
                                style: TextStyle(
                                  color: headingColorDark,
                                  fontSize: 24,
                                  fontFamily: arabicHeadingThree,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                title['en_title'] ?? '',
                                style: TextStyle(
                                  color: headingColorDark,
                                  fontSize: 19,
                                  fontFamily: arabicHeadingOne,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_circle_right_outlined,
                      color: commonComponentColor,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DuasDetailPage(
                            categoryId: categoryId,
                            titleId: title['title_id'],
                            titleName: title['en_title'] ?? '',
                            relations: relations,
                            duas: duas,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DuasDetailPage extends StatelessWidget {
  final int categoryId;
  final int titleId;
  final String titleName;
  final List relations;
  final List duas;

  DuasDetailPage({
    required this.categoryId,
    required this.titleId,
    required this.titleName,
    required this.relations,
    required this.duas,
  });

  @override
  Widget build(BuildContext context) {
    final filteredRelations = relations
        .where((relation) =>
            relation['category_id'] == categoryId &&
            relation['title_id'] == titleId)
        .toList();
    final relatedDuas = filteredRelations.map((relation) {
      return duas.firstWhere((dua) => dua['dua_id'] == relation['dua_id']);
    }).toList();

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: Text(
          titleName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView.builder(
          itemCount: relatedDuas.length,
          itemBuilder: (context, index) {
            final dua = relatedDuas[index];
            return Card(
              color: Colors.white,
              child: ExpansionTile(
                title: Text(
                  dua['arabic'],
                  style: TextStyle(
                      fontSize: 32, fontFamily: 'Pdms', color: Colors.black),
                  textAlign: TextAlign.right,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dua['transliteration'] ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          dua['en_translation'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
