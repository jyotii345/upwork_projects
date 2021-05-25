// ignore: library_names
library globals;

import 'package:aggressor_adventures/classes/trip.dart';

import 'boat.dart';
import 'gallery.dart';



double loadedCount = 0;
double loadingLength = 0;

Map<String, Gallery> galleriesMap = <String, Gallery>{};
List<Trip> notLoadedList = [];
List<Trip> tripList = [];
List<Trip> loadSize = [];
List<Map<String, dynamic>> boatList = [];

bool photosLoaded = false;

int currentIndex = 0;





