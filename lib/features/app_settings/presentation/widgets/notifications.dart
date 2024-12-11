import 'package:flutter/material.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    bool _isSwitched = true;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Notification',
            style: TextStyle(
              fontSize: 21,
              fontFamily: 'Poppins',
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

          Container(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width:
                    double.infinity, // specify a fixed width for the container
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(242, 198, 167, 0.25),
                  // color: Colors.green[100],
                  color: cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'General Announcement',
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Switch(
                      activeColor: commonComponentColor,
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = !_isSwitched;
                        });
                      },
                    ),
                  ],
                ),
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width:
                    double.infinity, // specify a fixed width for the container
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(242, 198, 167, 0.25),
                  // color: Colors.green[100],
                  color: cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Maktab Program',
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Switch(
                      activeColor: commonComponentColor,
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = !_isSwitched;
                        });
                      },
                    ),
                  ],
                ),
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width:
                    double.infinity, // specify a fixed width for the container
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(242, 198, 167, 0.25),
                  // color: Colors.green[100],
                  color: cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Weekly Yought Sister's Halaka in English",
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Switch(
                      activeColor: commonComponentColor,
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = !_isSwitched;
                        });
                      },
                    ),
                  ],
                ),
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width:
                    double.infinity, // specify a fixed width for the container
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(242, 198, 167, 0.25),
                  // color: Colors.green[100],
                  color: cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Youth Programs',
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Switch(
                      activeColor: commonComponentColor,
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = !_isSwitched;
                        });
                      },
                    ),
                  ],
                ),
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width:
                    double.infinity, // specify a fixed width for the container
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(242, 198, 167, 0.25),
                  // color: Colors.green[100],
                  color: cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Monthy Dars',
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Switch(
                      activeColor: commonComponentColor,
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = !_isSwitched;
                        });
                      },
                    ),
                  ],
                ),
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width:
                    double.infinity, // specify a fixed width for the container
                decoration: BoxDecoration(
                    // color: Color.fromRGBO(242, 198, 167, 0.25),
                    // color: Colors.green[100],
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '* Boardcast Notification will be delivered regardless of the settings above',
                      style: TextStyle(
                        fontSize: 19,
                        fontFamily: 'Poppins',
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '* If you subscribe to New Programs / Events then you will receive Notifications for All New Programs / Events including :-',
                      style: TextStyle(
                        fontSize: 19,
                        fontFamily: 'Poppins',
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      " Women & Youth Programs / Events",
                      style: TextStyle(
                        fontSize: 19,
                        fontFamily: 'Poppins',
                        // fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Container(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Event',
          //         style: TextStyle(
          //           fontSize: 19,
          //           fontFamily: 'Poppins',
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       Switch(
          //         value: _isSwitched,
          //         onChanged: (value) {
          //           setState(() {
          //             _isSwitched = !_isSwitched;
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Services',
          //         style: TextStyle(
          //           fontSize: 19,
          //           fontFamily: 'Poppins',
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       Switch(
          //         value: _isSwitched,
          //         onChanged: (value) {
          //           setState(() {
          //             _isSwitched = !_isSwitched;
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Donation',
          //         style: TextStyle(
          //           fontSize: 19,
          //           fontFamily: 'Poppins',
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       Switch(
          //         value: _isSwitched,
          //         onChanged: (value) {
          //           setState(() {
          //             _isSwitched = !_isSwitched;
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
