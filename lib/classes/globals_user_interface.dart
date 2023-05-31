library user_interface;

import 'dart:io';
import 'dart:typed_data';

import 'package:aggressor_adventures/user_interface_pages/contact_us_page.dart';
import 'package:aggressor_adventures/user_interface_pages/login_page.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../databases/slider_database.dart';
import 'aggressor_api.dart';
import 'aggressor_colors.dart';
import 'globals.dart';

double iconSizePortrait =
    MediaQuery.of(navigatorKey.currentContext!).size.width / 10;
double iconSizeLandscape =
    MediaQuery.of(navigatorKey.currentContext!).size.height / 10;
double iconImageSize =
    MediaQuery.of(navigatorKey.currentContext!).size.width / 15;

int popDistance = 0;
bool portrait = true;

Color inputTextColor = Color(0xff666666);
Color inputBorderColor = Color(0xff707070);

VoidCallback? mainPageCallback;

VoidCallback? mainPageSignOutCallback;

xyz(int x) async {
  print(x);

  // if(x==1){
  //   await updateSliderImages();
  //
  //
  // }
}

Future<dynamic> updateSliderImages() async {
  SlidersDatabaseHelper slidersDatabaseHelper = SlidersDatabaseHelper.instance;
  List<String> fileNames = await AggressorApi().getRewardsSliderList();
  for (String file in fileNames) {
    var fileResponse = await AggressorApi()
        .getRewardsSliderImage(file.substring(file.indexOf("/") + 1));
    Uint8List bytes = await readByteStream(fileResponse.stream);

    String fileName = file.substring(7);
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/$fileName';
    File tempFile = await File(filePath).writeAsBytes(bytes);

    // try {
    //   await slidersDatabaseHelper.deleteSliders(fileName);
    // } catch (e) {
    //   print("no such file");
    // }

    await slidersDatabaseHelper
        .insertSliders({'fileName': fileName, 'filePath': tempFile.path});
    sliderImageList.add({'filePath': tempFile.path, 'fileName': fileName});
    // setState(() {
    //   percent += .01;
    // });
  }
  return "done";
}

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

          xyz(index);
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

Future<void> sendMail() async {
  if (Platform.isAndroid) {
    launchUrl(Uri.parse("mailto:info@aggressor.com"));
  } else {
    var result = await OpenMailApp.openMailApp();

    if (!result.didOpen && !result.canOpen) {
      launchUrl(Uri.parse("mailto:info@aggressor.com"));
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (_) {
          return MailAppPickerDialog(
            mailApps: result.options,
            emailContent: EmailContent(to: ["info@aggressor.com"]),
          );
        },
      );
    }
  }
}

