/*
holds global variables for the application
 */
library globals;

import 'dart:io';

import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/file_data.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../model/basicInfoModel.dart';
import '../model/countries.dart';
import '../model/userModel.dart';
import 'charter.dart';
import 'gallery.dart';
import 'user.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

double loadedCount = 0;
double loadingLength = 0;
double percent = 0.0;
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
UserModel userModel = UserModel();
BasicInfoModel basicInfoModel = BasicInfoModel();
Countries countries = Countries();
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
DateFormat defaultDateFormat = DateFormat.yMMMMd();
DateFormat defaultDateFormatForBackend = DateFormat('yyyy-MM-dd');

File userImage = File("");

Contact? contact;

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

const List<String> timeZones = [
  'Africa/Abidjan',
  'Africa/Algiers',
  'Africa/Cairo',
  'America/Adak',
  'America/Araguaina',
  'America/Cancun',
  'America/Cuiaba',
  'America/Danmarkshavn',
  'America/Los_Angeles',
  'America/Maceio',
  'America/New_York',
  'America/Noronha',
  'America/Phoenix',
  'America/Regina',
  'America/Santiago',
  'America/Scoresbysund',
  'America/Sitka',
  'America/St_Johns',
  'Antarctica/Casey',
  'Antarctica/Davis',
  'Antarctica/Macquarie',
  'Antarctica/Mawson',
  'Antarctica/McMurdo',
  'Antarctica/Palmer',
  'Antarctica/Troll',
  'Asia/Bangkok',
  'Asia/Dhaka',
  'Asia/Dubai',
  'Asia/Gaza',
  'Asia/Hong_Kong',
  'Asia/Jerusalem',
  'Asia/Kabul',
  'Asia/Kamchatka',
  'Asia/Karachi',
  'Asia/Kathmandu',
  'Asia/Kolkata',
  'Asia/Qatar',
  'Asia/Srednekolymsk',
  'Asia/Tehran',
  'Asia/Tokyo',
  'Asia/Vladivostok',
  'Asia/Yangon',
  'Atlantic/Azores',
  'Atlantic/Bermuda',
  'Atlantic/Canary',
  'Atlantic/South_Georgia',
  'Atlantic/Stanley',
  'Australia/Darwin',
  'Australia/Eucla',
  'Australia/Lord_Howe',
  'Australia/Perth',
  'Australia/Sydney',
  'Europe/Istanbul',
  'Europe/London',
  'Europe/Madrid',
  'Europe/Moscow',
  'Europe/Paris',
  'Europe/Rome',
  'Europe/Samara',
  'Europe/Sofia',
  'Indian/Chagos',
  'Indian/Maldives',
  'Indian/Mauritius',
  'Pacific/Auckland',
  'Pacific/Bougainville',
  'Pacific/Chatham',
  'Pacific/Easter',
  'Pacific/Gambier',
  'Pacific/Kanton',
  'Pacific/Kiritimati',
  'Pacific/Marquesas',
  'Pacific/Pago_Pago',
  'Pacific/Palau',
  'Pacific/Pitcairn',
  'Pacific/Port_Moresby',
  'Pacific/Tahiti',
];
