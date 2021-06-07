/*
holds global variables for the application
 */
library globals;

import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:flutter/cupertino.dart';
import 'gallery.dart';


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

double loadedCount = 0;
double loadingLength = 0;

bool photosLoaded = false;
bool notesLoaded = false;
bool certificateLoaded = false;
bool ironDiversLoaded = false;
bool contactLoaded = false;
bool profileDataLoaded = false;
bool online = true;

int currentIndex = 0;

Map<String, Gallery> galleriesMap = <String, Gallery>{};
Map<String, dynamic> profileData = <String, dynamic>{};

List<Trip> notLoadedList = [];
List<Trip> tripList = [];
List<Trip> loadSize = [];
List<dynamic> statesList = [];
List<dynamic> countriesList = [];
List<Map<String, dynamic>> boatList = [];
List<dynamic> sliderImageList = [];
List<dynamic> notesList = [];
List<dynamic> ironDiverList = [];
List<dynamic> certificationList = [];


Contact contact = null;

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
