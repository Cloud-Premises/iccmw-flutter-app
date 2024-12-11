import 'package:flutter/material.dart';
import 'package:iccmw/features/app_settings/presentation/providers/prayer_notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationIconWidget extends StatefulWidget {
  final String prayerName;
  final bool currentPrayer;

  const NotificationIconWidget(
      {super.key, required this.prayerName, required this.currentPrayer});

  @override
  State<NotificationIconWidget> createState() => _NotificationIconWidgetState();
}

class _NotificationIconWidgetState extends State<NotificationIconWidget> {
  @override

  // Widget _buildNotificationIcon(
  // BuildContext context, String prayerName, bool currentPrayer)

  Widget build(BuildContext context) {
    return Consumer<PrayerNotificationProvider>(
      builder: (context, provider, child) {
        bool providerPrayer;

        // Retrieve the current prayer notification status using the provider's getters
        switch (widget.prayerName) {
          case 'Fajr':
            providerPrayer = provider.fajrStart;
            break;
          case 'Dhuhr':
            providerPrayer = provider.dhuhrStart;
            break;
          case 'Asr':
            providerPrayer = provider.asrStart;
            break;
          case 'Maghrib':
            providerPrayer = provider.maghribStart;
            break;
          case 'Isha':
            providerPrayer = provider.ishaStart;
            break;
          default:
            providerPrayer = false; // Default case
        }

        return IconButton(
          icon: Icon(
            providerPrayer
                ? Icons.notifications_active
                : Icons.notifications_off,
            color: widget.currentPrayer ? Colors.white : Colors.grey[400],
            // color: widget.currentPrayer ? Colors.white : Colors.white,
          ),
          onPressed: () {
            // Update the prayer notification status based on prayerName
            switch (widget.prayerName) {
              case 'Fajr':
                provider.toggleFajrStart(!providerPrayer);
                break;
              case 'Dhuhr':
                provider.toggleDhuhrStart(!providerPrayer);
                break;
              case 'Asr':
                provider.toggleAsrStart(!providerPrayer);
                break;
              case 'Maghrib':
                provider.toggleMaghribStart(!providerPrayer);
                break;
              case 'Isha':
                provider.toggleIshaStart(!providerPrayer);
                break;
            }
          },
        );
      },
    );
  }
}
