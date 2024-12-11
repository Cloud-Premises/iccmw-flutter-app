// File name: calculator_widget.dart

import 'package:flutter/material.dart';

class CalculatorWidget extends StatefulWidget {
  final String title;
  final ValueChanged<double> onValueChanged;

  const CalculatorWidget({
    super.key,
    required this.title,
    required this.onValueChanged,
  });

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  double _value = 0.0; // Initial value

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center, // Aligns items at the top
      children: [
        Flexible(
          // Allows the text to wrap
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 15,
            ),
            maxLines: 1, // Limit the number of lines (optional)
            overflow: TextOverflow.ellipsis, // Specify how to handle overflow
          ),
        ),
        SizedBox(width: 4),
        SizedBox(
          width: 90, // Adjust width as needed
          child: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) {
              // Update _value and notify parent widget
              double? newValue = double.tryParse(text);
              if (newValue != null) {
                _value = newValue;
                widget.onValueChanged(_value); // Notify the parent
              } else {
                _value = 0.0; // Reset if invalid input
                widget.onValueChanged(_value); // Notify the parent
              }
            },
            decoration: InputDecoration(
              hintText: '0.0',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
