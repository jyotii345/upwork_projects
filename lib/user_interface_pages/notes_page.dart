import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/file_data.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/note.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/files_database.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'notes_add_page.dart';

class Notes extends StatefulWidget {
  Notes(
    this.user,
  );

  final User user;

  @override
  State<StatefulWidget> createState() => new NotesState();
}

class NotesState extends State<Notes> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  String fileName = "";

  Map<String, dynamic> dropDownValue;

  List<dynamic> notesList = [];
  List<Note> noteList = <Note>[];

  List<Trip> sortedTripList;

  String errorMessage = "";

  List<Trip> dateDropDownList = [];
  Trip dateDropDownValue;

  BuildContext pageContext;

  bool loading = false;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    dateDropDownValue = Trip(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    );
    dateDropDownValue.charter = Charter("", "", "", "", "", "", "", "", "");
    dropDownValue = boatList[0];
  }

  /*
  Build
   */

  @override
  Widget build(BuildContext context) {
    super.build(context);

    getNotes();

    pageContext = context;
    return Stack(
      children: [
        getBackgroundImage(),
        getPageForm(),
        Container(
          height: MediaQuery.of(context).size.height / 7 + 4,
          width: double.infinity,
          color: AggressorColors.secondaryColor,
        ),
        getBannerImage(),
      ],
    );
  }

  /*
  Self implemented
   */

  Widget getPageForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
            ),
            getPageTitle(),
            getCreateNote(),
            getFilesSection(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget getCreateNote() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ADD A NEW NOTE",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: MediaQuery.of(context).size.height / 35,
                fontWeight: FontWeight.bold),
          ),
          getYachtDropDown(boatList),
          getDateDropDown(),
          getCreateNoteButton(),
        ],
      ),
    );
  }

  Widget getYachtDropDown(List<Map<String, dynamic>> boatList) {
    // sortedTripList = [selectionTrip];
    // tripList = sortTripList(tripList); // sort boatList instead
    // tripList.forEach((element) {
    //   sortedTripList.add(element);
    // });

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Yacht:",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 35,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: DropdownButton<Map<String, dynamic>>(
                underline: Container(),
                value: dropDownValue,
                elevation: 0,
                isExpanded: true,
                iconSize: MediaQuery.of(context).size.height / 35,
                onChanged: (Map<String, dynamic> newValue) {
                  setState(() {
                    dropDownValue = newValue;
                    dateDropDownList = getDateDropDownList(newValue);
                  });
                },
                items: boatList.map<DropdownMenuItem<Map<String, dynamic>>>(
                    (Map<String, dynamic> value) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: value,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        value["name"],
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height / 40 - 4),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDateDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "DepartureDate:",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 35,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: DropdownButton<Trip>(
                underline: Container(),
                value: dateDropDownValue,
                elevation: 0,
                isExpanded: true,
                iconSize: MediaQuery.of(context).size.height / 35,
                onChanged: (Trip newValue) {
                  setState(() {
                    dateDropDownValue = newValue;
                  });
                },
                items:
                    dateDropDownList.map<DropdownMenuItem<Trip>>((Trip value) {
                  return DropdownMenuItem<Trip>(
                    value: value,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        value.charter == null
                            ? "You have adventures on this yacht."
                            : DateTime.parse(
                                        value.charter.startDate)
                                    .month
                                    .toString() +
                                "/" +
                                DateTime.parse(value.charter.startDate)
                                    .day
                                    .toString() +
                                "/" +
                                DateTime.parse(value.charter.startDate)
                                    .year
                                    .toString(),
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height / 40 - 4),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Trip> getDateDropDownList(Map<String, dynamic> boatMap) {
    List<Trip> tempList = [];
    tripList.forEach((element) {
      if (element.boat.boatId.toString() == boatMap["boatid"].toString()) {
        tempList.add(element);
      }
    });

    if (tempList.length == 0) {
      tempList = [Trip("", "", "", "", "", "", "")];
    }

    setState(() {
      dateDropDownValue = tempList[0];
    });

    return tempList;
  }

  List<Trip> sortTripList(List<Trip> tripList) {
    List<Trip> tempList = tripList;
    tempList.sort((a, b) =>
        DateTime.parse(b.tripDate).compareTo(DateTime.parse(a.tripDate)));

    return tempList;
  }

  Widget getCreateNoteButton() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 4,
          ),
          TextButton(
            onPressed: () {
              if (dateDropDownValue.charter != null) {
                if (dateDropDownValue.charter.startDate != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNotes(
                        widget.user,
                        dateDropDownValue,
                        notesCallBack,
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(
              "Create note",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: AggressorColors.secondaryColor),
          ),
        ],
      ),
    );
  }

  Widget getBackgroundImage() {
    //this method return the blue background globe image that is lightly shown under the application, this also return the slightly tinted overview for it.
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

  Widget getBannerImage() {
    //returns banner image
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 7,
      child: Image.asset(
        "assets/bannerimage.png",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget getPageTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Notes",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getFilePrompt() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Files must be uploaded as: PDF, TXT, DOC, JPG, PNG",
          style: TextStyle(
              color: Colors.grey[400],
              fontSize: MediaQuery.of(context).size.height / 55,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getFilesSection() {
    double textBoxSize = MediaQuery.of(context).size.width / 4;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        color: Colors.white,
        child: noteList.length == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: .5,
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: textBoxSize,
                            child: Text("Yacht", textAlign: TextAlign.center),
                          ),
                        ),
                        SizedBox(
                          width: textBoxSize,
                          child: Text("Date", textAlign: TextAlign.center),
                        ),
                        SizedBox(
                          width: textBoxSize / 2,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Text("You do not have any notes to view yet."),
                  ),
                ],
              )
            : getNotesView(),
      ),
    );
  }

  Widget getNotesView() {
    //returns the list item containing fileData objects

    double textBoxSize = MediaQuery.of(context).size.width / 4;
    notesList.clear();
    notesList.add(
      Container(
        width: double.infinity,
        color: Colors.grey[100],
        child: Column(
          children: [
            Container(
              height: .5,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    width: textBoxSize,
                    child: Text("Yacht", textAlign: TextAlign.left),
                  ),
                ),
                SizedBox(
                  width: textBoxSize,
                  child: Text("Date", textAlign: TextAlign.left),
                ),
                SizedBox(
                  width: textBoxSize / 2,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    int index = 0;

    noteList.forEach((value) {
      notesList.add(value.getNoteRow(
        context,
        index,
      ));
      index++;
    });

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: notesList.length,
        itemBuilder: (context, position) {
          return notesList[position];
        });
  }

  Future<dynamic> getNotes() async {
    //downloads file from aws. If the file is not already in storage, it will be stored on the device.
    setState(() {
      loading = true;
    });
    if (!notesLoaded) {
      Map<String, Note> notesMap = <String, Note>{};

      List<dynamic> noteResponse =
          await AggressorApi().getNoteList(widget.user.userId);

      for (var element in noteResponse) {
        notesMap[element["id"].toString()] = Note(
            element["id"].toString(),
            element["boatID"].toString(),
            element["destination"],
            element["startDate"],
            element["endDate"],
            element["preTripNotes"],
            element["postTripNotes"],
            element["misc"],
            widget.user,
            pageContext,
            notesCallBack);
      }

      List<Note> tempNotes = [];
      notesMap.forEach((key, value) {
        tempNotes.add(value);
        int insertAt = tripList.indexWhere((element) =>
            element.boat.boatId == value.boatId &&
            DateTime.parse(value.startDate) ==
                DateTime.parse(element.charter.startDate));
        if (insertAt != -1) {
          tripList[insertAt].note = value;
        }
      });

      setState(() {
        noteList = tempNotes;
        notesLoaded = true;
      });
    }
    setState(() {
      loading = false;
    });
    return "finished";
  }

  Widget showErrorMessage() {
    return errorMessage == ""
        ? Container()
        : Padding(
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 10.0),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget showLoading() {
    return loading
        ? Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0, 0),
            child: LinearProgressIndicator(
              backgroundColor: AggressorColors.primaryColor,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Container();
  }

  VoidCallback notesCallBack() {
    setState(() {
      notesLoaded = false;
    });
  }

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */

}
