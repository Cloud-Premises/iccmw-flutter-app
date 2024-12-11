// import 'package:flutter/material.dart';

// class CalendarWidget extends StatefulWidget {
//   const CalendarWidget({super.key});

//   @override
//   State<CalendarWidget> createState() => _CalendarWidgetState();
// }

// class _CalendarWidgetState extends State<CalendarWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Image.asset(
//         'assets/images/icons/calendarCheck.png',
//         height: 32,
//         width: 32,
//       ),
//       title: Text(
//         'ICCMW Prayer Calendar',
//         style: TextStyle(
//           fontFamily: 'Poppins',
//           fontSize: 19,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       trailing: IconButton(
//           onPressed: () {},
//           icon: Icon(
//             Icons.arrow_circle_right_outlined,
//             color: Colors.orange,
//             size: 34,
//           )),
//     );
//   }
// }
// calendar_widget.dart

// calendar_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  Future<void> openPDF() async {
    // Get the temporary directory
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/calendar.pdf';

    // Load PDF from assets and save it to the temporary directory
    final pdfData = await rootBundle.load('assets/pdf/calendar.pdf');
    final file = File(filePath);
    await file.writeAsBytes(pdfData.buffer.asUint8List());

    // Open the PDF file with the default PDF viewer on the device
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        'assets/images/icons/calendarCheck.png',
        height: 26,
        width: 26,
      ),
      title: Text(
        'ICCMW Prayer Calendar',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: IconButton(
        onPressed: openPDF,
        icon: Icon(
          Icons.arrow_circle_right_outlined,
          color: Colors.orange,
          size: 26,
        ),
      ),
    );
  }
}
