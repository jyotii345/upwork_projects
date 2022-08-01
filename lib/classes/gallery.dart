/*
gallery class that create a gallery object to hold objects of photos
 */
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/offline_database.dart';
import 'package:aggressor_adventures/databases/photo_database.dart';
import 'package:aggressor_adventures/user_interface_pages/photos_gallery_view.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import 'aggressor_api.dart';

class Gallery {
  User? user;
  String? boatId;
  List<Photo>? photos;
  Trip? trip;
  VoidCallback? deleteCallback = () {};
  List<VoidCallback>? callBackList;

  Gallery(
    User user,
    String boatId,
    List<Photo> photos,
    Trip trip,
  ) {
    //default constructor
    this.user = user;
    this.boatId = boatId;
    this.photos = photos;
    this.trip = trip;
    this.callBackList = callBackList;
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
    bool exists = false;

    photos!.forEach((element) {
      if (element.imageName == photo.imageName) exists = true;
    });
    if (!exists) {
      photos!.add(photo);
    }
  }

  Widget getGalleryRow(BuildContext context, int index) {
    //creates a gallery row to be displayed on the photos page
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
                  child: GestureDetector(
                    onTap: () {
                      openGalleryView(context);
                    },
                    child: Text(
                      trip!.boat!.name!,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: AggressorColors.secondaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: textBoxSize,
                child: Text(
                  months[DateTime.parse(trip!.tripDate!).month - 1]
                          .substring(0, 3) +
                      " " +
                      DateTime.parse(trip!.tripDate!).day.toString() +
                      ", " +
                      DateTime.parse(trip!.tripDate!).year.toString(),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: textBoxSize / 2,
                child: IconButton(
                    icon: Image.asset(
                      "assets/trashcan.png",
                    ),
                    onPressed: () {
                      //shows a success message when the profile is updated successfully
                      showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                                title: new Text('Confirm'),
                                content: new Text(
                                    "Are you sure you would like to delete this photo gallery?"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: new Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        deleteGallery();
                                      },
                                      child: new Text('Continue')),
                                ],
                              ));
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void openGalleryView(BuildContext context) {
    //open a gallery to view its contents on the gallery view page
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GalleryView(
                  user!,
                  boatId!,
                  photos!,
                  trip!,
                ))).then((value) => deleteCallback!());
  }

  void deleteGallery() async {
    galleriesMap.remove(trip!.reservationId);
    deleteCallback!();

    if (online) {
      for (var value in photos!) {
         await AggressorApi().deleteAwsFile(
            user!.userId.toString(),
            "gallery",
            trip!.charter!.boatId.toString(),
            formatDate(DateTime.parse(trip!.charter!.startDate!),
                [yyyy, '-', mm, '-', dd]),
            value.imageName.toString());

        PhotoDatabaseHelper.instance.deletePhoto(value.imagePath!);
      }

      await Future.delayed(Duration(seconds: 1));
      deleteCallback!();
      filesLoaded = false;
    } else {
      for (var value in photos!) {
        await OfflineDatabaseHelper.instance.insertOffline(
            {'type': 'image', "id": value.imagePath, "action": "delete"});
        await PhotoDatabaseHelper.instance.deletePhoto(value.imagePath!);
      }

      deleteCallback!();
      filesLoaded = false;
    }
  }

  void setCallback(VoidCallback callback) {
    this.deleteCallback = callback;
  }
}
