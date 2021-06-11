import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileLinkPage extends StatefulWidget {
  ProfileLinkPage(this.user, this.message);

  final User user;
  final String message;

  @override
  State<StatefulWidget> createState() => new ProfileLinkPageState();
}

class ProfileLinkPageState extends State<ProfileLinkPage> {
  /*
  instance vars
   */


  /*
  initState

  Build
   */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    homePage = false;
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(),
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(widget.message),
          ),
        ],
      ),
      bottomNavigationBar: getBottomNavigation(),
    );
  }

/*
  self implemented
   */

  makeCall() async {
    //method to open phone call from application
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePopupClick(String value) {
    //handles the menu bar options
    switch (value) {
      case 'My Profile':
        print("loading");
    }
  }

  Widget getBottomNavigation() {
    /*
    returns a bottom navigation bar widget containing the pages desired and their icon types. This is only for the look of the bottom navigation bar
     */

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (int) {},
      backgroundColor: AggressorColors.primaryColor,
      // new
      currentIndex: 0,
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
}
