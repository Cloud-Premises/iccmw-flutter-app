import 'package:flutter/material.dart';
import 'package:iccmw/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  _navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    await Future.delayed(const Duration(seconds: 3), () {
      if (isFirstLaunch) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const IntroductionScreenPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RootPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app/iccmwLogo.png',
              height: 120,
            ),
            const SizedBox(height: 16),
            Container(
              width: 259,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'ICCMW - Islamic Community',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Center of Mid-Westchester',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
