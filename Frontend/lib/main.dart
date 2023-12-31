import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:ho_pla/util/ho_pla_theme.dart';
import 'package:ho_pla/util/uni_links.dart';
import 'package:ho_pla/views/devices_overview.dart';
import 'package:ho_pla/views/login.dart';
import 'package:ho_pla/views/new_house.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required for using plugins before runApp

  final preferences = await SharedPreferences.getInstance();
  final bool darkMode = preferences.getBool('darkmode') ?? false;
  // Set current user id if available
  CurrentUser.id = preferences.getString('userid') ?? "";
  CurrentUser.houseId = preferences.getString('houseid') ?? "";

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //TODO: move to login
  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(provisional: true);

  final token = await FirebaseMessaging.instance.getToken();

  UniLinks.initUniLinks();

  if (token != null) {
    debugPrint(token);
  }

  runApp(MyApp(darkMode: darkMode));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  final bool darkMode;

  const MyApp({super.key, required this.darkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Widget firstWidget;

    // Decide what to display first: Login, JoinHouse or DeviceOverview
    if (CurrentUser.id == "") {
      firstWidget = const LoginWidget();
    } else if (CurrentUser.houseId == "") {
      firstWidget = const NewHouseWidget();
    } else {
      firstWidget = DevicesOverviewWidget(CurrentUser.houseId);
    }

    return ThemeProvider(
        initTheme: widget.darkMode ? customDarkTheme : ThemeData.light(),
        builder: (context, myTheme) {
          return MaterialApp(
            title: 'HoPla Demo',
            theme: myTheme,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            home: firstWidget,
          );
        });
  }

  @override
  void initState() {
    super.initState();

    // handle firebase notification if app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      debugPrint("Received foreground notification");

      if (notification != null && notification.body != null) {
        showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) => Center(
                  child: Material(
                    color: Colors.transparent,
                    child:
                        Text("Received a notification:\n${notification.body!}"),
                  ),
                ));

        debugPrint("Showed notification");
      } else {
        debugPrint("Received an empty notification");
      }
    });
  }
}
