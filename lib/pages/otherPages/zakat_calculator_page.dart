import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/zakat_calculator_page/presentation/pages/calculator_page.dart';

class ZakatCalculatorPage extends StatefulWidget {
  const ZakatCalculatorPage({super.key});

  @override
  State<ZakatCalculatorPage> createState() => ZakatCalculatorPageState();
}

class ZakatCalculatorPageState extends State<ZakatCalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: appBarColor,

          title: Row(
            children: [
              const Image(
                image: AssetImage('assets/images/icons/zakatCalculator.png'),
                width: 24.0,
                height: 24.0,
                // color: Colors.white,
              ),
              const SizedBox(width: 8.0),
              Text(
                "Zakat Calculator",
                style: TextStyle(
                  color: appBarTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: appBarIconColor,
            ),
          ),
        ),
        body: CalculatorPage());
  }
}
