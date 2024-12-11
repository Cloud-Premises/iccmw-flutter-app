import 'package:flutter/material.dart';
import 'package:iccmw/main.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionScreenPage extends StatelessWidget {
  const IntroductionScreenPage({super.key});

  Future<void> _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RootPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to ICCMW",
          body: "Islamic Community Center of Mid-Westchester",
          image: Image.asset("assets/images/app/iccmwLogo.png", height: 120.0),
          decoration: const PageDecoration(
            titlePadding:
                EdgeInsets.only(top: 0.0), // Adjust spacing above the title
            // contentMargin: EdgeInsets.symmetric(
            // horizontal: 21.0, vertical: 21.0), // Adjust spacing around body
            imagePadding:
                EdgeInsets.only(bottom: 0), // Adjust spacing below image
          ),
        ),
        PageViewModel(
          title: "Stay Connected & Get ICCMW Notifications",
          body: "Join ICCMW events, activities, community program, and more.",
          image: Image.asset(
              "assets/images/introduction_screen/notification.png",
              height: 175.0),
          decoration: const PageDecoration(
            titlePadding:
                EdgeInsets.only(top: 0.0), // Adjust spacing above the title
            // contentMargin: EdgeInsets.symmetric(
            // horizontal: 21.0, vertical: 21.0), // Adjust spacing around body
            imagePadding:
                EdgeInsets.only(bottom: 0), // Adjust spacing below image
          ),
        ),
        PageViewModel(
          title: "Grow with Us",
          body: "Learn, engage, and grow with our community.",
          image: Image.asset("assets/images/introduction_screen/grow.png",
              height: 210.0),
          decoration: const PageDecoration(
            titlePadding:
                EdgeInsets.only(top: 0.0), // Adjust spacing above the title
            imagePadding:
                EdgeInsets.only(bottom: 0), // Adjust spacing below image
          ),
        ),
        PageViewModel(
          title: "ICCMW App",
          body:
              "ICCMW Prayer Time, ICCMW Events, Community Services, Islamic Calendar, Qur'an, Dua, Zakat Calculator, 99 Names of Allah, Tasbeeh, Qibla direction and more.",
          image: Image.asset("assets/images/introduction_screen/grow.png",
              height: 210.0),
          decoration: const PageDecoration(
            titlePadding:
                EdgeInsets.only(top: 0.0), // Adjust spacing above the title
            imagePadding:
                EdgeInsets.only(bottom: 0), // Adjust spacing below image
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
