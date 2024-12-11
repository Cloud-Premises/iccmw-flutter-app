import 'package:flutter/material.dart';
import 'package:iccmw/features/hadith/presentation/widgets/hadith_card.dart';

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: const Color.fromRGBO(0, 153, 51, 1),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Image(
              image: AssetImage('assets/images/icons/books.png'),
              width: 32.0,
              height: 32.0,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Hadiths',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HadithCard(),
            ],
          ),
        ),
      ),
    );
  }
}
