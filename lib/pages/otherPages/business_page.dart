import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/local_business/presentation/pages/business_categories_page.dart';

class BusinessPage extends StatelessWidget {
  const BusinessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: appBarColor,
        title: const _AppBarTitle(),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: appBarTextColor,
          ),
        ),
      ),
      body: const BusinessCategoriesPage(),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Image(
          image: AssetImage('assets/images/icons/business.png'),
          width: 24.0,
          height: 24.0,
        ),
        const SizedBox(width: 10.0),
        Text(
          "Local Business",
          style: TextStyle(
            color: appBarIconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
