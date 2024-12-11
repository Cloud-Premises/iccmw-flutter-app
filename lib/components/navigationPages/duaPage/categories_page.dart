import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
    segmentCategories.forEach((segment, categoryList) {
      final toiletCategory = categoryList
          .where((category) => category['en_category'] == 'Toilet')
          .toList();
      categoryList
          .removeWhere((category) => category['en_category'] == 'Toilet');
      categoryList.addAll(toiletCategory); // Add "Toilet" back at the end
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTitles = _selectedCategoryId == null
        ? []
        : relations
            .where((relation) => relation['category_id'] == _selectedCategoryId)
            .map((relation) => titles.firstWhere(
                (title) => title['title_id'] == relation['title_id']))
            .toSet() // Convert to Set to remove duplicates
            .toList();

    return Scaffold(
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
      body: ListView(
        children: segmentCategories.entries.map((entry) {
          final categoriesInSegment = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...categoriesInSegment.map((category) {
                final isSelected =
                    _selectedCategoryId == category['category_id'];
                final iconPath = iconMap[category['category_id']] ?? '';

                return Column(
                  children: [
                    ListTile(
                      trailing: Icon(
                        isSelected
                            ? Icons.arrow_circle_up_rounded
                            : Icons.arrow_circle_down_rounded,
                        size: 32.0,
                        // color: Colors.green,
                        color: commonComponentColor,
                      ),
                      title: Row(
                        children: [
                          // Display category icons
                          Image.asset(
                            iconPath,
                            width: 42,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Text(
                              category['en_category'],
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedCategoryId = null; // Deselect category
                          } else {
                            _selectedCategoryId = category['category_id'];
                          }
                        });
                      },
                    ),
                    if (isSelected)
                      Column(
                        children: filteredTitles.map((title) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 18),
                            decoration: BoxDecoration(
                              // color: Colors.green,
                              color: commonComponentColor,
                              borderRadius: BorderRadius.circular(
                                  12), // Set the radius value
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  SizedBox(width: 40),
                                  Expanded(
                                    child: Text(
                                      title['en_title'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DuasPage(
                                      categoryId: category['category_id'],
                                      titleId: title['title_id'],
                                      titleName: title['en_title'],
                                      relations: relations,
                                      duas: duas,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                );
              }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class DuasPage extends StatelessWidget {
  final int categoryId;
  final int titleId;
  final String titleName;
  final List relations;
  final List duas;

  DuasPage({
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
      appBar: AppBar(
        title: Text(
          titleName,
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Theme.of(context).colorScheme.primary,
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
            return Column(
              children: [
                // ListTile(
                //   title: Column(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       Text(
                //         dua['arabic'],
                //         style: TextStyle(
                //           fontSize: 32,
                //           fontFamily: 'Pdms',
                //           color: Colors.black,
                //         ),
                //         textAlign: TextAlign.right,
                //       ),
                //     ],
                //   ),
                //   subtitle: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SizedBox(height: 8),
                //       Text(dua['en_translation'],
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.black,
                //           )),
                //       SizedBox(height: 8),
                //       Text(dua['transliteration'],
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 14,
                //             fontStyle: FontStyle.italic,
                //           )),
                //     ],
                //   ),
                // ),
                // Divider(
                //   color: dividerColor,
                //   thickness: 1,
                // ),
                Card(
                  color: Colors.white,
                  // color: Colors.green[400],
                  // color: Theme.of(context).colorScheme.inversePrimary,
                  child: ExpansionTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          dua['arabic'],
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Pdms',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Translation",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.start,
                      ),
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
                    // subtitle: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     SizedBox(height: 8),
                    //     Text(dua['en_translation'],
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           color: Colors.black,
                    //         )),
                    //     SizedBox(height: 8),
                    //     Text(dua['transliteration'],
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 14,
                    //           fontStyle: FontStyle.italic,
                    //         )),
                    //   ],
                    // ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
