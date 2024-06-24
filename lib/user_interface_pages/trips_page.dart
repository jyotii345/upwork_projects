import 'dart:io';
import 'dart:typed_data';

import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../classes/aggressor_api.dart';
import '../databases/boat_database.dart';
import '../databases/certificate_database.dart';
import '../databases/contact_database.dart';
import '../databases/countries_database.dart';
import '../databases/iron_diver_database.dart';
import '../databases/notes_database.dart';
import '../databases/photo_database.dart';
import '../databases/profile_database.dart';
import '../databases/slider_database.dart';
import '../databases/states_database.dart';
import '../databases/trip_database.dart';
import '../databases/user_database.dart';

class MyTrips extends StatefulWidget {
  MyTrips({this.user});

  final User? user;

  @override
  State<StatefulWidget> createState() => new MyTripsState();
}

class MyTripsState extends State<MyTrips>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  /*
  instance vars
   */
  List<Widget> pastTripsList = [];
  List<Widget> upcomingTripsList = [];

  bool timerStarted = false;
  int sliderIndex = 0;

  bool loading = true;
  UserDatabaseHelper helper = UserDatabaseHelper.instance;
  User? currentUser;
// coordinates for a center location

  /*
  initState
   */
  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  getInitialData() async {
    pastTripsList = [];
    upcomingTripsList = [];
    await getCurrentUser();
    await updateSliderImagesList();
  }

  getCurrentUser() async {
    var userList = await helper.queryUser();
    currentUser = userList[0];
  }

  Future<dynamic> getOfflineLoad() async {
    //load data from the device if the application is offline

    var tempTripList = await TripDatabaseHelper.instance.queryTrip();
    setState(() {
      tripList = tempTripList;
      loadedCount++;
    });

    setState(() {
      loadingLength = (tripList.length + 12.toDouble()) * 2;
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
    // var contactResponse = contactList[0];
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
    // getUserProfileImageData(tempProfileData);
    setState(() {
      loadedCount++;
    });

    var tempNotesList = await NotesDatabaseHelper.instance.queryNotes();
    setState(() {
      loadedCount++;
    });

    for (var trip in tripList) {
      trip.user = currentUser;
      await trip.initCharterInformation();
      setState(() {
        loadedCount++;
        percent += (loadedCount / (loadingLength));
      });
    }

    var photosList = await PhotoDatabaseHelper.instance.queryPhoto();
    // var tempGalleriesMap = await getGalleries(photosList);

    setState(() {
      loadedCount++;
    });

    setState(() {
      sliderImageList = tempSliderImageList;
      // contact = Contact(
      //     contactResponse["contactId"].toString(),
      //     contactResponse["firstName"],
      //     contactResponse["middleName"],
      //     contactResponse["lastName"],
      //     contactResponse["email"],
      //     contactResponse["vipCount"].toString(),
      //     contactResponse["vipPlusCount"].toString(),
      //     contactResponse["sevenSeasCount"].toString(),
      //     contactResponse["aaCount"].toString(),
      //     contactResponse["boutiquePoints"].toString(),
      //     contactResponse["vip"],
      //     contactResponse["vipPlus"],
      //     contactResponse["sevenSeas"],
      //     contactResponse["adventuresClub"],
      //     contactResponse["memberSince"].toString());
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
      // profileData = tempProfileData[0];
      notesList = tempNotesList;
      galleriesMap = {}; // tempGalleriesMap;
      loading = false;
    });

    // if (tripList == null) {
    //   tripList = [];
    // }

    return "done";
  }

  // tripList

  updateSliderImagesList() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      online = (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi);
      if (online == false) {
        await getOfflineLoad();
      } else {
        if (tripList.isEmpty) {
          await updateSliderImages();

          percent = 0.3;
          setState(() {});
          sliderImageTimer();

          percent = 0.5;
          setState(() {});
          await updateTripListList();
        } else {
          setState(() {
            loading = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
    // setState(() {
    //
    // });
  }

  VoidCallback loadingCallBack() {
    return () {
      setState(() {
        loadedCount++;
        if (percent < 0.9) {
          percent += .05;
        }
      });
    };
  }

  updateTripListList() async {
    var tempList = await AggressorApi()
        .getReservationList(currentUser!.contactId!, loadingCallBack);
    tripList = tempList;
    for (var trip in tripList) {
      trip.user = currentUser;
      await trip.initCharterInformation();

      setState(() {
        if (percent < 0.9) {
          percent += .05;
        }
        // percent += (loadedCount / (loadingLength));
      });
    }

    if (tempList.length == 0) {
      percent = 0.95;
    }

    setState(() {
      loading = false;
    });
  }

  /*
  Build
   */

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    homePage = true;
    return PinchToZoom(
      OrientationBuilder(
        builder: (context, orientation) {
          portrait = orientation == Orientation.portrait;
          return Stack(
            children: [
              getBackGroundImage(),
              loading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: portrait
                                ? MediaQuery.of(context).size.width / 3
                                : MediaQuery.of(context).size.height / 3,
                            percent: (percent > 1.0) ? 1 : percent,
                            animateFromLastPercent: true,
                            backgroundColor: AggressorColors.secondaryColor,
                            progressColor: AggressorColors.primaryColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              "${(((percent > 0.90) ? 0.95 : percent) * 100).roundToDouble()} %",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    )
                  : getForegroundView(),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<dynamic> updateSliderImages() async {
    SlidersDatabaseHelper slidersDatabaseHelper =
        SlidersDatabaseHelper.instance;
    List<String> fileNames = await AggressorApi().getRewardsSliderList();
    // for (String file in fileNames) {

    await Future.forEach(fileNames, (String file) async {
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
      // setState(() {
      //   percent += .01;
      // });
    });
    return "done";
  }

/*
  self implemented
   */
  Widget getForegroundView() {
    //this method returns a column containing the actual content of the page to be shown over the background image
    return ListView(
      children: [
        showOffline(),
        getSliderImages(),
        getPageTitle(),
        getSectionUpcomingTitle(),
        getUpcomingSection(getTripList(tripList)[1]),
        getSectionPastTitle(),
        getPastSection(getTripList(tripList)[0]),
      ],
    );
  }

  Widget getSliderImages() {
    //returns slider images on top of the page
    return IntrinsicHeight(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: sliderImageList.length == 0
                ? Container()
                : Stack(
                    children: [
                      Image.file(
                        File(
                          sliderImageList[sliderIndex == 0
                              ? sliderImageList.length - 1
                              : sliderIndex - 1]["filePath"],
                        ),
                        fit: BoxFit.scaleDown,
                      ),
                      FadeInImage(
                        fit: BoxFit.scaleDown,
                        placeholder: FileImage(
                          File(sliderImageList[sliderIndex == 0
                              ? sliderImageList.length - 1
                              : sliderIndex - 1]["filePath"]),
                        ),
                        image: FileImage(
                          File(sliderImageList[sliderIndex]["filePath"]),
                        ),
                      ),
                    ],
                  ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  if (sliderIndex + 1 < sliderImageList.length) {
                    setState(() {
                      sliderIndex++;
                    });
                  } else {
                    setState(() {
                      sliderIndex = 0;
                    });
                  }
                },
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white70,
                  size: portrait
                      ? MediaQuery.of(context).size.width / 7.5
                      : MediaQuery.of(context).size.height / 7.5,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  if (sliderIndex > 0) {
                    setState(() {
                      sliderIndex--;
                    });
                  } else {
                    setState(() {
                      sliderIndex = sliderImageList.length - 1;
                    });
                  }
                },
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white70,
                  size: portrait
                      ? MediaQuery.of(context).size.width / 7.5
                      : MediaQuery.of(context).size.height / 7.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getUpcomingSection(List<Trip> upcomingTrips) {
    //returns either the no upcoming trips dialogue or the listview
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
          color: Colors.white,
          child: upcomingTrips.length == 0
              ? Center(
                  child: Text(
                      "You do not have any upcoming adventures booked yet."),
                )
              : getUpcomingListViews(upcomingTrips)),
    );
  }

  Widget getPastSection(List<Trip> pastTrips) {
    //returns either the no past trips dialogue or the listview
    double textBoxSize = MediaQuery.of(context).size.width / 4.3;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Container(
          color: Colors.white,
          child: pastTrips.length == 0
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: .5,
                      color: Colors.grey,
                    ),
                    Container(
                      color: AggressorColors.accentYellow,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: textBoxSize,
                            child: Text("Conf#", textAlign: TextAlign.center),
                          ),
                          Spacer(
                            flex: 10,
                          ),
                          SizedBox(
                            width: textBoxSize,
                            child:
                                Text("Adventure", textAlign: TextAlign.center),
                          ),
                          Spacer(
                            flex: 10,
                          ),
                          SizedBox(
                            width: textBoxSize,
                            child: Text(
                              "Start Date",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: textBoxSize / 2,
                          ),
                          SizedBox(
                            width: textBoxSize / 2,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                          "You do not have any past adventures to view yet."),
                    ),
                  ],
                )
              : getPastTripListViews(pastTrips)),
    );
  }

  Widget getUpcomingListViews(List<Trip> upcomingTrips) {
    //returns the list item containing upcoming trip objects

    upcomingTripsList.clear();
    upcomingTrips.forEach((element) {
      upcomingTripsList
          .add(element.getUpcomingTripCard(context, refresh, portrait));
    });

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: upcomingTripsList.length,
        itemBuilder: (context, position) {
          return upcomingTripsList[upcomingTripsList.length - 1 - position];
        });
  }

  VoidCallback refresh() {
    return () {
      setState(() {});
    };
  }

  Widget getPastTripListViews(List<Trip> pastTrips) {
    //returns the list item containing past trip objects

    double textBoxSize = MediaQuery.of(context).size.width / 4.3;
    pastTripsList.clear();
    pastTripsList.add(
      Container(
        width: double.infinity,
        color: AggressorColors.accentYellow,
        child: Column(
          children: [
            Container(
              height: .5,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: textBoxSize,
                  child: Text("Conf#", textAlign: TextAlign.center),
                ),
                Spacer(
                  flex: 10,
                ),
                SizedBox(
                  width: textBoxSize,
                  child: Text("Adventure", textAlign: TextAlign.center),
                ),
                Spacer(
                  flex: 10,
                ),
                SizedBox(
                  width: textBoxSize,
                  child: Text(
                    "Start Date",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: textBoxSize / 2,
                ),
                SizedBox(
                  width: textBoxSize / 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    int index = 0;
    pastTrips.forEach((element) {
      element.user = currentUser;
      pastTripsList.add(element.getPastTripCard(context, index));
      index++;
    });

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pastTripsList.length,
        itemBuilder: (context, position) {
          return pastTripsList[position];
        });
  }

  Widget getSectionPastTitle() {
    //returns the past trips title and divider
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Past Adventures",
              style: TextStyle(
                color: Colors.black,
                fontSize: portrait
                    ? MediaQuery.of(context).size.height / 45
                    : MediaQuery.of(context).size.width / 45,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Container(
            color: AggressorColors.secondaryColor,
            height: 1.5,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  List<List<Trip>> getTripList(List<Trip> tripList) {
    //returns the list of all active trips and sorts them by upcoming or past
    List<Trip> pastList = [];
    List<Trip> upcomingList = [];
    tripList.sort((a, b) =>
        DateTime.parse(b.tripDate!).compareTo(DateTime.parse(a.tripDate!)));

    tripList.forEach((element) {
      if (DateTime.parse(element.tripDate!).isBefore(DateTime.now())) {
        pastList.add(element);
      } else {
        upcomingList.add(element);
      }
    });

    return [pastList, upcomingList];
  }

  Widget getSectionUpcomingTitle() {
    // returns the upcoming trips title and divider
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Upcoming Adventures",
              style: TextStyle(
                color: Colors.black,
                fontSize: portrait
                    ? MediaQuery.of(context).size.height / 45
                    : MediaQuery.of(context).size.width / 45,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Container(
            color: AggressorColors.secondaryColor,
            height: 1.5,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  void sliderImageTimer() async {
    try {
      if (!timerStarted) {
        setState(() {
          timerStarted = true;
        });
        while (true) {
          await Future.delayed(Duration(seconds: 5));
          if (sliderIndex + 1 < sliderImageList.length) {
            setState(() {
              sliderIndex++;
            });
          } else {
            setState(() {
              sliderIndex = 0;
            });
          }
        }
      }
    } catch (e) {}
  }

  Widget getPageTitle() {
    // returns the the text label for the overall page
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
        child: Text(
          "Manage My Adventures",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 30
                  : MediaQuery.of(context).size.width / 30,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getBackGroundImage() {
    // this method return the blue background globe image that is lightly shown under the application, this also return the slightly tinted overview for it.
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.25), BlendMode.dstATop),
        child: Image.asset(
          "assets/pagebackground.png",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget showOffline() {
    // displays offline when the application does not have internet connection
    return online
        ? Container()
        : Container(
            color: Colors.red,
            child: Text(
              "Application is offline",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
  }
}
