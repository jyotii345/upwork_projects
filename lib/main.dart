import 'dart:io';

import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:aggressor_adventures/testScreenn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'classes/globals.dart';
import 'user_interface_pages/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId} from top level function');
}

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

   FlutterAppBadger.removeBadge();

   HttpOverrides.global = MyHttpOverrides();

   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adventure Of A Lifetime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AggressorColors.primaryColor,
      ),
      navigatorKey: navigatorKey,
      home:
      LoginPage()
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}