/*
creates a trip class to hold the contents of a trip object
 */
import 'dart:io';
import 'dart:ui';
import 'package:aggressor_adventures/classes/boat.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/note.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/boat_database.dart';
import 'package:aggressor_adventures/databases/charter_database.dart';
import 'package:aggressor_adventures/databases/trip_database.dart';
import 'package:aggressor_adventures/user_interface_pages/photos_gallery_view.dart';
import 'package:aggressor_adventures/user_interface_pages/notes_add_page.dart';
import 'package:aggressor_adventures/user_interface_pages/notes_view_page.dart';
import 'package:aggressor_adventures/user_interface_pages/trip_make_payment_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'aggressor_api.dart';
import 'globals_user_interface.dart';

class Trip {
  User user;
  String tripDate;
  String title;
  String latitude;
  String longitude;
  String destination;
  String reservationDate;
  String reservationId;
  String imageResource;
  String charterId;
  String total;
  String discount;
  String payments;
  String due;
  String dueDate;
  String passengers;
  String location;
  String embark;
  String disembark;
  String detailDestination;
  String loginKey;
  String passengerId;
  String errorMessage = "";
  List<VoidCallback> callBackList;
  VoidCallback newImageCallBack;

  Note note;
  Boat boat;
  Charter charter;

  Trip(
      String tripDate,
      String title,
      String latitude,
      String longitude,
      String destination,
      String reservationDate,
      String reservationId,
      String loginKey,
      String passengerId) {
    this.tripDate = tripDate;
    this.title = title;
    this.latitude = latitude;
    this.longitude = longitude;
    this.destination = destination;
    this.reservationDate = reservationDate;
    this.reservationId = reservationId;
    this.loginKey = loginKey;
    this.passengerId = passengerId;
  }

