import 'package:flutter/material.dart';
import 'package:iccmw/features/99_names/presentation/widgets/names_widget.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class AllahNamesPage extends StatefulWidget {
  const AllahNamesPage({super.key});

  @override
  State<AllahNamesPage> createState() => _AllahNamesPageState();
}

class _AllahNamesPageState extends State<AllahNamesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        // backgroundColor: const Color.fromRGBO(0, 153, 51, 1),
        backgroundColor: appBarColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/icons/allah.png'),
              width: 32.0,
              height: 32.0,
            ),
            SizedBox(
              width: 4,
            ),
            Text('99 Names of Allah',
                style: TextStyle(
                  color: appBarTextColor,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
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
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          NamesWidget(),
          SizedBox(
            height: 24,
          ),
        ]),
      ),
    );
  }
}
