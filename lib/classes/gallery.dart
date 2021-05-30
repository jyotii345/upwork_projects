/*
gallery class that create a gallery object to hold objects of photos
 */
import 'dart:ui';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/user_interface_pages/gallery_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Gallery {
  User user;
  String boatId;
  List<Photo> photos;
  Trip trip;
  List<VoidCallback> callBackList;

  Gallery(User user, String boatId, List<Photo> photos, Trip trip,) {
    //default constructor
    this.user = user;
    this.boatId = boatId;
    this.photos = photos;
    this.trip = trip;
    this.callBackList =  callBackList;
  }

  Map<String, dynamic> toMap() {
    //create a map object from gallery object
    return {
      'boatId': boatId,
      'photos': photos,
      'trip': trip,
    };
  }

  addPhoto(Photo photo) {
    //adds a photo to the photos list
    photos.add(photo);
  }

  Widget getGalleryRow(BuildContext context, int index) {
    //creates a gallery row to be displayed on the photos page
    double textBoxSize = MediaQuery.of(context).size.width / 4;

    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

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
                  child: GestureDetector(
                    onTap : (){openGalleryView(context);},
                    child: Text(
                      trip.boat.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: AggressorColors.secondaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: textBoxSize,
                child: Text(
                  months[DateTime.parse(trip.tripDate).month - 1].substring(0, 3) + " " + DateTime.parse(trip.tripDate).day.toString() + ", " + DateTime.parse(trip.tripDate).year.toString(),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: textBoxSize / 2,
                child: IconButton(
                    icon: Image.asset("assets/trashcan.png",),
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

  void openGalleryView(BuildContext context){
    //open a gallery to view its contents on the gallery view page
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GalleryView(user, boatId, photos, trip,)));
  }
}
