// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:device_preview/device_preview.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';
import 'package:iccmw/features/99_names/presentation/pages/allah_names_page.dart';
import 'package:iccmw/features/app_settings/presentation/providers/card_style_provider.dart';
import 'package:iccmw/features/app_settings/presentation/providers/prayer_card_visibility_provider.dart';
import 'package:iccmw/features/app_settings/presentation/providers/prayer_notification_provider.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:iccmw/features/home_page/presentation/widgets/allah_names/audio_player_service.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/general_setting_provider.dart';
import 'package:iccmw/features/quran_app/presentation/providers/settings/settings_providers.dart';
import 'package:iccmw/features/quran_app_verse/business/usecase/get_verses.dart';
import 'package:iccmw/features/quran_app_verse/business/usecase/get_verses_translation.dart';
import 'package:iccmw/features/quran_app_verse/business/usecase/get_verses_translitration.dart';
import 'package:iccmw/features/quran_app_verse/data/datasource/verse_datasource.dart';
import 'package:iccmw/features/quran_app_verse/data/datasource/verse_datasource_translation.dart';
import 'package:iccmw/features/quran_app_verse/data/datasource/verse_datasource_translitration.dart';
import 'package:iccmw/features/quran_app_verse/data/repository/verse_repository.dart';
import 'package:iccmw/features/quran_app_verse/data/repository/verse_repository_translation.dart';
import 'package:iccmw/features/quran_app_verse/data/repository/verse_repository_translitration.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/juz_verse_provider.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/juz_verse_provider_translation.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/juz_verse_provider_translitration.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/verse_provider.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/verse_provider_translation.dart';
import 'package:iccmw/features/quran_app_verse/presentation/providers/verse_provider_translitration.dart';
import 'package:iccmw/features/quran_reciter/business/usecases/get_reciter_usecase.dart';
import 'package:iccmw/features/quran_reciter/data/datasource/reciter_datasource.dart';
import 'package:iccmw/features/quran_reciter/data/repository/reciter_repository.dart';
import 'package:iccmw/features/quran_reciter/presentation/providers/reciters_provider.dart';
import 'package:iccmw/features/tasbeeh/presentation/pages/tasbeeh_page.dart';
import 'package:iccmw/features/tasbeeh/presentation/providers/select_image_provider.dart';
import 'package:iccmw/pages/donate_page.dart';
import 'package:iccmw/pages/otherPages/business_page.dart';
import 'package:iccmw/pages/otherPages/josbposting_page.dart';
import 'package:iccmw/pages/otherPages/notification_page.dart';
import 'package:iccmw/pages/otherPages/qibla_page.dart';
import 'package:iccmw/pages/otherPages/social_media_page.dart';
import 'package:iccmw/pages/otherPages/sports_activities_page.dart';
import 'package:iccmw/pages/otherPages/zakat_calculator_page.dart';
import 'package:iccmw/pages/quran_page.dart';
import 'package:iccmw/pages/setting_page.dart';
import 'package:flutter/material.dart';
// import 'package:iccmw/utils/notification/notification_controller.dart';

import 'package:provider/provider.dart';

// Bottom Menu Page
import 'package:iccmw/pages/home_page.dart';
import 'package:iccmw/pages/dua_page.dart';
// import 'package:iccmw/pages/quran_page.dart';
// import 'package:iccmw/pages/donate_page.dart';
// Login Page
// import './pages/login/login_page.dart';
// Drawer Pages
import 'package:iccmw/pages/otherPages/aboutus_page.dart';
// import 'package:iccmw/pages/otherPages/annoucements_page.dart';
import 'package:iccmw/pages/otherPages/contactus_page.dart';
import 'package:iccmw/pages/otherPages/events_page.dart';
// import 'package:iccmw/pages/otherPages/qibla_page.dart';
import 'package:iccmw/pages/otherPages/services_page.dart';

// Splash Screen
import 'package:iccmw/pages/loadingPage/splash.dart';
import 'package:url_launcher/url_launcher.dart';

// shared Preferences
// import 'package:shared_preferences/shared_preferences.dart';

