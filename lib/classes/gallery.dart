import 'dart:ui';

import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Gallery {
  String charterId;
  List<Photo> photos;
  Trip trip;

  Gallery(String charterId, List<Photo> photos, Trip trip) {
    this.charterId = charterId;
    this.photos = photos;
    this.trip = trip;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'charterId': charterId,
      'photos': photos,
      'trip': trip,
    };
  }

  addPhoto(Photo photo) {
    photos.add(photo);
  }

  Widget getGalleryRow(BuildContext context, int index) {
    double textBoxSize = MediaQuery.of(context).size.width / 4;

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
              Expanded(
                child: SizedBox(
                  width: textBoxSize,
                  child: Text(trip.detailDestination,
                      textAlign: TextAlign
                          .left), //TODO replace with actual destination
                ),
              ),
              SizedBox(
                width: textBoxSize,
                //TODO everything with this date should be replaced with embarkment date soon.
                child: Text(
                  months[DateTime.parse(trip.tripDate).month - 1]
                          .substring(0, 3) +
                      " " +
                      DateTime.parse(trip.tripDate).day.toString() +
                      ", " +
                      DateTime.parse(trip.tripDate).year.toString(),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: textBoxSize / 2,
                child: IconButton(
                    icon: Image.asset("assets/trashcan.png"),
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
