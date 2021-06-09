/*
creates a note class to hold the contents of a note object
 */
import 'dart:ui';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/notes_database.dart';
import 'package:aggressor_adventures/databases/offline_database.dart';
import 'package:aggressor_adventures/user_interface_pages/notes_view_page.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  VoidCallback callback;

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
      BuildContext pageContext, VoidCallback callback) {
    //default constructor
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
    this.callback = callback;
  }

  Map<String, dynamic> toMap() {
    //create a map object from note object
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
    //creates a note row to be displayed on the notes page
    double textBoxSize = MediaQuery.of(context).size.width / 4;
    double iconSize = MediaQuery.of(context).size.width / 15;

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
                  months[DateTime.parse(startDate).month - 1].substring(0,3) + " " + DateTime.parse(startDate).day.toString() + ", " + DateTime.parse(startDate).year.toString() ,
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
                      deleteNote();
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void deleteNote() async {

    //deletes this note object and updates the notes page list
    if(online){
      var delRes = await AggressorApi().deleteNote(user.userId, id);
      callback();
    }
    else{
      await NotesDatabaseHelper.instance.deleteNotes(id);
      if(await OfflineDatabaseHelper.instance.offlineExists(id)){
        OfflineDatabaseHelper.instance.deleteOffline(id);
      }
      await OfflineDatabaseHelper.instance.insertOffline({'type': 'note', 'id': id, 'action': 'delete'});
      callback();
    }
  }

  void openNote() {
    //opens a note in the note view page
    Navigator.push(
        pageContext,
        MaterialPageRoute(
            builder: (context) => ViewNote(
                user,
                Note(id, boatId, destination, startDate, endDate, preTripNotes,
                    postTripNotes, miscNotes, user, context, callback))));
  }
}