// theme provider
// import "package:iccmw/features/app_settings/presentation/providers/theme_provider.dart"
//     as theme_provider;

final AudioPlayer player =
    AudioPlayer(); // Create a global instance of AudioPlayer
const platform = MethodChannel('com.example.hardware_buttons');

void main() async {
  // await NotificationService.initializeNotification();
  WidgetsFlutterBinding.ensureInitialized();
  await AudioPlayerService().init();
  await AwesomeNotifications().initialize(
    // null,

    // 'resource://drawable/notification_icon_status_bar',
    "resource://drawable/notification_icon_drawer",
    // "resource://raw/azan",
    [
      NotificationChannel(
        channelGroupKey: "iccmw_channel_group",
        channelKey: "iccmw_channel",
        channelName: "ICCMW Notification",
        channelDescription: "ICCMW Notification Channel",
        // icon: 'assets/',
        importance: NotificationImportance.High,
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: 'iccmw_channel_azan',
        channelGroupKey: "iccmw_channel_azan_group",
        channelName: 'Prayer Notifications',
        channelDescription: 'Prayer time notifications',
        importance: NotificationImportance.High,
        defaultPrivacy: NotificationPrivacy.Public,
        enableVibration: true,
        playSound: false,
        locked: true,
      ),
      NotificationChannel(
        channelKey: 'iccmw_channel_fajrazan',
        channelGroupKey: "iccmw_channel_fajrazan_group",
        channelName: 'Fajr Prayer Notifications',
        channelDescription: 'Fajr prayer notifications',
        importance: NotificationImportance.High,
        defaultPrivacy: NotificationPrivacy.Public,
        enableVibration: true,
        playSound: false,
        locked: true,
      ),
      // NotificationChannel(
      //   channelGroupKey: "iccmw_channel_fajrazan_group",
      //   channelKey: "iccmw_channel_fajrazan",
      //   channelName: "ICCMW Notification Fajr Azan",
      //   channelDescription: "ICCMW Notification Channel",
      //   // icon: 'assets/',
      //   playSound: true,
      //   enableVibration: true,
      //   importance: NotificationImportance.High,
      // ),
      // NotificationChannel(
      //   channelGroupKey: "iccmw_channel_azan_group",
      //   channelKey: "iccmw_channel_azan",
      //   channelName: "ICCMW Notification Azan",
      //   channelDescription: "ICCMW Notification Channel",
      //   // icon: 'assets/',
      //   playSound: true,
      //   enableVibration: true,
      //   importance: NotificationImportance.High,
      // ),
      NotificationChannel(
        channelGroupKey: "iccmw_channel_group_two",
        channelKey: "iccmw_channel_two",
        channelName: "ICCMW Notification Two",
        channelDescription: "ICCMW Notification Channel Two",
        // icon: 'assets/',
        importance: NotificationImportance.High,
        enableVibration: false,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "iccmw_channel_group",
        channelGroupName: "ICCMW Notification Group",
      ),
      NotificationChannelGroup(
        channelGroupKey: "iccmw_channel_fajrazan_group",
        channelGroupName: "ICCMW Notification Group Azan",
      ),
      NotificationChannelGroup(
        channelGroupKey: "iccmw_channel_azan_group",
        channelGroupName: "ICCMW Notification Group Azan",
      ),
      NotificationChannelGroup(
        channelGroupKey: "iccmw_channel_group_two",
        channelGroupName: "ICCMW Notification Group Two",
      ),
    ],
  );

// Set up action handler
  await AwesomeNotifications().setListeners(
    onNotificationDisplayedMethod: (notification) async {
      // FajrAzan
      if (notification.channelKey == 'iccmw_channel_fajrazan') {
        await playFajrAzanAudio();
      }
      // Azan
      if (notification.channelKey == 'iccmw_channel_azan') {
        await playAzanAudio();
      }
    },
    onActionReceivedMethod: (notification) async {
      // FajrAzan
      if (notification.channelKey == 'iccmw_channel_fajrazan') {
        await stopFajrAzanAudio();
      }
      // Azan
      if (notification.channelKey == 'iccmw_channel_azan') {
        await stopAzanAudio();
      }
    },
  );

  // await AwesomeNotifications().setListeners(
  //   onActionReceivedMethod: onActionReceivedMethod,
  //   onNotificationCreatedMethod: onNotificationCreatedMethod,
  //   onNotificationDisplayedMethod: onNotificationDisplayedMethod,
  //   onDismissActionReceivedMethod: onDismissActionReceivedMethod,
  // );

  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const MyApp());
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     tools: const [
  //       ...DevicePreview.defaultTools,
  //       // CustomPlugin(),
  //     ],
  //     builder: (context) => const MyApp(),
  //   ),
  // );
}

