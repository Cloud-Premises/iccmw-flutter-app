
import 'package:flutter/material.dart';
import 'package:iccmw/components/navigationPages/duaPage/grid_categories_page.dart';

class DuaPage extends StatefulWidget {
  const DuaPage({super.key});

  @override
  State<DuaPage> createState() => _DuaPageState();
}

class _DuaPageState extends State<DuaPage> {
  @override
  Widget build(BuildContext context) {
    return GridCategoriesPage();
    // return TreeView();
  }
}
