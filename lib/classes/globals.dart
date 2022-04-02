/*
holds global variables for the application
 */
library globals;

import 'dart:io';

import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/file_data.dart';
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
bool filesLoaded = false;
bool homePage = false;
bool backButton = false;
bool allStarLoaded = false;
int currentIndex = 0;
int outterDistanceFromLogin = 0;

bool showVideo = false;

bool userImageRetreived = false;

Map<String, Gallery> galleriesMap = <String, Gallery>{};
Map<String, dynamic> profileData = <String, dynamic>{};
Map<String, String> fileDisplayNames = <String, String>{};

List<Trip> notLoadedList = [];
List<Trip> tripList = [];
List<Trip> loadSize = [];
List<Map<String, dynamic>> boatList = [];
List<FileData> fileDataList = [];
List<dynamic> statesList = [];
List<dynamic> countriesList = [];
List<dynamic> sliderImageList = [];
List<dynamic> notesList = [];
List<dynamic> ironDiverList = [];
List<dynamic> certificationList = [];
List<dynamic> allStarsList = [];

File userImage = File("");

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
