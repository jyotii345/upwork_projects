import 'dart:ui';

import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:flutter/cupertino.dart';

class Gallery {
  String charterId;
  List<Photo> photos;
  Trip trip;

  Gallery(String charterId, List<Photo> photos,Trip trip
      ) {
    this.charterId = charterId;
    this.photos = photos;
    this.trip = trip;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'charterId' : charterId,
      'photos' : photos,
      'trip' : trip,
    };
  }

  addPhoto(Photo photo){
    photos.add(photo);
  }

  Widget getGalleryRow(BuildContext context, int index){
    return Text(trip.reservationId);
  }
}
