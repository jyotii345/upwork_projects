/*
holds global variables for the application
 */
library globals;

import 'package:aggressor_adventures/classes/trip.dart';
import 'gallery.dart';



double loadedCount = 0;
double loadingLength = 0;

Map<String, Gallery> galleriesMap = <String, Gallery>{};
List<Trip> notLoadedList = [];
List<Trip> tripList = [];
List<Trip> loadSize = [];
List<Map<String, dynamic>> boatList = [];
List<dynamic> sliderImageList = [];
List<dynamic> notesList = [];

bool photosLoaded = false;
bool notesLoaded = false;

int currentIndex = 0;





