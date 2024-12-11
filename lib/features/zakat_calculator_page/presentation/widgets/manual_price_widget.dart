// File name: manual_price_widget.dart

import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/zakat_calculator_page/presentation/widgets/calculator_widget.dart';

class ManualPriceWidget extends StatefulWidget {
  final List<String> zakatTitles;

  const ManualPriceWidget({super.key, required this.zakatTitles});

  @override
  State<ManualPriceWidget> createState() => _ManualPriceWidgetState();
}

class _ManualPriceWidgetState extends State<ManualPriceWidget> {
  List<double> _values = []; // To store user input values
  double _specificNumber = 0.0; // To store specific number entered by user
  double _total = 0.0; // To store total value
  String _resultMessage = ""; // To store result message

  @override
  void initState() {
    super.initState();
    // Initialize _values with 0.0 for each zakat title
    _values = List<double>.filled(widget.zakatTitles.length, 0.0);
  }

  void _calculateZakat() {
    // Calculate total value from user inputs
    _total = _values.fold(0.0, (sum, value) => sum + value);

    // Check against the specific number
    if (_total >= _specificNumber) {
      double zakat = _total * 0.025;
      _resultMessage = '\$${zakat.toStringAsFixed(2)}';
    } else {
      _resultMessage = ' \$0.00';
    }

    // Trigger UI update
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculate your Zakat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: headingColorFour,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'What You Own',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.zakatTitles.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  CalculatorWidget(
                    title: widget.zakatTitles[index],
                    onValueChanged: (value) {
                      // Update the values list when user enters a value
                      _values[index] = value;
                    },
                  ),
                  const SizedBox(height: 8), // Add height space between inputs
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          // Input field for the specific number
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) {
              double? newValue = double.tryParse(text);
              if (newValue != null) {
                _specificNumber = newValue;
              } else {
                _specificNumber = 0.0; // Reset if invalid input
              }
            },
            decoration: const InputDecoration(
              hintText: "Enter the today's Gold value of 87.48 grams",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // main: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Assets:',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        '\$$_total',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Zakat Due:',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          _resultMessage.isEmpty ? '\$0.00' : _resultMessage,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ])
                ],
              ),
              // const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _calculateZakat,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      backgroundColor: formButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Calculate',
                      style: TextStyle(fontSize: 21, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Zakat is obligatory on all Muslims who are in possession of surplus wealth for a full lunar year, exceeding the monetary value of 87.48 grams of gold.',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 64,
          )
        ],
      ),
    );
  }
}
