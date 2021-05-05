import 'dart:convert';
import 'dart:ui';

import 'package:aggressor_adventures/my_files.dart';
import 'package:aggressor_adventures/my_profile.dart';
import 'package:aggressor_adventures/my_trips.dart';
import 'package:aggressor_adventures/notes.dart';
import 'package:aggressor_adventures/photos.dart';
import 'package:aggressor_adventures/rewards.dart';
import 'package:aggressor_adventures/trip.dart';
import 'package:aggressor_adventures/user.dart';
import 'package:aggressor_adventures/user_database.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

import 'aggressor_colors.dart';
import 'agressor_api.dart';
import 'login.dart';

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

  Database database;
  DatabaseHelper helper;

  List<Trip> tripList;

  AsyncMemoizer tripListMemoizer = AsyncMemoizer();

  Future tripListFuture;

  /*
  init state
   */
  @override
  void initState() {
    super.initState();
    helper = DatabaseHelper.instance;
    tripList = [];
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
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: IconButton(
                    icon: Icon(
                      Icons.phone_enabled_rounded,
                      color: Color(0xff59a3c0),
                    ),
                    onPressed: () {
                      print("button pressed");
                    }),
              ),
              Flexible(
                flex: 0,
                child: Text(
                  "CALL",
                  style: TextStyle(
                      color: Color(0xff59A3C0),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
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
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: PopupMenuButton<String>(
                        onSelected: handlePopupClick,
                        child: Icon(
                          Icons.menu,
                          color: Color(0xff59A3C0),
                          size: 30,
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
                  Flexible(
                    flex: 0,
                    child: Text(
                      "MENU",
                      style: TextStyle(
                          color: Color(0xff59A3C0),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
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
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

/*
  Self implemented
   */

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
        Photos(),
        // photos page
        Rewards(),
        // rewards page
        MyFiles(),
        // files page
        loginPage(loginCallback),
        // login page
        currentUser == null ? Container() : MyProfile(currentUser),
        //my profile page
      ],
      index: _currentIndex,
    );
  }

  Widget getBottomNavigation() {
    /*
    returns a bottom navigation bar widget containing the pages desired and their icon types. This is only for the look of the bottom navigation bar
     */
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped,
      backgroundColor: AggressorColors.primaryColor,
      // new
      currentIndex: _currentIndex > 4 ? 0 : _currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      items: [
        new BottomNavigationBarItem(
          icon: Image.asset("assets/trips.png"),
          //TODO replace with final graphic
          label: 'MY TRIPS',
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/notes.png"),
          //TODO replace with final graphic
          label: 'NOTES',
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/photos.png"),
          //TODO replace with final graphic
          label: 'PHOTOS',
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/rewards.png"),
          //TODO replace with final graphic
          label: 'REWARDS',
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/files.png"),
          //TODO replace with final graphic
          label: 'MY FILES',
        ),
      ],
    );
  }

  Future<dynamic> checkLoginStatus() async {
    //check if the user is logged in and set the appropriate view if they are or are not
    return loginMemoizer.runOnce(() async {
      var userList = await helper.queryUser();
      try {
        setState(() {
          currentUser = userList[0];
        });
      } catch (e) {
        logoutCallback();
      }
      if (currentUser.userId == null) {
        logoutCallback();
        return "no user";
      } else {
        tripListFuture = tripListMemoizer.runOnce(
            () => AggressorApi().getReservationList(currentUser.contactId));
        loginCallback();
      }

      return currentUser;
    });
  }

  void loginCallback() {
    if (_currentIndex > 4) {
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  void logoutCallback() {
    if (_currentIndex < 5) {
      setState(() {
        _currentIndex = 5;
      });
    }
  }
}
