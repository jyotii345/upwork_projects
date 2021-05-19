import 'dart:ui';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/user_interface_pages/my_files_page.dart';
import 'package:aggressor_adventures/user_interface_pages/photos_page.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_page.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/user_database.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'user_interface_pages/login_page.dart';
import 'user_interface_pages/my_profile_page.dart';
import 'user_interface_pages/my_trips_page.dart';
import 'user_interface_pages/notes_page.dart';

final AsyncMemoizer loginMemoizer = AsyncMemoizer();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aggressor Adventures',
      theme: ThemeData(
        primarySwatch: AggressorColors.primaryColor,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*
  instance variables
   */
  int _currentIndex = 0;

  User currentUser;

  UserDatabaseHelper helper;

  List<Trip> tripList;

  AsyncMemoizer tripListMemoizer = AsyncMemoizer();

  Future tripListFuture;

  bool haveCheckedLogin;

  /*
  init state
   */
  @override
  void initState() {
    super.initState();
    helper = UserDatabaseHelper.instance;
    tripList = [];
    haveCheckedLogin = false;
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
                      return {
                        "My Profile",
                      }.map((String option) {
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
      body: FutureBuilder(
          future: checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data == "no user") {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  bottomNavigationBar: getBottomNavigation(),
                  body: getIndexStack(<Trip>[]),
                );
              }
              return FutureBuilder(
                  future: tripListFuture,
                  builder: (context, snapshotOne) {
                    if (snapshotOne.hasData && snapshotOne.data != null) {
                      return Scaffold(
                        resizeToAvoidBottomInset: false,
                        bottomNavigationBar: getBottomNavigation(),
                        body: getIndexStack(snapshotOne.data),
                      );
                    } else {
                      return Scaffold(
                        resizeToAvoidBottomInset: false,
                        bottomNavigationBar: getBottomNavigation(),
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  });
            } else {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                bottomNavigationBar: getBottomNavigation(),
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
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
          _currentIndex = 6;
        });
    }
  }

  void onTabTapped(int index) {
    /*
    set the state of the navigation bar selection to index
     */
    setState(() {
      _currentIndex = index;
    });
  }

  Widget getIndexStack(var tripList) {
    /*
    Returns an indexed Stack widget containing the value of what dart page belongs at which button of the navitgation bar, the extra option is for the login page, will show if the user is not verified
     */

    return IndexedStack(
      children: <Widget>[
        currentUser == null ? Container() : MyTrips(currentUser, tripList),
        //trips page
        currentUser == null ? Container() : Notes(currentUser, tripList),
        // notes page
        Photos(currentUser, tripList),
        // photos page
        Rewards(),
        // rewards page
        MyFiles(currentUser),
        // files page
        LoginPage(loginCallback),
        // login page
        currentUser == null
            ? Container()
            : MyProfile(currentUser, logoutCallback),
        //my profile page
      ],
      index: _currentIndex,
    );
  }

  Widget getBottomNavigation() {
    /*
    returns a bottom navigation bar widget containing the pages desired and their icon types. This is only for the look of the bottom navigation bar
     */

    double iconSize = MediaQuery.of(context).size.width / 8;
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      type: BottomNavigationBarType.fixed,
      onTap: currentUser == null ? (int) {} : onTabTapped,
      backgroundColor: AggressorColors.primaryColor,
      // new
      currentIndex: _currentIndex > 4 ? 0 : _currentIndex,
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

  Future<dynamic> checkLoginStatus() async {
    //check if the user is logged in and set the appropriate view if they are or are not
    if (!haveCheckedLogin) {
      var userList = await helper.queryUser();
      try {
        setState(() {
          currentUser = userList[0];
        });
      } catch (e) {
        logoutCallback();
      }
      if (currentUser == null) {
        logoutCallback();
        return "no user";
      } else {
        tripListFuture =
            AggressorApi().getReservationList(currentUser.contactId);
        loginCallback();
      }
    }

    return currentUser;
  }

  void loginCallback() {
    setState(() {
      haveCheckedLogin = true;
    });
    if (_currentIndex > 4) {
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  void logoutCallback() {
    if (_currentIndex != 5) {
      setState(() {
        haveCheckedLogin = false;
        _currentIndex = 5;
        currentUser = null;
      });
    }
  }
}
