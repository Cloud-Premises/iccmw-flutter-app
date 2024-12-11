import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:provider/provider.dart';
import 'package:iccmw/features/app_settings/presentation/providers/prayer_notification_provider.dart';

class PrayerNotification extends StatelessWidget {
  const PrayerNotification({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayerNotificationProvider(),
      child: Consumer<PrayerNotificationProvider>(
        builder: (context, provider, _) {
          bool _isSwitched = true;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Prayer Notification',
                  style: TextStyle(
                    fontSize: 19,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: headingColorLight,
                  ),
                ),
                Divider(
                  height: 2,
                  color: dividerColor,
                ),
                SizedBox(
                  height: 12,
                ),
                // const Divider(height: 2, color: dividerColor),
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Row(
                //       children: [
                //         SizedBox(width: 150),
                //       ],
                //     ),
                //     Row(
                //       children: [
                //         Text(
                //           'Adhaan',
                //           style: TextStyle(fontSize: 19),
                //         ),
                //         SizedBox(width: 50),
                //         Text(
                //           'Iqamah',
                //           style: TextStyle(fontSize: 19),
                //         ),
                //       ],
                //     )
                //   ],
                // ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: double
                        .infinity, // specify a fixed width for the container
                    decoration: BoxDecoration(
                      // color: Color.fromRGBO(242, 198, 167, 0.25),
                      // color: Colors.green[100],
                      color: cardColor,
                    ),
                    child: Column(
                      children: [
                        // Group switches for all prayers
                        _buildGroup(
                          '',
                          provider.allPrayersStart,
                          provider.allPrayersEnd,
                          provider.toggleAllPrayersStart,
                          provider.toggleAllPrayersEnd,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: dividerColor,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // Individual prayer switches
                        _buildSwitchRow(
                          'Fajr',
                          provider.fajrStart,
                          provider.fajrEnd,
                          provider.toggleFajrStart,
                          provider.toggleFajrEnd,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: dividerColor,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _buildSwitchRow(
                          'Dhuhr',
                          provider.dhuhrStart,
                          provider.dhuhrEnd,
                          provider.toggleDhuhrStart,
                          provider.toggleDhuhrEnd,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: dividerColor,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _buildSwitchRow(
                          'Asr',
                          provider.asrStart,
                          provider.asrEnd,
                          provider.toggleAsrStart,
                          provider.toggleAsrEnd,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: dividerColor,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _buildSwitchRow(
                          'Maghrib',
                          provider.maghribStart,
                          provider.maghribEnd,
                          provider.toggleMaghribStart,
                          provider.toggleMaghribEnd,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: dividerColor,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _buildSwitchRow(
                          'Isha',
                          provider.ishaStart,
                          provider.ishaEnd,
                          provider.toggleIshaStart,
                          provider.toggleIshaEnd,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: double
                          .infinity, // specify a fixed width for the container
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(242, 198, 167, 0.25),
                        // color: Colors.green[100],
                        color: cardColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jummah Prayer',
                            style: TextStyle(
                              fontSize: 19,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: _isSwitched,
                            activeColor: commonComponentColor,
                            onChanged: (
                              value,
                            ) {
                              _isSwitched = !_isSwitched;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to build each row with a start and end switch for a specific prayer
  Widget _buildSwitchRow(
    String prayer,
    bool startValue,
    bool endValue,
    Function(bool) onStartChanged,
    Function(bool) onEndChanged,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // const Divider(height: 2, color: dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  prayer != ''
                      ? Image.asset(
                          'assets/images/prayer/${prayer.toLowerCase()}.png',
                          width: 40,
                          height: 40)
                      : const SizedBox(width: 10),
                  const SizedBox(width: 20),
                  Text(
                    prayer,
                    style: const TextStyle(
                      fontSize: 19,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Switch(
                    activeColor: commonComponentColor,
                    value: startValue,
                    onChanged: onStartChanged,
                  ),
                  const SizedBox(width: 20),
                  Switch(
                    activeColor: commonComponentColor,
                    value: endValue,
                    onChanged: onEndChanged,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroup(
    String prayer,
    bool startValue,
    bool endValue,
    Function(bool) onStartChanged,
    Function(bool) onEndChanged,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // const Divider(height: 2, color: dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  prayer != ''
                      ? Image.asset(
                          'assets/images/prayer/${prayer.toLowerCase()}.png',
                          width: 40,
                          height: 40)
                      : const SizedBox(width: 10),
                  const SizedBox(width: 20),
                  Text(
                    prayer,
                    style: const TextStyle(
                      fontSize: 19,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'BEGINS',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        activeColor: commonComponentColor,
                        value: startValue,
                        onChanged: onStartChanged,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'JAMAT',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        activeColor: commonComponentColor,
                        value: endValue,
                        onChanged: onEndChanged,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build a row with a group switch
}
