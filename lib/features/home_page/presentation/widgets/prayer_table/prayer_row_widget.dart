// import 'package:flutter/material.dart';

// class PrayerRowWidget extends StatefulWidget {
//   final String prayerName;
//   final String prayerStartTime;
//   const PrayerRowWidget(
//       {super.key, required this.prayerName, required this.prayerStartTime});

//   @override
//   State<PrayerRowWidget> createState() => _PrayerRowWidgetState();
// }

// class _PrayerRowWidgetState extends State<PrayerRowWidget> {
//   bool prayerNotification = true;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(

//       leading: Icon(Icons.sunny),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             widget.prayerName,
//             style: TextStyle(
//               fontFamily: 'Intern',
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             widget.prayerTime,
//             style: TextStyle(
//               fontFamily: 'Intern',
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//       trailing: prayerNotification
//           ? IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.notifications_active,
//                 color: Colors.orange,
//               ))
//           : IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.notifications_off_rounded,
//                 color: Colors.orange,
//               )),
//     );
//   }
// }
import 'package:flutter/material.dart';

class PrayerRowWidget extends StatefulWidget {
  final String prayerName;
  final String prayerStartTime;
  final String prayerEndTime;
  // final bool prayerNotification;
  final bool isPrayer;
  // final bool isActive;

  const PrayerRowWidget({
    super.key,
    required this.prayerName,
    required this.prayerStartTime,
    required this.prayerEndTime,
    // required this.prayerNotification,
    required this.isPrayer,
    // required this.isActive,
  });

  @override
  State<PrayerRowWidget> createState() => _PrayerRowWidgetState();
}

class _PrayerRowWidgetState extends State<PrayerRowWidget> {
  bool prayerNotification = true;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> _prayerImages = {
      "Fajr": "assets/images/prayer/fajr.png",
      "Shuruq": "assets/images/prayer/shuruq.png",
      "Dhuhr": "assets/images/prayer/dhuhr.png",
      "Asr": "assets/images/prayer/asr.png",
      "Maghrib": "assets/images/prayer/maghrib.png",
      "Isha": "assets/images/prayer/isha.png",
      "prayer": "assets/images/prayer/isha.png"
    };

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            // margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            color: widget.isPrayer
                ? Color.fromRGBO(46, 40, 44, 1)
                : Colors.transparent,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 105,
                      child: Row(
                        children: [
                          Image.asset(
                            _prayerImages[widget.prayerName] ?? '',
                            height: 27,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.prayerName,
                            style: TextStyle(
                              fontFamily: 'Intern',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.isPrayer
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.prayerStartTime.startsWith('0')
                                ? widget.prayerStartTime.substring(1)
                                : widget.prayerStartTime,
                            style: TextStyle(
                              fontFamily: 'Intern',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  widget.isPrayer ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            widget.prayerEndTime.startsWith('0')
                                ? widget.prayerEndTime.substring(1)
                                : widget.prayerEndTime == ''
                                    ? '             '
                                    : widget.prayerEndTime,
                            style: TextStyle(
                              fontFamily: 'Intern',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  widget.isPrayer ? Colors.white : Colors.black,
                            ),
                          ),
                          // prayerNotification
                          //     ? IconButton(
                          //         onPressed: () {
                          //           setState(() {
                          //             if (prayerNotification) {
                          //               prayerNotification = false;
                          //             } else {
                          //               prayerNotification = true;
                          //             }
                          //           });
                          //         },
                          //         icon: Icon(
                          //           Icons.notifications_active,
                          //           color: Colors.orange,
                          //         ))
                          //     : IconButton(
                          //         onPressed: () {
                          //           setState(() {
                          //             if (prayerNotification) {
                          //               prayerNotification = false;
                          //             } else {
                          //               prayerNotification = true;
                          //             }
                          //           });
                          //         },
                          //         icon: Icon(
                          //           Icons.notifications_off_rounded,
                          //           color: Colors.orange,
                          //         )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // widget.isPrayer
        //     ? Container()
        //     :

        widget.prayerName == 'Isha'
            ? Container()
            : Divider(
                height: 1,
                thickness: 1,
                color: const Color.fromRGBO(255, 152, 0, 0.7),
              )
      ],
    );
  }
}
