library user_interface;

import 'package:aggressor_adventures/user_interface_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aggressor_colors.dart';
import 'globals.dart';

double iconSizePortrait =
    MediaQuery.of(navigatorKey.currentContext).size.width / 10;
double iconSizeLandscape =
    MediaQuery.of(navigatorKey.currentContext).size.height / 10;
double iconImageSize =
    MediaQuery.of(navigatorKey.currentContext).size.width / 15;

int popDistance = 0;
bool portrait = true;

VoidCallback mainPageCallback;

VoidCallback mainPageSignOutCallback;

Widget getBottomNavigationBar() {
  return OrientationBuilder(
    builder: (context, orientation) {
      orientation == Orientation.portrait ? portrait = true : portrait = false;
      return BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          onTabTapped(index, orientation);
        },
        backgroundColor: AggressorColors.primaryColor,
        currentIndex: currentIndex > 4 ? 0 : currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        items: [
          new BottomNavigationBarItem(
            activeIcon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/tripspassive.png",
              ),
            ),
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/tripsactive.png",
              ),
            ),
            label: '',
          ),
          new BottomNavigationBarItem(
            activeIcon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/rewardspassive.png",
              ),
            ),
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/rewardsactive.png",
              ),
            ),
            label: '',
          ),
          new BottomNavigationBarItem(
            activeIcon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/photospassive.png",
              ),
            ),
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/photosactive.png",
              ),
            ),
            label: '',
          ),
          new BottomNavigationBarItem(
            activeIcon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/reelinactive.png",
              ),
            ),
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/reelactive.png",
              ),
            ),
            label: '',
          ),
          new BottomNavigationBarItem(
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/moreactive.png",
              ),
            ),
            label: '',
          ),
        ],
      );
    },
  );
}

Widget getCouponBottomNavigationBar() {
  return OrientationBuilder(
    builder: (context, orientation) {
      orientation == Orientation.portrait ? portrait = true : portrait = false;
      return BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          onCouponTabTapped(index, orientation);
        },
        backgroundColor: AggressorColors.primaryColor,
        currentIndex: currentIndex > 4 ? 0 : currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        items: [
          new BottomNavigationBarItem(
            activeIcon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/tripspassive.png",
              ),
            ),
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/tripsactive.png",
              ),
            ),
            label: '',
          ),
          new BottomNavigationBarItem(
            activeIcon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/rewardspassive.png",
              ),
            ),
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/rewardsactive.png",
              ),
            ),
            label: '',
          ),
          new BottomNavigationBarItem(
            activeIcon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/photospassive.png",
              ),
            ),
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/photosactive.png",
              ),
            ),
            label: '',
          ),
          new BottomNavigationBarItem(
            activeIcon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/reelinactive.png",
              ),
            ),
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/reelactive.png",
              ),
            ),
            label: '',
          ),
          new BottomNavigationBarItem(
            icon: Container(
              width: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              height: orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape,
              child: Image.asset(
                "assets/moreactive.png",
              ),
            ),
            label: '',
          ),
        ],
      );
    },
  );
}

void onTabTapped(int index, Orientation orientation) {
  /*
    set the state of the navigation bar selection to index
     */

  if (index != 4) {
    if (homePage) {
      currentIndex = index;
      mainPageCallback();
      int popCount = 0;
      Navigator.popUntil(navigatorKey.currentContext, (route) {
        return popCount++ == popDistance;
      });
      popDistance = 0;
    }
  } else {
    //todo show the more options dialogue
    //add the following my files,my notes,  my profile, signout
    showMenu<String>(
      context: navigatorKey.currentContext,
      position: RelativeRect.fromLTRB(
          double.infinity,
          MediaQuery.of(navigatorKey.currentContext).size.height -
              (orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape) -
              AppBar().preferredSize.height,
          0,
          0),
      items: [
        PopupMenuItem<String>(child: const Text('• My files'), value: '1'),
        PopupMenuItem<String>(child: const Text('• My notes'), value: '2'),
        PopupMenuItem<String>(child: const Text('• My profile'), value: '3'),
        PopupMenuItem<String>(child: const Text('• Sign Out'), value: '4'),
      ],
      elevation: 8.0,
    ).then<void>((String itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        currentIndex = 5;
        mainPageCallback();
      } else if (itemSelected == "2") {
        currentIndex = 6;
        mainPageCallback();
      } else if (itemSelected == "3") {
        currentIndex = 4;
        mainPageCallback();
      } else {
        mainPageSignOutCallback();
      }
    });
  }
}

