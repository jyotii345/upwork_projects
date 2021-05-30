import 'dart:ui';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/user_interface_pages/notes_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class Note {
  String id;
  String boatId;
  String destination;
  String startDate;
  String endDate;
  String preTripNotes;
  String postTripNotes;
  String miscNotes;
  User user;
  BuildContext pageContext;

  Note(
      String id,
      String boatId,
      String destination,
      String startDate,
      String endDate,
      String preTripNotes,
      String postTripNotes,
      String miscNotes,
      User user,
      BuildContext pageContext) {
    this.id = id;
    this.boatId = boatId;
    this.destination = destination;
    this.startDate = startDate;
    this.endDate = endDate;
    this.preTripNotes = preTripNotes;
    this.postTripNotes = postTripNotes;
    this.miscNotes = miscNotes;
    this.user = user;
    this.pageContext = pageContext;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'id': id,
      'boatId': boatId,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'preTripNotes': preTripNotes,
      'postTripNotes': postTripNotes,
      'miscNotes': miscNotes,
    };
  }

  Widget getNoteRow(BuildContext context, int index) {
    double textBoxSize = MediaQuery.of(context).size.width / 4;
    double iconSize = MediaQuery.of(context).size.width / 15;

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
                child: GestureDetector(
                  onTap: openNote,
                  child: SizedBox(
                    width: textBoxSize,
                    child: Text(
                      destination,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: AggressorColors.secondaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: textBoxSize,
                child: Text(
                  startDate,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                child: IconButton(
                    icon: Image.asset(
                      "assets/trashcan.png",
                      height: iconSize,
                      width: iconSize,
                    ),
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

  void openNote() {
    Navigator.push(
        pageContext,
        MaterialPageRoute(
            builder: (context) => ViewNote(
                user,
                Note(id, boatId, destination, startDate, endDate, preTripNotes,
                    postTripNotes, miscNotes, user, context))));
  }
}
