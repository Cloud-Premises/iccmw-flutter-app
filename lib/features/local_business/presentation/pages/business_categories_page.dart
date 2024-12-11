// // lib/pages/business_categories_page.dart
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:iccmw/features/local_business/data/model/category.dart';
// import 'package:iccmw/features/local_business/data/services/business_service.dart';
// import '../widgets/business_category_card.dart';

// class BusinessCategoriesPage extends StatefulWidget {
//   const BusinessCategoriesPage({Key? key}) : super(key: key);

//   @override
//   State<BusinessCategoriesPage> createState() => _BusinessCategoriesPageState();
// }

// class _BusinessCategoriesPageState extends State<BusinessCategoriesPage> {
//   late Future<List<Category>> futureCategories;
//   final BusinessService businessService = BusinessService();

//   @override
//   void initState() {
//     super.initState();
//     futureCategories = businessService.loadCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Category>>(
//       future: futureCategories,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // While the data is loading, display a shimmer effect
//           return _buildShimmerLoading();
//         } else if (snapshot.hasError) {
//           // If there's an error
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           // If the data is empty
//           return const Center(child: Text('No categories found.'));
//         } else {
//           // When data is loaded
//           final categories = snapshot.data!;
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: categories.map((category) {
//                   return CategorySection(category: category);
//                 }).toList(),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }

//   // Shimmer loading effect
//   Widget _buildShimmerLoading() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: List.generate(5, (index) => _buildShimmerCard()),
//         ),
//       ),
//     );
//   }

//   Widget _buildShimmerCard() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         height: 80,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//     );
//   }
// }

// class CategorySection extends StatefulWidget {
//   final Category category;

//   const CategorySection({Key? key, required this.category}) : super(key: key);

//   @override
//   _CategorySectionState createState() => _CategorySectionState();
// }

// class _CategorySectionState extends State<CategorySection> {
//   bool isExpanded = false;

//   void toggleExpansion() {
//     setState(() {
//       isExpanded = !isExpanded;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Tappable header row
//         TappableCategoryHeader(
//           category: widget.category,
//           isExpanded: isExpanded,
//           onTap: toggleExpansion,
//         ),
//         const SizedBox(height: 10),
//         // Subcategories List
//         if (isExpanded)
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: widget.category.subcategories.length,
//             itemBuilder: (context, index) {
//               final subcategory = widget.category.subcategories[index];
//               return BusinessCategoryCard(subcategory: subcategory);
//             },
//           ),
//         if (isExpanded) const SizedBox(height: 20),
//       ],
//     );
//   }
// }

// class TappableCategoryHeader extends StatelessWidget {
//   final Category category;
//   final bool isExpanded;
//   final VoidCallback onTap;

//   const TappableCategoryHeader({
//     Key? key,
//     required this.category,
//     required this.isExpanded,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: ListTile(
//           leading: Image.asset(
//             category.icon,
//             width: 40,
//             height: 40,
//             fit: BoxFit.contain,
//             errorBuilder: (context, error, stackTrace) {
//               return const Icon(Icons.broken_image, size: 40);
//             },
//           ),
//           title: Text(
//             category.name,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           trailing: Icon(
//             isExpanded
//                 ? Icons.arrow_circle_up_rounded
//                 : Icons.arrow_circle_down_rounded,
//             color: Colors.green,
//             size: 32,
//           ),
//         ),
//       ),
//     );
//   }
// }
// lib/pages/business_categories_page.dart
import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iccmw/features/local_business/data/model/category.dart';
import 'package:iccmw/features/local_business/data/services/business_service.dart';
import '../widgets/business_category_card.dart';

class BusinessCategoriesPage extends StatefulWidget {
  const BusinessCategoriesPage({Key? key}) : super(key: key);

  @override
  State<BusinessCategoriesPage> createState() => _BusinessCategoriesPageState();
}

class _BusinessCategoriesPageState extends State<BusinessCategoriesPage> {
  late Future<List<Category>> futureCategories;
  final BusinessService businessService = BusinessService();

  @override
  void initState() {
    super.initState();
    futureCategories = businessService.loadCategories();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureCategories = businessService.loadCategories(); // Fetch new data
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the data is loading, display a shimmer effect
          return _buildShimmerLoading();
        } else if (snapshot.hasError) {
          // If there's an error
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // If the data is empty
          return const Center(child: Text('No categories found.'));
        } else {
          // When data is loaded
          final categories = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categories.map((category) {
                    return CategorySection(category: category);
                  }).toList(),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // Shimmer loading effect
  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(5, (index) => _buildShimmerCard()),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class CategorySection extends StatefulWidget {
  final Category category;

  const CategorySection({Key? key, required this.category}) : super(key: key);

  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  bool isExpanded = false;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tappable header row
        TappableCategoryHeader(
          category: widget.category,
          isExpanded: isExpanded,
          onTap: toggleExpansion,
        ),
        const SizedBox(height: 10),
        // Subcategories List
        if (isExpanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.category.subcategories.length,
            itemBuilder: (context, index) {
              final subcategory = widget.category.subcategories[index];
              return BusinessCategoryCard(subcategory: subcategory);
            },
          ),
        if (isExpanded) const SizedBox(height: 20),
      ],
    );
  }
}

class TappableCategoryHeader extends StatelessWidget {
  final Category category;
  final bool isExpanded;
  final VoidCallback onTap;

  const TappableCategoryHeader({
    Key? key,
    required this.category,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.asset(
          category.icon,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 40);
          },
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          isExpanded
              ? Icons.arrow_circle_up_rounded
              : Icons.arrow_circle_down_rounded,
          // color: Colors.green,
          color: commonComponentColor,
          size: 32,
        ),
        onTap: onTap, // Use ListTile's onTap to toggle expansion
      ),
    );
  }
}
