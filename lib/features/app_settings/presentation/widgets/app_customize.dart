import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iccmw/features/app_settings/presentation/providers/card_style_provider.dart';

class AppCustomize extends StatefulWidget {
  const AppCustomize({super.key});

  @override
  State<AppCustomize> createState() => _AppCustomizeState();
}

class _AppCustomizeState extends State<AppCustomize> {
  @override
  Widget build(BuildContext context) {
    final cardStyleProvider = Provider.of<CardStyleProvider>(context);
    bool isSwitched = cardStyleProvider.cardStyling;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customize My App',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Divider(height: 2, color: Colors.black26),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Change announcement to high priority',
                style: TextStyle(fontSize: 16),
              ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  cardStyleProvider.toggleCardStyle(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
