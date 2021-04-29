import 'dart:ui';

import 'package:aggressor_adventures/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

MaterialColor myColor = MaterialColor(0xFFC8911A, color);

Map<int, Color> color = {
  50: Color.fromRGBO(200, 145, 26, .1),
  100: Color.fromRGBO(200, 145, 26, .2),
  200: Color.fromRGBO(200, 145, 26, .3),
  300: Color.fromRGBO(200, 145, 26, .4),
  400: Color.fromRGBO(200, 145, 26, .5),
  500: Color.fromRGBO(200, 145, 26, .6),
  600: Color.fromRGBO(200, 145, 26, .7),
  700: Color.fromRGBO(200, 145, 26, .8),
  800: Color.fromRGBO(200, 145, 26, .9),
  900: Color.fromRGBO(200, 145, 26, 1),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aggressor Adventures',
      theme: ThemeData(
        primarySwatch: myColor,
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 4;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      color: Color(0xff59A3C0),
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
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0),child:SizedBox(
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
          ),),
        ],
      ),
      body: Scaffold(
        bottomNavigationBar: getBottomNavigation(),
        body: getIndexStack(),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getIndexStack() {
    return IndexedStack(
      children: <Widget>[
        loginPage(), //trips page
        loginPage(), // notes page
        loginPage(), // photos page
        loginPage(), // rewards page
        loginPage(), // files page
        loginPage(), // login page
      ],
      index: _currentIndex,
    );
  }

  Widget getBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped,
      backgroundColor: myColor,
      // new
      currentIndex: _currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      items: [
        new BottomNavigationBarItem(
          icon: Image.asset("assets/trips.png"),
          title: Text('MY TRIPS'),
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/notes.png"),
          title: Text('NOTES'),
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/photos.png"),
          title: Text('PHOTOS'),
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/rewards.png"),
          title: Text('REWARDS'),
        ),
        new BottomNavigationBarItem(
          icon: Image.asset("assets/files.png"),
          title: Text('MY FILES'),
        ),
      ],
    );
  }
}
