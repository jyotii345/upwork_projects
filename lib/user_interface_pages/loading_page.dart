import 'dart:io';
import 'dart:typed_data';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/gallery.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/note.dart';
import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/databases/files_database.dart';
import 'package:aggressor_adventures/databases/notes_database.dart';
import 'package:aggressor_adventures/databases/offline_database.dart';
import 'package:aggressor_adventures/databases/photo_database.dart';
import 'package:aggressor_adventures/databases/profile_database.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/boat_database.dart';
import 'package:aggressor_adventures/databases/certificate_database.dart';
import 'package:aggressor_adventures/databases/contact_database.dart';
import 'package:aggressor_adventures/databases/countries_database.dart';
import 'package:aggressor_adventures/databases/iron_diver_database.dart';
import 'package:aggressor_adventures/databases/slider_database.dart';
import 'package:aggressor_adventures/databases/states_database.dart';
import 'package:aggressor_adventures/databases/trip_database.dart';
import 'package:aggressor_adventures/user_interface_pages/main_page.dart';
import 'package:aggressor_adventures/user_interface_pages/profile_link_page.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage(this.user);

  final User user;

  @override
  State<StatefulWidget> createState() => new LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  /*
  instance vars
   */

  double percent = 0.0;
  String loadingMessage = "Loading, please wait";

  /*
  initState

  Build
   */

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        portrait = orientation == Orientation.portrait;
        return new Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: getAppBar(),
          body: Stack(
            children: <Widget>[
              Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CircularPercentIndicator(
                      radius: portrait
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.height / 3,
                      percent: percent > 1 ? 1 : percent,
                      animateFromLastPercent: true,
                      backgroundColor: AggressorColors.secondaryColor,
                      progressColor: AggressorColors.primaryColor,
                    ),
                    percent > 1
                        ? Text(
                            loadingMessage + ": 100%",
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            loadingMessage + ": " +
                                int.parse((percent * 100).round().toString())
                                    .toString() +
                                "%",
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: getBottomNavigationBar(),
        );
      },
    );
  }

