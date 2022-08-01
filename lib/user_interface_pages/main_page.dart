import 'package:aggressor_adventures/classes/gallery.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/boat_database.dart';
import 'package:aggressor_adventures/databases/certificate_database.dart';
import 'package:aggressor_adventures/databases/charter_database.dart';
import 'package:aggressor_adventures/databases/contact_database.dart';
import 'package:aggressor_adventures/databases/countries_database.dart';
import 'package:aggressor_adventures/databases/files_database.dart';
import 'package:aggressor_adventures/databases/iron_diver_database.dart';
import 'package:aggressor_adventures/databases/notes_database.dart';
import 'package:aggressor_adventures/databases/offline_database.dart';
import 'package:aggressor_adventures/databases/photo_database.dart';
import 'package:aggressor_adventures/databases/profile_database.dart';
import 'package:aggressor_adventures/databases/slider_database.dart';
import 'package:aggressor_adventures/databases/states_database.dart';
import 'package:aggressor_adventures/databases/trip_database.dart';
import 'package:aggressor_adventures/databases/user_database.dart';
import 'package:aggressor_adventures/user_interface_pages/photos_page.dart';
import 'package:aggressor_adventures/user_interface_pages/reels_page.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import '../testScreenn.dart';
import 'login_page.dart';
import 'files_page.dart';
import 'profile_view_page.dart';
import 'trips_page.dart';
import 'notes_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.user, this.tripList}) : super(key: key);

  final User user;
  final List<Trip>? tripList;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  /*
  instance variables
   */

  UserDatabaseHelper? helper;

  Widget galleryWidget = Container();

  /*
  init state
   */

  @override
  void initState() {
    super.initState();
    pageList = [
      MyTrips(
        widget.user,
      ),
      //trips page
      Rewards(widget.user),
      // notes page
      Photos(
        widget.user,
      ),
      // photos page
      // rewards page
      Reels(widget.user, refreshState),
      // login page
      MyProfile(widget.user),
      //my profile page
      MyFiles(widget.user),
      // my files page
      Notes(widget.user),
    ];
    helper = UserDatabaseHelper.instance;
    mainPageCallback = refreshState;
    mainPageSignOutCallback = signOutUser;
    homePage = true;

    //fcm
    initializeFcmSetup();
  }




  initializeFcmSetup() async {
    String? token=await FirebaseMessaging.instance.getToken();

    print(token.toString());

    FlutterAppBadger.removeBadge();


    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print(message);
      if (message != null) {

        String? imgUrl=message.notification!.android==null?message.notification!.apple==null?null:message.notification!.apple!.imageUrl  :message.notification!.android!.imageUrl;

        _showMyDialog(message.notification!.body??"", message.notification!.title??"",imageurl:imgUrl);

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print(message);
      print(message.notification);
      print(message.notification!.title);
      // print(message.notification!.android!.imageUrl);
      // print(message.notification!.apple!.imageUrl);

      String? imgUrl=message.notification!.android==null?message.notification!.apple==null?null:message.notification!.apple!.imageUrl  :message.notification!.android!.imageUrl;

      _showMyDialog(message.notification!.body??"", message.notification!.title??"",imageurl:imgUrl);

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');


      String? imgUrl=message.notification!.android==null?message.notification!.apple==null?null:message.notification!.apple!.imageUrl  :message.notification!.android!.imageUrl;

      _showMyDialog(message.notification!.body??"", message.notification!.title??"",imageurl:imgUrl);

    });
  }

  Future<void> _showMyDialog(String msg,String title,{String? imageurl}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,

          title:  Column(
            children: [

              imageurl==null?
              Image.asset("assets/notification.png",scale: 3,):
              Image.network(imageurl,scale: 3,),

              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Text(title,textAlign: TextAlign.center,),
              ),
            ],
          ),
          content: Text(msg,textAlign: TextAlign.center,),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }


  var pageList = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    homePage = true;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: showVideo ? null : getAppBar(),
      body: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: showVideo ? null : getBottomNavigationBar(),
          body:

          // TextButton(
          //   onPressed: (){
          //     _showMyDialog("asdd","sdad");
          //   },
          //   child: Text("button"),
          // )
          //
          pageList[currentIndex]

          ),
    );
  }

/*
  Self implemented
   */

  refreshState() {
    setState(() {});
  }

  void signOutUser() async {
    //sings user out and clears databases

    await BoatDatabaseHelper.instance.deleteBoatTable();
    await CertificateDatabaseHelper.instance.deleteCertificateTable();
    await CharterDatabaseHelper.instance.deleteCharterTable();
    await ContactDatabaseHelper.instance.deleteContactTable();
    await CountriesDatabaseHelper.instance.deleteCountriesTable();
    await FileDatabaseHelper.instance.deleteFileTable();
    await IronDiverDatabaseHelper.instance.deleteIronDiverTable();
    await NotesDatabaseHelper.instance.deleteNotesTable();
    await OfflineDatabaseHelper.instance.deleteOfflineTable();
    await PhotoDatabaseHelper.instance.deletePhotoTable();
    await ProfileDatabaseHelper.instance.deleteProfileTable();
    await SlidersDatabaseHelper.instance.deleteSlidersTable();
    await StatesDatabaseHelper.instance.deleteStatesTable();
    await TripDatabaseHelper.instance.deleteTripTable();
    await UserDatabaseHelper.instance.deleteUser(100);

    setState(() {
      navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  Widget getIndexStack() {
    /*
    Returns an indexed Stack widget containing the value of what dart page belongs at which button of the navitgation bar, the extra option is for the login page, will show if the user is not verified
     */

    return IndexedStack(
      children: <Widget>[
        MyTrips(
          widget.user,
        ),
        //trips page
        Rewards(widget.user),
        // notes page
        Photos(
          widget.user,
        ),
        // photos page
        // rewards page
        Reels(widget.user, refreshState),
        // login page
        MyProfile(widget.user),
        //my profile page
        MyFiles(widget.user),
        // my files page
        Notes(widget.user),
        // my notes page
      ],
      index: currentIndex,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
