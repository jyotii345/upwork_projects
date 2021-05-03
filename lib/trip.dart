import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Trip {
  String tripDate;
  String title;
  String latitude;
  String longitude;
  String destination;
  String reservationDate;
  String reservationId;
  String imageResource;

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

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      json['tripDate'].toString(),
      json['title'].toString(),
      json['latitude'].toString(),
      json['longitude'].toString(),
      json['destination'].toString(),
      json['reservationDate'].toString(),
      json['reservationid'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
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

  Widget getUpcomingTripCard(BuildContext context) {
    //returns the tile view to be placed into the view for the upcoming trips this user has been engaged in

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

    return Row(
      children: [
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.width / 4,
              child: Image(
                image: imageResource == null
                    ? Icon(Icons.directions_boat)
                    : AssetImage(imageResource),
              ),
            ),
            Row(
              children: [
                Text("Days Left: "),
                Text(
                  DateTime.now()
                      .difference(DateTime.parse(tripDate))
                      .inDays
                      .toString(),
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image(image: AssetImage("assets/notes.png")),
                //TODO replace with final resource
              ],
            ),
            Row(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.yellow[100],
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
                        child: Text("Yacht", textAlign: TextAlign.center),
                      ),
                      Spacer(
                        flex: 10,
                      ),
                      SizedBox(
                        width: textBoxSize,
                        child: Text(
                          "Embarkment Date",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: textBoxSize,
                        child: Text(reservationId, textAlign: TextAlign.center),
                      ),
                      Spacer(
                        flex: 10,
                      ),
                      SizedBox(
                        width: textBoxSize,
                        child: Text(title, textAlign: TextAlign.center),
                      ),
                      Spacer(
                        flex: 10,
                      ),
                      SizedBox(
                        width: textBoxSize,
                        child: Text(
                          months[DateTime.parse(tripDate).month - 1]
                                  .substring(0, 2) +
                              " " +
                              DateTime.parse(tripDate).day.toString() +
                              "," +
                              DateTime.parse(tripDate).year.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextButton(onPressed: (){}, child: Text("Guest Information System (GIS)", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlue),),),
                      TextButton(onPressed: (){}, child: Text("Know before you go", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlue),),),
                      TextButton(onPressed: (){}, child: Text("Make Payment", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlue),),),

                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
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
                  months[DateTime.parse(tripDate).month - 1].substring(0, 2) +
                      " " +
                      DateTime.parse(tripDate).day.toString() +
                      "," +
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