// Future<void> playAzanAudio() async {
//   final player = AudioPlayer();
//   await player.play(AssetSource('audio/azan.mp3')); // Path to the audio file
// }
// Function to play Azan audio
Future<void> playAzanAudio() async {
  if (player.state == PlayerState.playing) {
    await player.stop(); // Stop any currently playing audio
  }
  await player.play(AssetSource('audio/azan.mp3')); // Start Azan audio
}

// Function to stop Azan audio
Future<void> stopAzanAudio() async {
  await player.stop(); // Stop the audio playback
}

Future<void> playFajrAzanAudio() async {
  if (player.state == PlayerState.playing) {
    await player.stop(); // Stop any currently playing audio
  }
  await player.play(AssetSource('audio/fajrAzan.mp3')); // Start Fajr Azan audio
}

// Function to stop Azan audio
Future<void> stopFajrAzanAudio() async {
  await player.stop(); // Stop the audio playback
}

void listenToButtonPresses() {
  platform.setMethodCallHandler((call) async {
    if (call.method == 'stopAudio') {
      stopFajrAzanAudio();
      stopAzanAudio();
    }
  });
}
// Function to play Azan audio

// void main() {
//   runApp(
//     DevicePreview(
//       enabled: true,
//       tools: const [
//         ...DevicePreview.defaultTools,
//         // CustomPlugin(),
//       ],
//       builder: (context) => const MyApp(),
//     ),
//   );
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  // static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  // Color appTheme = Colors.orange;

  @override
  void initState() {
    // AwesomeNotifications().setListeners(
    //   onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    //   onNotificationCreatedMethod:
    //       NotificationController.onNotificationCreatedMethod,
    //   onDismissActionReceivedMethod:
    //       NotificationController.onDismissActionReceivedMethod,
    //   onNotificationDisplayedMethod:
    //       NotificationController.onNotificationDisplayedMethod,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle unselectedLabelStyle = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );

    const TextStyle selectedLabelStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CardStyleProvider()),
        ChangeNotifierProvider(create: (_) => PrayerCardVisibilityProvider()),
        ChangeNotifierProvider(create: (_) => PrayerNotificationProvider()),
        ChangeNotifierProvider(create: (_) => GeneralSettingProvider()),
        ChangeNotifierProvider(create: (_) => SelectedImageProvider()),

        // Quran Application
        ChangeNotifierProvider(create: (_) => QuranSettingsProviders()),

        // // Verse
        // ChangeNotifierProvider<VerseProvider>(
        //   create: (_) => VerseProvider(
        //     GetVerses(
        //       VerseRepository(
        //         VerseDataSource(settings: QuranSettingsProviders()),
        //       ),
        //     ),
        //   ),
        // ),
        // Verse providers
        ChangeNotifierProvider<VerseProvider>(
          create: (context) => VerseProvider(
            GetVerses(
              VerseRepository(
                // Using Consumer to dynamically get the updated QuranSettingsProviders instance
                VerseDataSource(
                    settings: context.read<QuranSettingsProviders>()),
              ),
            ),
          ),
        ),

        // Verse Translation+
        ChangeNotifierProvider<VerseProviderTranslation>(
          create: (context) => VerseProviderTranslation(
            GetVersesTranslation(
              VerseRepositoryTranslation(
                VerseDatasourceTranslation(
                    settings: context.read<QuranSettingsProviders>()),
              ),
            ),
          ),
        ),

        // Verse Translitration
        ChangeNotifierProvider<VerseProviderTranslitration>(
          create: (_) => VerseProviderTranslitration(
            GetVersesTranslitration(
              VerseRepositoryTranslitration(
                VerseDatasourceTranslitration(),
              ),
            ),
          ),
        ),

        // Verse
        ChangeNotifierProvider<JuzVerseProvider>(
          create: (context) => JuzVerseProvider(
            GetVerses(
              VerseRepository(
                VerseDataSource(
                    settings: context.read<QuranSettingsProviders>()),
              ),
            ),
          ),
        ),

        ChangeNotifierProvider<JuzVerseProviderTranslation>(
          create: (context) => JuzVerseProviderTranslation(
            GetVersesTranslation(
              VerseRepositoryTranslation(
                VerseDatasourceTranslation(
                    settings: context.read<QuranSettingsProviders>()),
              ),
            ),
          ),
        ),

        ChangeNotifierProvider<JuzVerseProviderTranslitration>(
          create: (_) => JuzVerseProviderTranslitration(
            GetVersesTranslitration(
              VerseRepositoryTranslitration(
                VerseDatasourceTranslitration(),
              ),
            ),
          ),
        ),
        // DataSource Provider
        Provider<ReciterDataSource>(
          create: (_) =>
              ReciterDataSourceImpl(), // Replace with your actual implementation
        ),

        // Repository Provider
        ProxyProvider<ReciterDataSource, ReciterRepository>(
          update: (context, dataSource, _) => ReciterRepositoryImpl(dataSource),
        ),

        // UseCase Provider
        ProxyProvider<ReciterRepository, GetReciterUseCase>(
          update: (context, repository, _) => GetReciterUseCase(repository),
        ),

        // Main Provider
        ChangeNotifierProvider<ReciterProvider>(
          create: (context) => ReciterProvider(
            Provider.of<GetReciterUseCase>(context, listen: false),
          )..fetchReciters(), // Fetch reciters on initialization
        ),
      ],
      child: MaterialApp(
        title: 'ICCMW',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: appTheme,
          ),
          useMaterial3: true,
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return selectedLabelStyle;
                }
                return unselectedLabelStyle;
              },
            ),
          ),
        ),
        // Fixed Text
        builder: (context, child) {
          // Override the text scale factor to always be 1.0
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        home: SplashScreen(),
        // home: const RootPage(onThemeSelected: _updateSeedColor),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  // const RootPage({super.key});

  const RootPage({
    super.key,
  });

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> page = const [
    HomePage(),
    DuaPage(),
    QuranPage(),
    // AboutUsPage(),
    DonatePage(),
  ];

  void openWebView(BuildContext context, String url) async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ICCMWPage(url: url, title: 'ICCMW'),
    //   ),
    // );

    final Uri uri = Uri.parse(url);

    // Check if the URL can be launched
    if (await canLaunchUrl(uri)) {
      // Launch the URL in an external application
      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication, // Ensure it opens in an external browser
      );
    } else {
      // Handle the error if the URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the URL')),
      );
    }
  }

  void openDonation(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    // Check if the URL can be launched
    if (await canLaunchUrl(uri)) {
      // Launch the URL in an external application
      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication, // Ensure it opens in an external browser
      );
    } else {
      // Handle the error if the URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          // padding: const EdgeInsets.symmetric(
          //   horizontal: 16.0, vertical: 10
          // ),
          child: AppBar(
            // backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            // foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            backgroundColor: appBarMainColor,
            // backgroundColor: const Color.fromRGBO(0, 153, 51, 1),
            // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ICCMW - Islamic Community',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
                const Text(
                  'Center of Mid-Westchester',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                )
              ],
            ),
            leading: Container(
              padding: const EdgeInsets.only(left: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  'assets/images/app/iccmwAppLogo.png',
                ),
              ),
            ),
            actions: [Container()],
            elevation: 0,
          ),
        ),
      ),
      body: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 18.0),
        child: PageView(
          children: [
            page[currentPage],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            // MaterialPageRoute(builder: (context) => SettingsPage()),
            MaterialPageRoute(builder: (context) => NotificationPage()),
          );
          // AwesomeNotifications().createNotification(
          //   content: NotificationContent(
          //     id: 1,
          //     channelKey: 'basic_channel',
          //     title: "Hello world",
          //     body: "I have local notification working now.",
          //   ),
          // );
        },
        child: const Icon(Icons.notifications),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(
            top: 25,
            right: 10,
            left: 10,
          ),
          // padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/app/iccmwLogo.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'About Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
            // ListTile(
            //   leading: const Image(
            //     image: AssetImage('assets/images/icons/marketing.png'),
            //     width: 32.0,
            //     height: 32.0,
            //   ),
            //   title: const Text('Annoucements',
            //                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const AnnoucementsPage()),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/whatsapp.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Join WhatsApp Groups',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SocialMediaPage()),
                );
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/mail.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsPage()),
                );
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/business.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Local Business Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BusinessPage()),
                );
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/jobPosting.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Job Posting',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const JosbpostingPage()),
                );
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/calendarCheck.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventsPage()),
                );
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/sportsActivity.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Sports Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SportsActivitiesPage()),
                );
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/zakatCalculator.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Zakat Calculator',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ZakatCalculatorPage()),
                );
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/qibla.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Qibla',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QiblaPage()),
                );
              },
            ),

            // ListTile(
            //   leading: const Image(
            //     image: AssetImage('assets/images/icons/community.png'),
            //     width: 32.0,
            //     height: 32.0,
            //   ),
            //   title: const Text('Community',
            //    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const CommunityPage()),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/services.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServicesPage()),
                );
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/tasbih.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Tasbeeh',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TasbeehPage()),
                );
              },
            ),
            // ListTile(
            //   leading: const Image(
            //     image: AssetImage('assets/images/icons/books.png'),
            //     width: 32.0,
            //     height: 32.0,
            //   ),
            //   title: const Text(
            //     'Hadiths',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const HadithPage()),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/allah.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                '99 Names of Allah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllahNamesPage()),
                );
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/home.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Home',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  currentPage = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/dua.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Dua',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  currentPage = 1;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/quranBook.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                "Qur'an",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuranPage()),
                );
                // setState(() {
                //   currentPage = 2;
                // });
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/wallet.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Donate',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const DonatePage()),
                // );
                setState(() {
                  currentPage = 3;
                });
                Navigator.pop(context);
              },
              // onTap: () async {
              //   var url = Uri.https("iccmw.org", '/donation');
              //   if (await canLaunchUrl(url)) {
              //     await launchUrl(url);
              //   }
              // },
              // onTap: () {
              // setState(() {
              //   currentPage = 3;
              // });
              // openDonation(context, 'https://iccmw.org/donate/');
              // Navigator.pop(context);
              // },
            ),
            // ListTile(
            //   leading: const Icon(Icons.login),
            //   title: const Text('Login',
            // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const LogInPage()),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons/settings.png'),
                width: 32.0,
                height: 32.0,
              ),
              title: const Text(
                'Setting',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                  // MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
            ),
            const Divider(
              height: 2,
              color: Colors.black26,
            ),
            SizedBox(height: 14),
            const ListTile(
              leading: Image(
                image: AssetImage('assets/images/app/iccmwLogo.png'),
                width: 64.0,
                height: 64.0,
              ),
              title: Text('ICCMW App is Developed & Maintain by ICCMW'),
            ),
            SizedBox(height: 4),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First Link
                InkWell(
                  onTap: () => openWebView(context, 'https://iccmw.org/'),
                  child: Text(
                    'ICCMW',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                SizedBox(height: 40),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        destinations: const [
          NavigationDestination(
            selectedIcon: Image(
              image: AssetImage('assets/images/icons/homeFilled.png'),
              width: 26,
              height: 26,
            ),
            icon: Image(
              image: AssetImage('assets/images/icons/home.png'),
              width: 26.0,
              height: 26.0,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Image(
              image: AssetImage('assets/images/icons/dua.png'),
              width: 26.0,
              height: 26.0,
            ),
            label: 'Dua',
          ),
          // NavigationDestination(
          //   selectedIcon: Image(
          //     image: AssetImage('assets/images/app/iccmwLogo.png'),
          //     width: 26,
          //     height: 26,
          //   ),
          //   icon: Image(
          //     image: AssetImage('assets/images/app/iccmwLogo.png'),
          //     width: 26.0,
          //     height: 26.0,
          //   ),
          //   label: "About Us",
          // ),
          NavigationDestination(
            selectedIcon: Image(
              image: AssetImage('assets/images/icons/quran.png'),
              width: 26,
              height: 26,
            ),
            icon: Image(
              image: AssetImage('assets/images/icons/quranBook.png'),
              width: 26,
              height: 26,
            ),
            label: "Qur'an",
          ),
          NavigationDestination(
            selectedIcon: Image(
              image: AssetImage('assets/images/icons/walletFilled.png'),
              width: 26,
              height: 26,
            ),
            icon: Image(
              image: AssetImage('assets/images/icons/wallet.png'),
              width: 26.0,
              height: 26.0,
            ),
            label: 'Donate',
          ),
          NavigationDestination(
            selectedIcon: Image(
              image: AssetImage('assets/images/icons/menu_moreFilled.png'),
              width: 26,
              height: 26,
            ),
            icon: Image(
              image: AssetImage('assets/images/icons/menu_more.png'),
              width: 26.0,
              height: 26.0,
            ),
            label: 'Menu',
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          if (index == 4) {
            _scaffoldKey.currentState?.openEndDrawer();
            // _scaffoldKey.currentState?.openDrawer();
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuranPage()),
            );
          }
          // else if (index == 3) {
          //   openDonation(context, 'https://iccmw.org/donate/');
          // }
          else {
            setState(() {
              currentPage = index;
            });
          }
        },
        // onDestinationSelected: (int index) {
        //   setState(() {
        //     currentPage = index;
        //   });
        // },
        selectedIndex: currentPage,
      ),
    );
  }
}

