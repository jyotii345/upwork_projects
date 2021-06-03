/*
holds global variables for the application
 */
library globals;

import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'gallery.dart';

double loadedCount = 0;
double loadingLength = 0;

bool photosLoaded = false;
bool notesLoaded = false;

int currentIndex = 0;

Map<String, Gallery> galleriesMap = <String, Gallery>{};

List<Trip> notLoadedList = [];
List<Trip> tripList = [];
List<Trip> loadSize = [];
List<Map<String, dynamic>> boatList = [];
List<dynamic> sliderImageList = [];
List<dynamic> notesList = [];
List<dynamic> ironDiverList = [];
List<dynamic> certificationList = [];


Contact contact;

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
