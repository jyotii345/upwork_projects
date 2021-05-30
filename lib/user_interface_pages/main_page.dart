import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/gallery.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/boat_database.dart';
import 'package:aggressor_adventures/databases/charter_database.dart';
import 'package:aggressor_adventures/databases/files_database.dart';
import 'package:aggressor_adventures/databases/photo_database.dart';
import 'package:aggressor_adventures/databases/trip_database.dart';
import 'package:aggressor_adventures/databases/user_database.dart';
import 'package:aggressor_adventures/user_interface_pages/photos_page.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  }

  /*
  build method

  This build method creates the outlilne for the application. This contains the bottomNavigationBar and the overhead Appbar that are present through the entire application
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: SizedBox(
            height: AppBar().preferredSize.height,
            child: IconButton(
              icon: Container(
                child: Image.asset("assets/callicon.png"),
              ),
              onPressed: makeCall,
            ),
          ),
          title: Image.asset(
            "assets/logo.png",
            height: AppBar().preferredSize.height,
            fit: BoxFit.fitHeight,
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: SizedBox(
                height: AppBar().preferredSize.height,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton<String>(
                      onSelected: handlePopupClick,
                      child: Container(
                        child: Image.asset(
                          "assets/menuicon.png",
                        ),
                      ),
                      itemBuilder: (BuildContext context) {
                        return {"My Profile", "Sign Out"}.map((String option) {
                          return PopupMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList();
                      }),
                ),
              ),
            ),
          ],
        ),
        body: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: getBottomNavigation(),
          body: getIndexStack(),
        ));
  }

/*
  Self implemented
   */

  makeCall() async {
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePopupClick(String value) {
    switch (value) {
      case 'My Profile':
        setState(() {
          currentIndex = 5;
        });
        break;
      case 'Sign Out':
        signOutUser();
        break;
    }
  }

  void signOutUser() async {
    //sings user out and clears databases
    UserDatabaseHelper helper = UserDatabaseHelper.instance;
    await helper.deleteUser(100);

    TripDatabaseHelper tripDatabaseHelper = TripDatabaseHelper.instance;
    await tripDatabaseHelper.deleteTripTable();

    PhotoDatabaseHelper photoDatabaseHelper = PhotoDatabaseHelper.instance;
    await photoDatabaseHelper.deletePhotoTable();

    FileDatabaseHelper fileDatabaseHelper = FileDatabaseHelper.instance;
    await fileDatabaseHelper.deleteFileTable();

    CharterDatabaseHelper charterDatabaseHelper =
        CharterDatabaseHelper.instance;
    await charterDatabaseHelper.deleteCharterTable();

    BoatDatabaseHelper boatDatabaseHelper = BoatDatabaseHelper.instance;
    await boatDatabaseHelper.deleteBoatTable();

    loadedCount = 0;
    loadingLength = 0;

    loadedCount = 0;
    loadingLength = 0;

    galleriesMap = <String, Gallery>{};
    notLoadedList = [];
    tripList = [];
    loadSize = [];
    boatList = [];
    sliderImageList = [];
    notesList = [];

    photosLoaded = false;
    notesLoaded = false;

    currentIndex = 0;

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void onTabTapped(int index) {
    /*
    set the state of the navigation bar selection to index
     */
    setState(() {
      currentIndex = index;
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
        Rewards(),
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

  Widget getBottomNavigation() {
    /*
    returns a bottom navigation bar widget containing the pages desired and their icon types. This is only for the look of the bottom navigation bar
     */

    double iconSize = MediaQuery.of(context).size.height / 20;
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped,
      backgroundColor: AggressorColors.primaryColor,
      // new
      currentIndex: currentIndex > 4 ? 0 : currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      items: [
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/tripsactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/tripspassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/notesactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/notespassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/photosactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/photospassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/rewardsactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/rewardspassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/filesactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/filespassive.png"),
          ),
          label: '',
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
