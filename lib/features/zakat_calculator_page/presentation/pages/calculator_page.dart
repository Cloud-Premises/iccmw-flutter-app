// File name: calculator_page.dart

import 'package:flutter/material.dart';
// import 'package:iccmw/features/zakat_calculator_page/presentation/widgets/live_price_widget.dart';
import 'package:iccmw/features/zakat_calculator_page/presentation/widgets/manual_price_widget.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

final List<String> zakatTitles = [
  'Cash at home and bank accounts',
  'Value of gold you own',
  'Value of silver you own',
  'Value of investments and shares',
  "Money owed to you",
  "Value of 401K & IRA",
  'Value of goods in stock for sale',
  'Other assets',
];

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ManualPriceWidget(
        zakatTitles: zakatTitles, // Pass zakatTitles here
      ),
    );

    // return DefaultTabController(
    //   length: 2, // Number of tabs
    //   child: Column(
    //     children: [
    //       // Tab bar
    //       const TabBar(
    //         tabs: [
    //           Tab(text: 'Manual Gold Price'),
    //           Tab(text: 'Live Gold Price'),
    //         ],
    //       ),
    //       // Tab bar view
    //       Expanded(
    //         child: TabBarView(
    //           children: [
    //             // First tab content
    //             SingleChildScrollView(
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(vertical: 16.0),
    //                 child: ManualPriceWidget(
    //                   zakatTitles: zakatTitles, // Pass zakatTitles here
    //                 ),
    //               ),
    //             ),
    //             // Second tab content
    //             SingleChildScrollView(
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(vertical: 16.0),
    //                 child: LivePriceWidget(
    //                   zakatTitles: zakatTitles, // Pass zakatTitles here
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
