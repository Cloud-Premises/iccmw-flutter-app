// islamic_data_widget.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package

class IslamicDataWidget extends StatefulWidget {
  final DateTime selectedDate;

  const IslamicDataWidget({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  State<IslamicDataWidget> createState() => _IslamicDataWidgetState();
}

class _IslamicDataWidgetState extends State<IslamicDataWidget> {
  String hijriDay = '';
  String hijriMonth = '';
  String hijriYear = '';
  String hijriDesignation = '';
  String todayDate = '';

  @override
  void initState() {
    super.initState();
    fetchIslamicData();
  }

  @override
  void didUpdateWidget(IslamicDataWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      fetchIslamicData();
    }
  }

  Future<void> fetchIslamicData() async {
    final String formattedDate =
        '${widget.selectedDate.day.toString().padLeft(2, '0')}-'
        '${widget.selectedDate.month.toString().padLeft(2, '0')}-'
        '${widget.selectedDate.year.toString()}';

    final url = Uri.parse('http://api.aladhan.com/v1/gToH/$formattedDate');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final hijriData = data['data']['hijri'];

        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            hijriDay = hijriData['day'];
            hijriMonth = hijriData['month']['en'];
            hijriYear = hijriData['year'];
            hijriDesignation = hijriData['designation']['abbreviated'];
            todayDate =
                DateFormat('EEE dd MMMM yyyy').format(widget.selectedDate);
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   '$hijriDay $hijriMonth $hijriYear $hijriDesignation',
        //   style: TextStyle(
        //     fontFamily: 'Poppins',
        //     fontSize: 16,
        //     fontWeight: FontWeight.w600,
        //   ),
        //   softWrap: true,
        //   overflow: TextOverflow.clip,
        //   maxLines: 3,
        // ),
        Text(
          '$hijriDay $hijriMonth $hijriYear $hijriDesignation',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Text(
        //   '$hijriDay $hijriMonth',
        //   style: TextStyle(
        //     fontFamily: 'Poppins',
        //     fontSize: 14,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // Text(
        //   '$hijriYear $hijriDesignation',
        //   style: TextStyle(
        //     fontFamily: 'Poppins',
        //     fontSize: 14,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        Text(
          todayDate,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
