import 'dart:convert';
import 'dart:ui';

import 'package:aggressor_adventures/my_files.dart';
import 'package:aggressor_adventures/my_trips.dart';
import 'package:aggressor_adventures/notes.dart';
import 'package:aggressor_adventures/photos.dart';
import 'package:aggressor_adventures/rewards.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'aggressor_colors.dart';
import 'login.dart';

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
  int _currentIndex = 5;

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
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.menu,
                        color: Color(0xff59A3C0),
                      ),
                      onPressed: () {
                        print("menu option pressed");
                        // do something
                      },
                    ),
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
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: getBottomNavigation(),
        body: getIndexStack(),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /*
  Self implemented
   */


  void onTabTapped(int index) {
    /*
    set the state of the navigation bar selection to index
     */
    setState(() {
      _currentIndex = index;
    });
  }

  Widget getIndexStack() {
    /*
    Returns an indexed Stack widget containing the value of what dart page belongs at which button of the navitgation bar, the extra option is for the login page, will show if the user is not verified
     */
    return IndexedStack(
      children: <Widget>[
        MyTrips(), //trips page
        Notes(), // notes page
        Photos(), // photos page
        Rewards(), // rewards page
        MyFiles(), // files page
        loginPage(), // login page
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
          label: 'MY TRIPS',
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/notes.png"),
          label: 'NOTES',
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/photos.png"),
          label: 'PHOTOS',
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/rewards.png"),
          label: 'REWARDS',
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/files.png"),
          label: 'MY FILES',
        ),
      ],
    );
  }
}
