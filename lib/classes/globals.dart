// ignore: library_names
library globals;

import 'package:aggressor_adventures/classes/trip.dart';

import 'gallery.dart';



double loadedCount = 0;

Map<String, Gallery> galleriesMap = <String, Gallery>{};
List<Trip> notLoadedList = [];
List<Trip> tripList = [];
List<Trip> loadSize = [];

bool photosLoaded = false;

int currentIndex = 0;