void onCouponTabTapped(int index, Orientation orientation) {
  /*
    set the state of the navigation bar selection to index
     */

  if (index != 4) {
    if (homePage) {
      currentIndex = index;
      mainPageCallback();
      int popCount = 0;
      Navigator.popUntil(navigatorKey.currentContext, (route) {
        return popCount++ == popDistance;
      });
      popDistance = 0;
    }
  } else {
    //todo show the more options dialogue
    //add the following my files,my notes,  my profile, signout
    showMenu<String>(
      context: navigatorKey.currentContext,
      position: RelativeRect.fromLTRB(
          double.infinity,
          MediaQuery.of(navigatorKey.currentContext).size.height -
              (orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape) -
              AppBar().preferredSize.height,
          0,
          0),
      items: [
        PopupMenuItem<String>(child: const Text('• My files'), value: '1'),
        PopupMenuItem<String>(child: const Text('• My notes'), value: '2'),
        PopupMenuItem<String>(child: const Text('• My profile'), value: '3'),
        PopupMenuItem<String>(child: const Text('• Sign Out'), value: '4'),
      ],
      elevation: 8.0,
    ).then<void>((String itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        currentIndex = 5;
        mainPageCallback();
      } else if (itemSelected == "2") {
        currentIndex = 6;
        mainPageCallback();
      } else if (itemSelected == "3") {
        currentIndex = 4;
        mainPageCallback();
      } else {
        mainPageSignOutCallback();
      }

      int popCount = 0;
      Navigator.popUntil(navigatorKey.currentContext, (route) {
        return popCount++ == popDistance;
      });
      popDistance = 0;
    });
  }
}

Widget getAppBar() {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    leading: outterDistanceFromLogin > 0
        ? IconButton(
            icon: Icon(Icons.arrow_back),
            color: AggressorColors.secondaryColor,
            onPressed: () {
              outterDistanceFromLogin = 0;
              navigatorKey.currentState.pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        : Container(),
    title: Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Image.asset(
        "assets/logo.png",
        height: AppBar().preferredSize.height,
        fit: BoxFit.fitHeight,
      ),
    ),
    actions: <Widget>[
      homePage
          ? SizedBox(
              height: AppBar().preferredSize.height,
              child: IconButton(
                icon: Container(
                  child: Image.asset("assets/callicon.png"),
                ),
                onPressed: makeCall,
              ),
            )
          : SizedBox(
              height: AppBar().preferredSize.height,
              child: IconButton(
                icon: Container(
                  child: Image.asset("assets/callicon.png"),
                ),
                onPressed: makeCall,
              ),
            ),
    ],
  );
}

makeCall() async {
  const url = 'tel:7069932531';
  try {
    await launch(url);
  } catch (e) {
    print(e.toString());
  }
}

void handlePopupClick(String value) async {
  switch (value) {
    case 'My Profile':
      currentIndex = 4;
      mainPageCallback();
      break;
    case 'Sign Out':
      mainPageSignOutCallback();
      break;
  }
  int popCount = 0;
  Navigator.popUntil(navigatorKey.currentContext, (route) {
    return popCount++ == popDistance;
  });
  popDistance = 0;
}

void handleCouponPopupClick(String value) async {
  switch (value) {
    case 'Home':
      currentIndex = 0;
      mainPageCallback();
      break;
    case 'My Profile':
      currentIndex = 4;
      mainPageCallback();
      break;
    case 'Sign Out':
      mainPageSignOutCallback();
      break;
  }
  int popCount = 0;
  Navigator.popUntil(navigatorKey.currentContext, (route) {
    return popCount++ == popDistance;
  });
  popDistance = 0;
}
