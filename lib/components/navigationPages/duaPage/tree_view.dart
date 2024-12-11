import 'package:flutter/material.dart';

class TreeView extends StatefulWidget {
  const TreeView({super.key});

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Tree View'),
      ],
    );
  }
}
