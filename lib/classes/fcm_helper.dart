import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import '../user_interface_pages/widgets/dialogue_helper.dart';

class FCMHelper {
  static FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // // TODO paste in main.dart
  // @pragma('vm:entry-point')
  // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp();
  //
  //   print("Handling a background message: ${message.messageId}");
  // }
  //
  // Future<void> main() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //
  //   FlutterAppBadger.removeBadge();
  //
  //   runApp(MyApp());
  // }

  static Future<String?> generateFCMToken() async {
    try {
      String? token = await _messaging.getToken();

      print(token.toString());
      return token;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<String?> sendNotification() async {
    try {
      String? token = await _messaging.getToken();

      await _messaging.sendMessage(to: token, data: {
        "title": "title",
        "body": "title",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
      });

      print(token.toString());
      return token;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static initializeFcmSetup(context, Function callBack,String contactId,String userId) async {
    FlutterAppBadger.removeBadge();

    await _getPermissions();

    _messaging.getInitialMessage().then((RemoteMessage? message) {
      print(message);
      if (message != null) {
        _handleNotification(message, context, callBack,contactId,userId);
      }
    });

    //when app is open
    _foregroundMessages(context, callBack,contactId,userId);
    _openFromBackgroundMessages(context, callBack,contactId,userId);
  }

  static Future<void> _getPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  static _foregroundMessages(context, Function callBack,String contactId,String userId) {
    //when app is open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleNotification(message, context, callBack,contactId,userId);
    });
  }

  static _openFromBackgroundMessages(context, Function callBack,String contactId,String userId) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message, context, callBack,contactId,userId);
    });
  }

  static _handleNotification(
      RemoteMessage message, context, Function callBack,String contactId,String userId) {
    String? imgUrl = message.notification!.android == null
        ? message.notification!.apple == null
            ? null
            : message.notification!.apple!.imageUrl
        : message.notification!.android!.imageUrl;

    CustomDialogues.notificationDialog(message.notification!.body ?? "",
        message.notification!.title ?? "", context,
        imageUrl: imgUrl, callBack,contactId,userId);
  }
}