void onTabTapped(int index, Orientation? orientation) {
  /*
    set the state of the navigation bar selection to index
     */

  if (index != 4) {
    // if (false) {

    if (homePage) {
      currentIndex = index;
      mainPageCallback!();
      int popCount = 0;
      Navigator.popUntil(navigatorKey.currentContext!, (route) {
        return popCount++ == popDistance;
      });
      popDistance = 0;
    }
  } else {
    //todo show the more options dialogue
    //add the following my files,my notes,  my profile, signout
    showMenu<String>(
      context: navigatorKey.currentContext!,
      position: RelativeRect.fromLTRB(
          double.infinity,
          MediaQuery.of(navigatorKey.currentContext!).size.height -
              (orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape) -
              AppBar().preferredSize.height,
          0,
          0),
      items: [
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Image.asset(
                    "assets/icons/contact.png",
                    height: 17,
                    width: 17,
                  ),
                ),
                const Text('Contact us'),
              ],
            ),
            value: '0'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Image.asset(
                    "assets/icons/folder.png",
                    height: 17,
                    width: 17,
                  ),
                ),
                const Text('My files'),
              ],
            ),
            value: '1'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Image.asset(
                    "assets/icons/pencil.png",
                    height: 17,
                    width: 17,
                  ),
                ),
                const Text('My notes'),
              ],
            ),
            value: '2'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Image.asset(
                    "assets/icons/user.png",
                    height: 17,
                    width: 17,
                  ),
                ),
                const Text('My profile'),
              ],
            ),
            value: '3'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Icon(
                    Icons.notifications_none_outlined,
                    size: 18,
                  ), //Image.asset("assets/icons/user.png",height: 17,width: 17,),
                ),
                const Text('Inbox'),
              ],
            ),
            value: '4'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Image.asset(
                    "assets/icons/signOut.png",
                    height: 17,
                    width: 17,
                  ),
                ),
                const Text('Sign Out'),
              ],
            ),
            value: '5'),
      ],
      elevation: 8.0,
    ).then<void>((String? itemSelected) async {
      if (itemSelected == null) return;

      if (itemSelected == "0") {
        Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>ContactUsPage()));
        // mainPageCallback!();
      } else if (itemSelected == "1") {
        currentIndex = 5;
        mainPageCallback!();
      } else if (itemSelected == "2") {
        currentIndex = 6;
        mainPageCallback!();
      } else if (itemSelected == "3") {
        currentIndex = 4;
        mainPageCallback!();
      } else if (itemSelected == "4") {
        currentIndex = 7;
        mainPageCallback!();
      } else {
        mainPageSignOutCallback!();
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
      mainPageCallback!();
      int popCount = 0;
      Navigator.popUntil(navigatorKey.currentContext!, (route) {
        return popCount++ == popDistance;
      });
      popDistance = 0;
    }
  } else {
    //todo show the more options dialogue
    //add the following my files,my notes,  my profile, signout
    showMenu<String>(
      context: navigatorKey.currentContext!,
      position: RelativeRect.fromLTRB(
          double.infinity,
          MediaQuery.of(navigatorKey.currentContext!).size.height -
              (orientation == Orientation.portrait
                  ? iconSizePortrait
                  : iconSizeLandscape) -
              AppBar().preferredSize.height,
          0,
          0),
      items: [
        // PopupMenuItem<String>(child: const Text('• Contact us'), value: '0'),
        // PopupMenuItem<String>(child: const Text('• My files'), value: '1'),
        // PopupMenuItem<String>(child: const Text('• My notes'), value: '2'),
        // PopupMenuItem<String>(child: const Text('• My profile'), value: '3'),
        // PopupMenuItem<String>(child: const Text('• Sign Out'), value: '4'),

        PopupMenuItem<String>(
            child: InkWell(
              onTap: (){
                Navigator.pop(navigatorKey.currentContext!);
                Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>ContactUsPage()));
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: Image.asset(
                      "assets/icons/contact.png",
                      height: 17,
                      width: 17,
                    ),
                  ),
                  const Text('Contact us'),
                ],
              ),
            ),
            value: '0'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Image.asset(
                    "assets/icons/folder.png",
                    height: 17,
                    width: 17,
                  ),
                ),
                const Text('My files'),
              ],
            ),
            value: '1'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Image.asset(
                    "assets/icons/pencil.png",
                    height: 17,
                    width: 17,
                  ),
                ),
                const Text('My notes'),
              ],
            ),
            value: '2'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Image.asset(
                    "assets/icons/user.png",
                    height: 17,
                    width: 17,
                  ),
                ),
                const Text('My profile'),
              ],
            ),
            value: '3'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Icon(
                    Icons.notifications_none_outlined,
                    size: 18,
                  ), //Image.asset("assets/icons/user.png",height: 17,width: 17,),
                ),
                const Text('Inbox'),
              ],
            ),
            value: '4'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Image.asset(
                    "assets/icons/signOut.png",
                    height: 17,
                    width: 17,
                  ),
                ),
                const Text('Sign Out'),
              ],
            ),
            value: '5'),
      ],
      elevation: 8.0,
    ).then<void>((String? itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "0") {

        // Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>ContactUsPage()));

      } else if (itemSelected == "1") {
        currentIndex = 5;
        mainPageCallback!();
      } else if (itemSelected == "2") {
        currentIndex = 6;
        mainPageCallback!();
      } else if (itemSelected == "3") {
        currentIndex = 4;
        mainPageCallback!();
      } else if (itemSelected == "4") {
        currentIndex = 7;
        mainPageCallback!();
      } else {
        mainPageSignOutCallback!();
      }

      int popCount = 0;
      Navigator.popUntil(navigatorKey.currentContext!, (route) {
        return popCount++ == popDistance;
      });
      popDistance = 0;
    });
  }
}

AppBar getAppBar() {
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
              outterDistanceFromLogin=0;
              navigatorKey.currentState!.pop();
              // navigatorKey.currentState!.pushReplacement(
              //     MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        : SizedBox(),
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
  final url = 'tel:7069932531';
  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print(e.toString());
  }
}

void handlePopupClick(String value) async {
  switch (value) {
    case 'My Profile':
      currentIndex = 4;
      mainPageCallback!();
      break;
    case 'Sign Out':
      mainPageSignOutCallback!();
      break;
  }
  int popCount = 0;
  Navigator.popUntil(navigatorKey.currentContext!, (route) {
    return popCount++ == popDistance;
  });
  popDistance = 0;
}

void handleCouponPopupClick(String value) async {
  switch (value) {
    case 'Home':
      currentIndex = 0;
      mainPageCallback!();
      break;
    case 'My Profile':
      currentIndex = 4;
      mainPageCallback!();
      break;
    case 'Sign Out':
      mainPageSignOutCallback!();
      break;
  }
  int popCount = 0;
  Navigator.popUntil(navigatorKey.currentContext!, (route) {
    return popCount++ == popDistance;
  });
  popDistance = 0;
}
