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
import 'package:aggressor_adventures/user_interface_pages/rewards_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'files_page.dart';
import 'profile_view_page.dart';
import 'trips_page.dart';
import 'notes_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.user, this.tripList}) : super(key: key);

  final User user;
  final List<Trip> tripList;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  /*
  instance variables
   */

  UserDatabaseHelper helper;

  Widget galleryWidget = Container();

  /*
  init state
   */
  @override
  void initState() {
    super.initState();
    helper = UserDatabaseHelper.instance;
    mainPageCallback = refreshState;
    mainPageSignOutCallback = signOutUser;
    homePage = true;
  }

  /*
  build method

  This build method creates the outlilne for the application. This contains the bottomNavigationBar and the overhead Appbar that are present through the entire application
   */
  @override
  Widget build(BuildContext context) {
    super.build(context);

    homePage = true;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(),
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: getBottomNavigationBar(),
        body: getIndexStack(),
      ),
    );
  }

/*
  Self implemented
   */


  VoidCallback refreshState(){
    setState(() {
    });
  }

  void signOutUser() async {
    //sings user out and clears databases

    setState(() {
      BoatDatabaseHelper.instance.deleteBoatTable();
      CertificateDatabaseHelper.instance.deleteCertificateTable();
      CharterDatabaseHelper.instance.deleteCharterTable();
      ContactDatabaseHelper.instance.deleteContactTable();
      CountriesDatabaseHelper.instance.deleteCountriesTable();
      FileDatabaseHelper.instance.deleteFileTable();
      IronDiverDatabaseHelper.instance.deleteIronDiverTable();
      NotesDatabaseHelper.instance.deleteNotesTable();
      OfflineDatabaseHelper.instance.deleteOfflineTable();
      PhotoDatabaseHelper.instance.deletePhotoTable();
      ProfileDatabaseHelper.instance.deleteProfileTable();
      SlidersDatabaseHelper.instance.deleteSlidersTable();
      StatesDatabaseHelper.instance.deleteStatesTable();
      TripDatabaseHelper.instance.deleteTripTable();
      UserDatabaseHelper.instance.deleteUser(100);

      loadedCount = 0;
      loadingLength = 0;
      photosLoaded = false;
      notesLoaded = false;
      certificateLoaded = false;
      ironDiversLoaded = false;
      contactLoaded = false;
      profileDataLoaded = false;
      online = true;
      filesLoaded = false;
      homePage = false;

      currentIndex = 0;

      galleriesMap = <String, Gallery>{};
      profileData = <String, dynamic>{};
      fileDisplayNames = <String, String>{};

      notLoadedList = [];
      tripList = [];
      loadSize = [];
      boatList = [];
      fileDataList = [];
      statesList = [];
      countriesList = [];
      sliderImageList = [];
      notesList = [];
      ironDiverList = [];
      certificationList = [];

      contact = null;

      List<String> certificationOptionList = [
        'Non-Diver',
        'Junior Open Water',
        'Open Water',
        'Advanced Open Water',
        'Rescue Diver',
        'Master Scuba Diver',
        'Dive Master',
        'Assistant Instructor',
        'Instructor',
        'Instructor Trainer',
        'Nitrox',
      ];

      navigatorKey.currentState
          .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
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
        Notes(
          widget.user,
        ),
        // notes page
        Photos(
          widget.user,
        ),
        // photos page
        Rewards(widget.user),
        // rewards page
        MyFiles(
          widget.user,
        ),
        // login page
        MyProfile(widget.user),
        //my profile page
      ],
      index: currentIndex,
    );
  }



  @override
  bool get wantKeepAlive => true;
}