  Trip.TripWithDetails(
      String tripDate,
      String title,
      String latitude,
      String longitude,
      String destination,
      String reservationDate,
      String reservationId,
      String charterId,
      String total,
      String discount,
      String payments,
      String due,
      String dueDate,
      String passengers,
      String location,
      String embark,
      String disembark,
      String detailDestination,
      String loginKey,
      String passengerId) {
    //default constructor
    this.tripDate = tripDate;
    this.title = title;
    this.latitude = latitude;
    this.longitude = longitude;
    this.destination = destination;
    this.reservationDate = reservationDate;
    this.reservationId = reservationId;
    this.charterId = charterId;
    this.total = total;
    this.discount = discount;
    this.payments = payments;
    this.due = due;
    this.dueDate = dueDate;
    this.passengers = passengers;
    this.location = location;
    this.embark = embark;
    this.disembark = disembark;
    this.detailDestination = detailDestination;
    this.loginKey = loginKey;
    this.passengerId = passengerId;
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    //create a trip object from a json file
    return Trip(
      json['tripDate'].toString(),
      json['title'].toString(),
      json['latitude'].toString(),
      json['longitude'].toString(),
      json['destination'].toString(),
      json['reservationDate'].toString(),
      json['reservationid'].toString(),
      json['loginKey'].toString(),
      json['passengerid'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    //create  a json object from a trip object
    return {
      'tripDate': tripDate,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'destination': destination,
      'reservationDate': reservationDate,
      'reservationId': reservationId,
    };
  }

  Map<String, dynamic> toMap() {
    //create a map from a trip object
    return {
      'tripDate': tripDate,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'destination': destination,
      'reservationDate': reservationDate,
      'reservationId': reservationId,
      'charterId': charterId,
      'total': total,
      'discount': discount,
      'payments': payments,
      'due': due,
      'dueDate': dueDate,
      'passengers': passengers,
      'location': location,
      'embark': embark,
      'disembark': disembark,
      'detailDestination': detailDestination,
      'loginKey': loginKey,
      'passengerId': passengerId,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    //create a trip object from a map object
    return Trip.TripWithDetails(
      map['tripDate'].toString(),
      map['title'].toString(),
      map['latitude'].toString(),
      map['longitude'].toString(),
      map['destination'].toString(),
      map['reservationDate'].toString(),
      map['reservationId'].toString(),
      map['charterId'].toString(),
      map['total'].toString(),
      map['discount'].toString(),
      map['payments'].toString(),
      map['due'].toString(),
      map['dueDate'].toString(),
      map['passengers'].toString(),
      map['location'].toString(),
      map['embark'].toString(),
      map['disembark'].toString(),
      map['detailDestination'].toString(),
      map['loginKey'].toString(),
      map['passengerId'].toString(),
    );
  }

  Future<dynamic> getTripDetails(String contactId) async {
    //get details for this specific trip object and add the results to this trip
    var jsonResponse = await AggressorApi()
        .getReservationDetails(reservationId.toString(), contactId.toString());
    if (jsonResponse["status"] == "success") {
      charterId = jsonResponse["charterid"].toString();
      total = jsonResponse["total"].toString();
      discount = jsonResponse["discount"].toString();
      payments = jsonResponse["payments"].toString();
      due = jsonResponse["due"].toString();
      dueDate = jsonResponse["dueDate"].toString();
      passengers = jsonResponse["passengers"].toString();
      location = jsonResponse["location"].toString();
      embark = jsonResponse["embark"].toString();
      disembark = jsonResponse["disembark"].toString();
      detailDestination = jsonResponse["destination"].toString();
      return "success";
    } else {
      return "error";
    }
  }

  Future<dynamic> initCharterInformation() async {
    //gets charter and boat information about this trip
    charter = await CharterDatabaseHelper.instance.getCharter(charterId);
    boat = await BoatDatabaseHelper.instance.getBoat(charter.boatId);
    boatList.forEach((boatObj) {
      if (boatObj["boatid"].toString() == boat.boatId) {
        boat.kbygLink = boatObj["kbyg"];
      }
    });
  }

  Widget getUpcomingTripCard(
      BuildContext context, VoidCallback refreshState, portrait) {
    //returns the tile view to be placed into the view for the previous trips this user has been engaged in
    double textBoxSize = MediaQuery.of(context).size.width / 6.3;
    double screenFontSize = MediaQuery.of(context).size.width / 50;
    double screenFontSizeSmall = MediaQuery.of(context).size.width / 60;

    double rowSectionHeight = portrait
        ? ((((textBoxSize * 1.5) - MediaQuery.of(context).size.height / 20) -
                    (10 / 3)) +
                (textBoxSize / 4)) /
            3
        : ((((textBoxSize * 1.5) - MediaQuery.of(context).size.width / 20) -
                    (10 / 3)) +
                (textBoxSize / 4)) /
            3;

    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return OrientationBuilder(
      builder: (context, orientation) {
        return Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.grey[200],
                            height: textBoxSize * 1.5,
                            width: textBoxSize * 1.5,
                            child: FutureBuilder(
                              future: downloadBoatImage(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return snapshot.data != ""
                                      ? GestureDetector(
                                          onTap: () {
                                            imageExpansionDialogue(
                                              Image.file(
                                                File(snapshot.data),
                                                fit: BoxFit.fill,
                                              ),
                                            );
                                          },
                                          child: Image.file(
                                            File(snapshot.data),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Icon(Icons.directions_boat_sharp);
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            height: textBoxSize / 4,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Days Left: ",
                                  style: TextStyle(fontSize: screenFontSize * 1.5),
                                ),
                                Text(
                                  DateTime.now()
                                      .difference(
                                          DateTime.parse(charter.startDate))
                                      .inDays
                                      .abs()
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenFontSize  * 1.5),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: portrait
                              ? MediaQuery.of(context).size.height / 20
                              : MediaQuery.of(context).size.width / 20,
                          width: portrait
                              ? MediaQuery.of(context).size.height / 20
                              : MediaQuery.of(context).size.width / 20,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              child: Image.asset("assets/notesblue.png"),
                              onPressed: () {
                                viewTripNotes();
                              }),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[200],
                            border: Border(
                              top: BorderSide(width: 1.0, color: Colors.grey),
                              left: BorderSide(width: 1.0, color: Colors.grey),
                              right: BorderSide(width: 1.0, color: Colors.grey),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: textBoxSize,
                                height: rowSectionHeight,
                                child: Center(
                                  child: Text(
                                    "conf#",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: screenFontSize),
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 3,
                              ),
                              SizedBox(
                                width: textBoxSize,
                                child: Text(
                                  "Adventure",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: screenFontSize),
                                ),
                              ),
                              Spacer(
                                flex: 3,
                              ),
                              SizedBox(
                                width: textBoxSize,
                                child: Text(
                                  "Embarkment Date",
                                  style: TextStyle(fontSize: screenFontSize),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Spacer(
                                flex: 3,
                              ),
                              SizedBox(
                                width: textBoxSize,
                                child: Text(
                                  "Nights",
                                  style: TextStyle(fontSize: screenFontSize),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey),
                              right: BorderSide(width: 1.0, color: Colors.grey),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: textBoxSize,
                                height: rowSectionHeight,
                                child: Center(child:Text(
                                  reservationId,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: screenFontSize),
                                ),),
                              ),
                              Spacer(
                                flex: 10,
                              ),
                              SizedBox(
                                width: textBoxSize,
                                child: Text(
                                  boat.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: screenFontSize),
                                ),
                              ),
                              Spacer(
                                flex: 10,
                              ),
                              SizedBox(
                                width: textBoxSize,
                                child: Text(
                                  months[DateTime.parse(charter.startDate)
                                                  .month -
                                              1]
                                          .substring(0, 3) +
                                      " " +
                                      DateTime.parse(charter.startDate)
                                          .day
                                          .toString() +
                                      ", " +
                                      DateTime.parse(charter.startDate)
                                          .year
                                          .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: screenFontSize),
                                ),
                              ),
                              SizedBox(
                                width: textBoxSize,
                                child: Text(
                                  charter.nights,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: screenFontSize),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.grey),
                              left: BorderSide(width: 1.0, color: Colors.grey),
                              right: BorderSide(width: 1.0, color: Colors.grey),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: rowSectionHeight,
                                width: MediaQuery.of(context).size.width / 4.8,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0)),
                                  onPressed: () {
                                    launchGIS(refreshState);
                                  },
                                  child: Text("Guest Information System (GIS)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: screenFontSizeSmall)),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                                width: MediaQuery.of(context).size.width / 4.8,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0)),
                                  onPressed: () {
                                    launchKBYG();
                                  },
                                  child: Text(
                                    "Know before you go",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: screenFontSizeSmall),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4.8,
                                height: 25,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0)),
                                  onPressed: () {
                                    launchPayment(refreshState);
                                  },
                                  child: Text(
                                    "Make Payment",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: screenFontSizeSmall),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              errorMessage == ""
                  ? Container()
                  : Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void launchPayment(VoidCallback refreshState) async {
    if (double.parse(due) > 0) {
      navigatorKey.currentState.push(
        MaterialPageRoute(
          builder: (context) => MakePayment(
            user,
            this,
          ),
        ),
      );
    } else {
      errorMessage = "No payment is due for this adventure";
      refreshState();
      await Future.delayed(Duration(seconds: 2));
      errorMessage = "";
      refreshState();
    }
  }

  void launchKBYG() async {
    await launch(this.boat.kbygLink);
  }

  void launchGIS(VoidCallback refreshState) async {
    if (loginKey != null && loginKey != "null") {
      await launch("https://gis.liveaboardfleet.com/gis/index.php/" +
          passengerId.toString() +
          "/" +
          reservationId.toString() +
          "/" +
          charterId.toString() +
          "/" +
          loginKey.toString());
    } else {
      errorMessage = "Contact your agent to have a GIS link sent.";
      refreshState();
      await Future.delayed(Duration(seconds: 2));
      errorMessage = "";
      refreshState();
    }
  }

  void viewTripNotes() {
    if (note != null) {
      navigatorKey.currentState.push(
        MaterialPageRoute(
          builder: (context) => ViewNote(
            user,
            note,
          ),
        ),
      );
    } else {
      navigatorKey.currentState.push(
        MaterialPageRoute(
          builder: (context) => AddNotes(
            user,
            this,
            () {},
          ),
        ),
      );
    }
  }

  Future<dynamic> downloadBoatImage() async {
    //downloads and saves the boat image associated with this trip

    BoatDatabaseHelper boatDatabaseHelper = BoatDatabaseHelper.instance;

    String path = "";

    if (boat.imagePath == "" || boat.imagePath == null && online) {
      var imageDetails = await AggressorApi().getBoatImage(boat.imageLink);
      if (imageDetails != null) {
        var imageName = boat.imageLink
            .substring(boat.imageLink.toString().lastIndexOf("/") + 1);

        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;
        String filePath = '$appDocumentsPath/$imageName';
        File tempFile = await File(filePath).writeAsBytes(imageDetails[0]);
        boat.imagePath = tempFile.path;
        path = boat.imagePath;
      }
      await boatDatabaseHelper.deleteBoat(boat.boatId);
      await boatDatabaseHelper.insertBoat(boat);
    } else {
      path = boat.imagePath;
    }

    return path;
  }

  Widget getPastTripCard(BuildContext context, int index) {
    //returns the tile view to be placed into the view for the previous trips this user has been engaged in
    double textBoxSize = MediaQuery.of(context).size.width / 4.3;
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return Column(
      children: [
        Container(
          height: .5,
          color: Colors.grey,
        ),
        Container(
          color: index % 2 == 0 ? Colors.white : Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: textBoxSize,
                child: Text(reservationId, textAlign: TextAlign.center),
              ),
              SizedBox(
                width: textBoxSize,
                child: Text(boat.name, textAlign: TextAlign.center),
              ),
              SizedBox(
                width: textBoxSize,
                child: Text(
                  months[DateTime.parse(charter.startDate).month - 1]
                          .substring(0, 3) +
                      " " +
                      DateTime.parse(charter.startDate).day.toString() +
                      ", " +
                      DateTime.parse(charter.startDate).year.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: textBoxSize / 2,
                child: IconButton(
                    icon: Image.asset("assets/notesblue.png"),
                    onPressed: () {
                      viewTripNotes();
                    }),
              ),
              SizedBox(
                width: textBoxSize / 2,
                child: IconButton(
                    icon: Image.asset("assets/photosblue.png"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (pageContext) => GalleryView(
                            user,
                            charterId,
                            galleriesMap.containsKey(charterId)
                                ? galleriesMap[charterId].photos
                                : [],
                            this,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<dynamic> updateTripValues() async {
    //reloads the payment due for the boat
    var response = await AggressorApi()
        .getReservationDetails(reservationId, user.contactId);
    total = response['total'].toString();
    discount = response['discount'].toString();
    payments = response['payments'].toString();
    due = response['due'].toString();
    dueDate = response['dueDate'].toString();
    passengers = response['passengers'].toString();
    location = response['location'];
    embark = response['embark'];
    disembark = response['disembark'];
    await TripDatabaseHelper.instance.deleteTrip(reservationId);
    await TripDatabaseHelper.instance.insertTrip(this);
    return "updated";
  }

  void imageExpansionDialogue(Widget content) {
    //shows the image in a larger view
    showDialog(
      context: navigatorKey.currentContext,
      builder: (_) => new AlertDialog(title: Container(), content: content),
    );
  }
}
