import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'aggressor_api.dart';

class Trip {
  String tripDate;
  String title;
  String latitude;
  String longitude;
  String destination;
  String reservationDate;
  String reservationId;
  String imageResource;
  String charterId,
      total,
      discount,
      payments,
      due,
      dueDate,
      passengers,
      location,
      embark,
      disembark,
      detailDestination;

  Trip(
    String tripDate,
    String title,
    String latitude,
    String longitude,
    String destination,
    String reservationDate,
    String reservationId,
  ) {
    this.tripDate = tripDate;
    this.title = title;
    this.latitude = latitude;
    this.longitude = longitude;
    this.destination = destination;
    this.reservationDate = reservationDate;
    this.reservationId = reservationId;
  }

  //TODO add a trip with details constructor

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
      String detailDestination) {
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
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    //create a trip object from a json file
    return Trip(
      //TODO add detail information to map
      json['tripDate'].toString(),
      json['title'].toString(),
      json['latitude'].toString(),
      json['longitude'].toString(),
      json['destination'].toString(),
      json['reservationDate'].toString(),
      json['reservationid'].toString(),
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
      'id': int.parse(reservationId),
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
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    //create a trip object from a json file
    return Trip.TripWithDetails(
      //TODO add detail information to map
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
    );
  }

  Future<dynamic> getTripDetails(String contactId) async {
    //get detials for this specific trip object and add the results to this trip
    var jsonResponse =
        await AggressorApi().getReservationDetails(reservationId, contactId);
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

  Widget getUpcomingTripCard(BuildContext context) {
    //returns the tile view to be placed into the view for the previous trips this user has been engaged in
    double textBoxSize = MediaQuery.of(context).size.width / 6.3;
    double screenFontSize = MediaQuery.of(context).size.width / 50;

    double screenFontSizeSmall = MediaQuery.of(context).size.width / 60;
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
                          height: MediaQuery.of(context).size.height / 7,
                          width: MediaQuery.of(context).size.height / 7,
                          child: imageResource == null
                              ? Icon(
                                  //TODO find a way to get boat images
                                  Icons.directions_boat,
                                  size: MediaQuery.of(context).size.height / 10,
                                )
                              : Image(image: AssetImage(imageResource)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Days Left: "),
                            Text(
                              DateTime.now()
                                  .difference(DateTime.parse(tripDate))
                                  .inDays
                                  .abs()
                                  .toString(),
                              style: TextStyle(color: Colors.red),
                            )
                          ],
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
                        height: 40,
                        width: 40,
                        child: TextButton(
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: Image.asset("assets/notes.png"),
                            onPressed:
                                () {}), //TODO replace with final image resource
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
                              child: Text(
                                "conf#",
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
                                "Yacht",
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
                              child: Text(
                                reservationId,
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
                                title,
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
                                months[DateTime.parse(tripDate).month - 1]
                                        .substring(0, 3) +
                                    " " +
                                    DateTime.parse(tripDate).day.toString() +
                                    "," +
                                    DateTime.parse(tripDate).year.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: screenFontSize),
                              ),
                            ),
                            SizedBox(
                              width: textBoxSize,
                              child: Text(
                                "7",
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
                            bottom: BorderSide(width: 1.0, color: Colors.grey),
                            left: BorderSide(width: 1.0, color: Colors.grey),
                            right: BorderSide(width: 1.0, color: Colors.grey),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 25,
                              width: MediaQuery.of(context).size.width / 4.8,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0)),
                                onPressed: () {},
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
                                onPressed: () {},
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
                                onPressed: () {},
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),
          ],
        ));
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
                child: Text(title, textAlign: TextAlign.center),
              ),
              SizedBox(
                width: textBoxSize,
                child: Text(
                  months[DateTime.parse(tripDate).month - 1].substring(0, 3) +
                      " " +
                      DateTime.parse(tripDate).day.toString() +
                      ", " +
                      DateTime.parse(tripDate).year.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: textBoxSize / 2,
                child: IconButton(
                    icon: Image.asset("assets/notes.png"),
                    //TODO replace with final graphic
                    onPressed: () {
                      print("pressed");
                    }),
              ),
              SizedBox(
                width: textBoxSize / 2,
                child: IconButton(
                    icon: Image.asset("assets/photos.png"),
                    //TODO replace with final graphic
                    onPressed: () {
                      print("pressed");
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
