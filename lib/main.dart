import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hair_and_more/controllers/authProv.dart';
import 'package:hair_and_more/controllers/profileSettingsProv.dart';
import 'package:hair_and_more/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onMessage.listen((event) {
    print("caught new notif");
    print(
        " title ${event.notification?.title} body ${event.notification?.body}");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProv(),
          ),
          ChangeNotifierProvider(
            create: (context) => ProfileSettingsProv(),
          ),
        ],
        child: ResponsiveSizer(
          builder: (p0, p1, p2) =>  MaterialApp(
              debugShowCheckedModeBanner: false, home: SplashScreen()),
        ));
  }
}
