library user_interface;

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
import 'package:aggressor_adventures/user_interface_pages/login_page.dart';
import 'package:aggressor_adventures/user_interface_pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aggressor_colors.dart';
import 'gallery.dart';
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
          onTabTapped(index);
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
                "assets/notespassive.png",
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
                "assets/notesactive.png",
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
                "assets/filespassive.png",
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
                "assets/filesactive.png",
              ),
            ),
            label: '',
          ),
        ],
      );
    },
  );
}

void onTabTapped(
  int index,
) {
  /*
    set the state of the navigation bar selection to index
     */

  if (homePage) {
    currentIndex = index;
    mainPageCallback();
    int popCount = 0;
    Navigator.popUntil(navigatorKey.currentContext, (route) {
      return popCount++ == popDistance;
    });
    popDistance = 0;
  }
}

Widget getAppBar() {
  return AppBar(
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

void handlePopupClick(String value) {
  switch (value) {
    case 'My Profile':
      currentIndex = 5;
      mainPageCallback();
      break;
    case 'Sign Out':
      signOutUser();
      mainPageCallback();
      break;
  }
  int popCount = 0;
  Navigator.popUntil(navigatorKey.currentContext, (route) {
    return popCount++ == popDistance;
  });
  popDistance = 0;
}

void signOutUser() async {
  //sings user out and clears databases

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
}