// Dark theme for bottom Navigation
//  bottomNavigationBar: NavigationBar(
//       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       destinations: const [
//         NavigationDestination(
//           selectedIcon: Image(
//             image: AssetImage('assets/images/icons/homeFilled.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.black,
//           ),
//           icon: Image(
//             image: AssetImage('assets/images/icons/home.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.white,
//           ),
//           label: 'Home',
//         ),
//         NavigationDestination(
//           selectedIcon: Image(
//             image: AssetImage('assets/images/icons/dua.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.black,
//           ),
//           icon: Image(
//             image: AssetImage('assets/images/icons/dua.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.white,
//           ),
//           label: 'Dua',
//         ),
//         NavigationDestination(
//           selectedIcon: Image(
//             image: AssetImage('assets/images/icons/quran.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.black,
//           ),
//           icon: Image(
//             image: AssetImage('assets/images/icons/quranBook.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.white,
//           ),
//           label: "Qur'an",
//         ),
//         NavigationDestination(
//           selectedIcon: Image(
//             image: AssetImage('assets/images/icons/walletFilled.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.black,
//           ),
//           icon: Image(
//             image: AssetImage('assets/images/icons/wallet.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.white,
//           ),
//           label: 'Donate',
//         ),
//         NavigationDestination(
//           selectedIcon: Image(
//             image: AssetImage('assets/images/icons/menu_moreFilled.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.black,
//           ),
//           icon: Image(
//             image: AssetImage('assets/images/icons/menu_more.png'),
//             width: 21.0,
//             height: 21.0,
//             color: Colors.white,
//           ),
//           label: 'More',
//         ),
//       ],
//       labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//       onDestinationSelected: (int index) {
//         if (index == 4) {
//           _scaffoldKey.currentState?.openEndDrawer();
//         } else if (index == 2) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const QuranPage()),
//           );
//         } else {
//           setState(() {
//             currentPage = index;
//           });
//         }
//       },
//       // onDestinationSelected: (int index) {
//       //   setState(() {
//       //     currentPage = index;
//       //   });
//       // },
//       selectedIndex: currentPage,
//     ),