/*
  self implemented
   */

  void loadData() async {
    //determines if the device is online or offline and loads data from the appropriate place.
    setState(() {
      Wakelock.enable();
    });

    online = await DataConnectionChecker().hasConnection;
    if (online == true) {
      await updateOffline();
      await getOnlineLoad();
    } else {
      await getOfflineLoad();
    }

    setState(() {

      photosLoaded = false;
      notesLoaded = false;
      certificateLoaded = false;
      ironDiversLoaded = false;
      contactLoaded = false;
      profileDataLoaded = false;
      filesLoaded = false;
      homePage = false;

      currentIndex = 0;

      certificationOptionList = [
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
      Wakelock.disable();
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  user: widget.user,
                )));
  }

  Future<dynamic> getOfflineLoad() async {
    //load data from the device if the application is offline

    var tempTripList = await TripDatabaseHelper.instance.queryTrip();
    setState(() {
      tripList = tempTripList;
      loadedCount++;
    });

    setState(() {
      loadingLength = tripList.length + 12.toDouble();
    });

    var tempSliderImageList =
        await SlidersDatabaseHelper.instance.querySliders();
    setState(() {
      loadedCount++;
    });
    var contactList = await ContactDatabaseHelper.instance.queryContact();
    setState(() {
      loadedCount++;
    });
    var contactResponse = contactList[0];
    setState(() {
      loadedCount++;
    });
    var tempBoatList = await BoatDatabaseHelper.instance.queryBoat();
    setState(() {
      loadedCount++;
    });
    var tempIronDiverList =
        await IronDiverDatabaseHelper.instance.queryIronDiver();
    setState(() {
      loadedCount++;
    });
    var tempCertificationList =
        await CertificateDatabaseHelper.instance.queryCertificate();
    setState(() {
      loadedCount++;
    });
    var tempCountriesList =
        await CountriesDatabaseHelper.instance.queryCountries();
    setState(() {
      loadedCount++;
    });
    var tempStatesList = await StatesDatabaseHelper.instance.queryStates();
    setState(() {
      loadedCount++;
    });
    var tempProfileData = await ProfileDatabaseHelper.instance.queryProfile();
    getUserProfileImageData(tempProfileData);
    setState(() {
      loadedCount++;
    });

    var tempNotesList = await NotesDatabaseHelper.instance.queryNotes();
    setState(() {
      loadedCount++;
    });

    for (var trip in tripList) {
      trip.user = widget.user;
      await trip.initCharterInformation();
      setState(() {
        loadedCount++;
        percent += (loadedCount / (loadingLength));
      });
    }

    var photosList = await PhotoDatabaseHelper.instance.queryPhoto();
    var tempGalleriesMap = await getGalleries(photosList);

    setState(() {
      loadedCount++;
    });

    setState(() {
      sliderImageList = tempSliderImageList;
      contact = Contact(
          contactResponse["contactId"].toString(),
          contactResponse["firstName"],
          contactResponse["middleName"],
          contactResponse["lastName"],
          contactResponse["email"],
          contactResponse["vipCount"].toString(),
          contactResponse["vipPlusCount"].toString(),
          contactResponse["sevenSeasCount"].toString(),
          contactResponse["aaCount"].toString(),
          contactResponse["boutiquePoints"].toString(),
          contactResponse["vip"],
          contactResponse["vipPlus"],
          contactResponse["sevenSeas"],
          contactResponse["adventuresClub"],
          contactResponse["memberSince"].toString());
      tempBoatList.forEach((element) {
        boatList.add(element.toMap());
      });
      Map<String, dynamic> selectionTrip = {
        "boatid": -1,
        "name": " -- SELECT -- ",
        "abbreviation": "SEL"
      };
      boatList.insert(0, selectionTrip);
      ironDiverList = tempIronDiverList;
      certificationList = tempCertificationList;
      countriesList = tempCountriesList;
      statesList = tempStatesList;
      profileData = tempProfileData[0];
      notesList = tempNotesList;
      galleriesMap = tempGalleriesMap;
    });

    if (tripList == null) {
      tripList = [];
    }


    return "done";
  }

  Future<dynamic> getOnlineLoad() async {
    //load data from the internet if the application is online
    try {
      sliderImageList = await SlidersDatabaseHelper.instance.querySliders();
    } catch (e) {
      print("no sliders");
    }

    getContactDetails();
    getBoatList();
    getIronDiverList();
    getCountriesList();
    getStatesList();
    getCertificationList();
    loadProfileDetails();

    setState(() {
      loadingMessage = "Loading images";
    });
    await updateSliderImages();
    setState(() {
      loadingMessage = "Loading profile Data";
    });
    var profileLinkResponse =
        await AggressorApi().checkProfileLink(widget.user.userId);

    if (profileLinkResponse["status"] != "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfileLinkPage(widget.user, profileLinkResponse["messsage"]),
        ),
      );
    }

    setState(() {
      loadingMessage = "Loading your adventure information";
    });
    var tempList = await AggressorApi()
        .getReservationList(widget.user.contactId, loadingCallBack);
    setState(() {
      tripList = tempList;
      loadingMessage = "Initializing your adventures";
    });

    if (tripList == null) {
      tripList = [];
    }

    for (var trip in tripList) {
      trip.user = widget.user;
      await trip.initCharterInformation();
      setState(() {
        loadedCount++;
        percent += (loadedCount / (loadingLength * 2));
      });
    }

    setState(() {
      loadingMessage = "loading your files";
    });

    var tempFiles = await FileDatabaseHelper.instance.queryFile();
    var tempPhotos = await PhotoDatabaseHelper.instance.queryPhoto();
    var tempGalleryMap = await getGalleries(tempPhotos);

    setState(() {
      loadingMessage = "Almost there!";
    });

    print(tempFiles.toList());
    print(tempGalleryMap);


    setState(() {
      fileDataList = tempFiles;
      galleriesMap = tempGalleryMap;
    });

    fileDataList.forEach((element) {
      element.setUser(widget.user);
      element.setCallback(() {
        setState(() {
          filesLoaded = false;
        });
      });
    });
    return "done";
  }

  Future<dynamic> updateSliderImages() async {
    SlidersDatabaseHelper slidersDatabaseHelper =
        SlidersDatabaseHelper.instance;
    List<String> fileNames = await AggressorApi().getRewardsSliderList();
    for (String file in fileNames) {
      var fileResponse = await AggressorApi()
          .getRewardsSliderImage(file.substring(file.indexOf("/") + 1));
      Uint8List bytes = await readByteStream(fileResponse.stream);

      String fileName = file.substring(7);
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
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
      setState(() {
        percent += .05;
      });
    }
    return "done";
  }

  VoidCallback loadingCallBack() {
    setState(() {
      loadedCount++;
      percent += ((loadedCount / (loadingLength * 2)));
    });
  }

  void getContactDetails() async {
    //initialize the contact details needed for the page
    var response = await AggressorApi().getContact(widget.user.contactId);
    setState(() {
      contact = Contact(
          response["contactid"],
          response["first_name"],
          response["middle_name"],
          response["last_name"],
          response["email"],
          response["vipcount"],
          response["vippluscount"],
          response["sevenseascount"],
          response["aacount"],
          response["boutique_points"],
          response["vip"],
          response["vipPlus"],
          response["sevenSeas"],
          response["adventuresClub"],
          response["memberSince"]);
    });
    updateContactCache(response);
  }

  void getBoatList() async {
    //set the initial boat list
    boatList = await AggressorApi().getBoatList();
  }

  void getIronDiverList() async {
    //set the initial iron diver awards
    ironDiverList = await AggressorApi().getIronDiverList(widget.user.userId);
    updateIronDiversCache();
  }

  void getCountriesList() async {
    //set the initial countries list
    countriesList = await AggressorApi().getCountries();
    updateCountryCache();
  }

  void getStatesList() async {
    //set the initial states list
    statesList = await AggressorApi().getStates();
    updateStatesCache();
  }

  void getCertificationList() async {
    //set the initial certification lists
    certificationList =
        await AggressorApi().getCertificationList(widget.user.userId);
    updateCertificationCache();
  }

  void updateContactCache(var response) async {
    //cleans and saves the contacts to the database
    ContactDatabaseHelper contactDatabaseHelper =
        ContactDatabaseHelper.instance;
    try {
      await contactDatabaseHelper.deleteContactTable();
    } catch (e) {
      print("no notes in the table");
    }

    await contactDatabaseHelper.insertContact(
        response["contactid"],
        response["first_name"],
        response["middle_name"],
        response["last_name"],
        response["email"],
        response["vipcount"],
        response["vippluscount"],
        response["sevenseascount"],
        response["aacount"],
        response["boutique_points"],
        response["vip"],
        response["vipPlus"],
        response["sevenSeas"],
        response["adventuresClub"],
        response["memberSince"]);
  }

  void updateCertificationCache() async {
    //cleans and saves the certifications to the database
    CertificateDatabaseHelper certificateDatabaseHelper =
        CertificateDatabaseHelper.instance;
    try {
      await certificateDatabaseHelper.deleteCertificateTable();
    } catch (e) {
      print("no notes in the table");
    }

    for (var certification in certificationList) {
      await certificateDatabaseHelper.insertCertificate(
          certification['id'].toString(), certification['certification']);
    }
  }

  void updateIronDiversCache() async {
    //cleans and saves the iron divers to the database
    IronDiverDatabaseHelper ironDiverDatabaseHelper =
        IronDiverDatabaseHelper.instance;
    try {
      await ironDiverDatabaseHelper.deleteIronDiverTable();
    } catch (e) {
      print("no notes in the table");
    }

    for (var ironDiver in ironDiverList) {
      await ironDiverDatabaseHelper.insertIronDiver(
          ironDiver['id'].toString(), ironDiver['name']);
    }
  }

  void updateCountryCache() async {
    //cleans and saves the countries to the database
    CountriesDatabaseHelper countriesDatabaseHelper =
        CountriesDatabaseHelper.instance;
    try {
      await countriesDatabaseHelper.deleteCountriesTable();
    } catch (e) {
      print("no notes in the table");
    }

    for (var country in countriesList) {
      await countriesDatabaseHelper.insertCountries(country);
    }
  }

  void updateStatesCache() async {
    //cleans and saves the states to the database
    StatesDatabaseHelper statesDatabaseHelper = StatesDatabaseHelper.instance;
    try {
      await statesDatabaseHelper.deleteStatesTable();
    } catch (e) {
      print("no notes in the table");
    }

    for (var state in statesList) {
      await statesDatabaseHelper.insertStates(state);
    }
  }

  void updateProfileDetailsCache(var response) async {
    //cleans and saves the profile to the database
    ProfileDatabaseHelper profileDatabaseHelper =
        ProfileDatabaseHelper.instance;
    try {
      await profileDatabaseHelper.deleteProfileTable();
    } catch (e) {
      print("no notes in the table");
    }

    await profileDatabaseHelper.insertProfile(
      response['userId'],
      response['first'],
      response['last'],
      response['email'],
      response['address1'],
      response['address2'],
      response['address2'],
      response['state'],
      response['province'],
      response['country'].toString(),
      response['zip'],
      response['username'],
      response['password'],
      response['homePhone'],
      response['workPhone'],
      response['mobilePhone'],
    );
  }

  void loadProfileDetails() async {
    //loads the initial value of the users profile data
    if (!profileDataLoaded) {
      var jsonResponse =
          await AggressorApi().getProfileData(widget.user.userId);
      if (jsonResponse["status"] == "success") {
        setState(() {
          profileData = jsonResponse;
          print("online user image");
          getUserProfileImageData(profileData);
          profileDataLoaded = true;
        });
      }

      updateProfileDetailsCache(jsonResponse);
    }

  }

  Future<dynamic> getGalleries(List<Photo> photos) async {
    //downloads images from aws. If the image is not already in storage, it will be stored on the device. Images are then added to a map based on their charterId that is used to display the images of the gallery.

    Map<String, Gallery> tempGalleries = <String, Gallery>{};
    photos.forEach((element) {
      int tripIndex = 0;
      for (int i = 0; i < tripList.length - 1; i++) {
        if (tripList[i].boat.boatId == element.boatId &&
            formatDate(DateTime.parse(tripList[i].charter.startDate),
                    [yyyy, '-', mm, '-', dd]) ==
                element.date) {
          tripIndex = i;
        }
      }

      if (!tempGalleries.containsKey(tripList[tripIndex].reservationId)) {
        tempGalleries[tripList[tripIndex].reservationId] = Gallery(
            widget.user, element.boatId, <Photo>[], tripList[tripIndex]);
      } else {
          tempGalleries[tripList[tripIndex].reservationId].addPhoto(element);
      }
    });
    return tempGalleries;
  }

  Future<dynamic> updateOffline() async {
    try {
      List<Map<String, dynamic>> offlineList =
          await OfflineDatabaseHelper.instance.queryOffline();
      for (var offlineItem in offlineList) {
        if (offlineItem["type"] == "note") {
          if (offlineItem["action"] == "add") {
            Note uploadNote =
                await NotesDatabaseHelper.instance.getNotes(offlineItem["id"]);
            var response = await AggressorApi().saveNote(
                uploadNote.startDate,
                uploadNote.endDate,
                uploadNote.preTripNotes,
                uploadNote.postTripNotes,
                uploadNote.miscNotes,
                uploadNote.boatId,
                widget.user.userId);
            if (response["status"] == "success") {
              NotesDatabaseHelper.instance.deleteNotes(offlineItem["id"]);
              OfflineDatabaseHelper.instance.deleteOffline(offlineItem["id"]);
            }
          } else if (offlineItem["action"] == "delete") {
            var response = await AggressorApi()
                .deleteNote(widget.user.userId, offlineItem["id"]);
            if (response["status"] == "success") {
              NotesDatabaseHelper.instance.deleteNotes(offlineItem["id"]);
              OfflineDatabaseHelper.instance.deleteOffline(offlineItem["id"]);
            }
          } else {
            Note uploadNote =
                await NotesDatabaseHelper.instance.getNotes(offlineItem["id"]);
            var response = await AggressorApi().updateNote(
                uploadNote.startDate,
                uploadNote.endDate,
                uploadNote.preTripNotes,
                uploadNote.postTripNotes,
                uploadNote.miscNotes,
                uploadNote.boatId,
                widget.user.userId,
                uploadNote.id);
            if (response["status"] == "success") {
              NotesDatabaseHelper.instance.deleteNotes(offlineItem["id"]);
              OfflineDatabaseHelper.instance.deleteOffline(offlineItem["id"]);
            }
          }
        } else if (offlineItem['type'] == 'image') {
          if (offlineItem['action'] == 'add') {
            Photo photo =
                await PhotoDatabaseHelper.instance.getPhoto(offlineItem['id']);
            var response = await AggressorApi().uploadAwsFile(
                widget.user.userId,
                "gallery",
                photo.boatId,
                photo.imagePath,
                photo.date);
            if (response["status"] == "success") {
              OfflineDatabaseHelper.instance.deleteOffline(offlineItem["id"]);
              PhotoDatabaseHelper.instance.deletePhoto(photo.imagePath);
            }
          } else if (offlineItem['action'] == 'delete') {
            Photo photo =
                await PhotoDatabaseHelper.instance.getPhoto(offlineItem['id']);
            var res = await AggressorApi().deleteAwsFile(
                widget.user.userId.toString(),
                "gallery",
                photo.boatId.toString(),
                photo.date,
                photo.imagePath
                    .substring(photo.imagePath.lastIndexOf("/"))
                    .toString());
            if (res["status"] == "success") {
              await OfflineDatabaseHelper.instance
                  .deleteOffline(offlineItem["id"]);
              await PhotoDatabaseHelper.instance.deletePhoto(photo.imagePath);
            }
          }
        }
      }
    } catch (e) {
      print("no offline additions");
    }
  }

  Future<dynamic> getUserProfileImageData(var profileDataLocal) async {
    if (!userImageRetreived) {
      try {
        var userImageRes = await AggressorApi()
            .downloadUserImage(widget.user.userId, profileData["avatar"]);

        var bytes = await readByteStream(userImageRes.stream);
        var dirData = (await getApplicationDocumentsDirectory()).path;
        File temp = File(dirData + "/" + profileData["avatar"]);
        await temp.writeAsBytes(bytes);

        setState(() {
          userImageRetreived = true;
          userImage = temp;
        });
      } catch (e) {
        var dirData = (await getApplicationDocumentsDirectory()).path;

          userImage = File(dirData.toString() + "/" + profileDataLocal["avatar"].toString());

      }
    } else {
      var dirData = (await getApplicationDocumentsDirectory()).path;
        userImage = File(dirData + "/" + profileDataLocal["avatar"]);

    }
  }
}
