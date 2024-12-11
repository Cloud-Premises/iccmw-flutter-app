import 'package:flutter/material.dart';

class NewHomeWidget extends StatefulWidget {
  const NewHomeWidget({super.key});

  @override
  State<NewHomeWidget> createState() => _NewHomeWidgetState();
}

class _NewHomeWidgetState extends State<NewHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Container(
            width: 100,
            height: 100,
            child: Column(
              children: [
                Text('Hello'),
              ],
            ),
          )
        ])
      ],
    );
  }
}
