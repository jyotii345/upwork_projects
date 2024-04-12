import 'dart:io';

import 'package:aggressor_adventures/bloc/user_cubit/user_cubit.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/message_bloc/message_bloc.dart';
import 'classes/globals.dart';
import 'user_interface_pages/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/standalone.dart' as tz;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterAppBadger.removeBadge();

  HttpOverrides.global = MyHttpOverrides();
  tz.initializeTimeZones();
  // final detroit = tz.getLocation('America/New_York');
  // tz.setLocalLocation(detroit);

  tz.initializeTimeZones();
  final String locationName = 'America/New_York';
  tz.setLocalLocation(tz.getLocation(locationName));
  requestPermission();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error!\n${details.exception}',
        style: const TextStyle(color: Colors.yellow),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      ),
    );
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MessageBloc()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: false,
        child: MaterialApp(
          title: 'Adventure Of A Lifetime',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: AggressorColors.primaryColor,
          ),
          navigatorKey: navigatorKey,
          home: LoginPage(),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> requestPermission() async {
  final permission = Permission.storage;
  if (await permission.isDenied) {
    await permission.request();
  }
}
