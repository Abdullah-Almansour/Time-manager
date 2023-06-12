import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:awesome_notifications/awesome_notifications.dart' as nf;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiffy/jiffy.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:time_manager/ProfileEdit.dart';
import 'package:time_manager/ViewTask.dart';
import 'package:time_manager/helper/FlutterA.dart';
import 'package:time_manager/helper/Notify.dart';
import 'CalendarTasks.dart';
import 'Contact.dart';
import 'Home.dart';
import 'Login.dart';
import 'RecoverPassword.dart';
import 'Register.dart';
import 'Splash.dart';
import 'TimerPage.dart';
import 'helper/FileHelper.dart';
import 'helper/Lang.dart';
import 'helper/MyColors.dart';
import 'helper/Pref.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  nf.AwesomeNotifications().initialize(
      null,
      [
        nf.NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: MyColors.primary,
            playSound: false,
            importance: NotificationImportance.High,
            ledColor: MyColors.black2)
      ],
      channelGroups: [
        nf.NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);




  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  Intl.systemLocale = "en_US";
  Pref.pref = await SharedPreferences.getInstance();
  await adan_notify();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      EasyLocalization(
          supportedLocales: [Lang.english, Lang.arabic],
          path: 'assets/translations',
          fallbackLocale: Lang.english,
          startLocale: Lang.english,
          child: MyApp()),
    );
  });
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        builder: (context, child) => ResponsiveWrapper.builder(child,
            maxWidth: 1200,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ]),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        home: Splash(),
        routes: {
          "splash": (context) => Splash(),
          "login": (context) => Login(),
          "home": (context) => Home(),
          "contact": (context) => Contact(),
          "timer": (context) => TimerPage(),
          "profile_edit": (context) => ProfileEdit(),
          "register": (context) => Register(),
          "re_password": (context) => RecoverPassword(),
          "view_task": (context) => ViewTask(null),
          "tasks_calendar": (context) => CalendarTasks(),
        },
        navigatorKey: NavigationService.navigationKey,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/view_task':
              return MaterialPageRoute(
                  builder: (_) => ViewTask(settings.arguments as String));
            default:
              return null;
          }
        },
        theme: ThemeData(
          primaryColor: MyColors.primary,
          primarySwatch: MaterialColor(MyColors.primarySwatch, MyColors.color),
          colorScheme: ColorScheme.light(
            primary: MyColors.primary,
            secondary: MyColors.primary,
          ),
          fontFamily: (Lang.isArabic(context.locale)) ? "Bold" : "",
          unselectedWidgetColor: MyColors.primary,
          canvasColor: Colors.white,
          brightness: Brightness.light,
          textTheme: TextTheme(
              titleSmall: TextStyle(
                color: MyColors.gray,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: TextStyle(
                color: MyColors.primary,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: TextStyle(
                color: MyColors.primary,
                fontSize: 15,
              ),
              bodyMedium: TextStyle(
                color: Colors.black,
              )),
        ),
      );
    });
  }
}

adan_notify() async {
  Position position = await _determinePosition();
  final params = CalculationMethod.umm_al_qura.getParameters();
  params.madhab = Madhab.hanafi;
  final myCoordinates = Coordinates(position.latitude, position.longitude);
  PrayerTimes prayerTimes = PrayerTimes.today(myCoordinates, params);
  Timer.periodic(Duration(minutes: 1), (Timer t) async {
    Jiffy jiffy = new Jiffy(DateTime.now());
    String current_time = jiffy.format("h:mm a");

    if (Pref.get_fajarNotify() && current_time == DateFormat.jm().format(prayerTimes.fajr)) {
          Notify.send_adan("It's time for".tr() + " " + "Fajr prayer".tr());
          await FileHelper.playAdan();
    }
    if (Pref.get_dhuhrNotify() && current_time == DateFormat.jm().format(prayerTimes.dhuhr)) {
          Notify.send_adan("It's time for".tr() + " " + "Dhuhr prayer".tr());
          await FileHelper.playAdan();
    }
    if (Pref.get_asrNotify() && current_time == DateFormat.jm().format(prayerTimes.asr)) {
          Notify.send_adan("It's time for".tr() + " " + "Asr prayer".tr());
          await FileHelper.playAdan();
    }
    if (Pref.get_maghribNotify()  && current_time == DateFormat.jm().format(prayerTimes.maghrib)) {
          Notify.send_adan("It's time for".tr() + " " + "Maghrib prayer".tr());
          await FileHelper.playAdan();
    }
    if (Pref.get_ishaNotify() && current_time == DateFormat.jm().format(prayerTimes.isha)) {
          Notify.send_adan("It's time for".tr() + " " + "Isha prayer".tr());
          await FileHelper.playAdan();
    }
  });
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
