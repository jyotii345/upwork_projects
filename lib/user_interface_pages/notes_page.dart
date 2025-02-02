import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/note.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/notes_database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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

  Map<String, dynamic>? dropDownValue=boatList.isEmpty?null: boatList[0];

  List<Widget> noteList = [];

  List<Trip>? sortedTripList;

  String errorMessage = "";

  List<Trip> dateDropDownList = [];
  Trip dateDropDownValue=Trip(
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "" ,
    "",
    ""
  );

  BuildContext? pageContext;

  bool loading = false;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    notesLoaded = false;
    dateDropDownValue = Trip(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "" ,
      "",
      ""
    );
    dateDropDownValue.charter = Charter("", "", "", "", "", "", "", "", "");
    if(boatList.isEmpty){
      getBoatList();
    }


    if(tripList.isEmpty){
      updateTripListList();
    }
  }

  updateTripListList() async {
    setState(() {
      loading=true;
    });
    var tempList =
    await AggressorApi().getReservationList(widget.user.contactId!,(){});
    tripList = tempList;
    for (var trip in tripList) {
      trip.user = widget.user;
      await trip.initCharterInformation();

      // setState(() {
      //   if(percent<0.9){
      //     percent += .05;
      //   }
        percent += (loadedCount / (loadingLength));
      // });
    }

    // await getGalleries();
    setState(() {
      loading = false;
    });
  }


  void getBoatList() async {
    // set the initial boat list

    setState(() {
      loading = true;
    });
    boatList = await AggressorApi().getBoatList();
    dropDownValue =boatList.isEmpty?null: boatList[0];

    setState(() {
      loading = false;
    });
  }

  /*
  Build
   */

  @override
  Widget build(BuildContext context) {
    super.build(context);

    getNotes();

    pageContext = context;

    return OrientationBuilder(builder: (context, orientation) {
      portrait = orientation == Orientation.portrait;
      return PinchToZoom(
        Stack(
          children: [
            getBackgroundImage(),
            getWhiteOverlay(),
            getPageForm(),
          ],
        ),
      );
    });
  }

  /*
  Self implemented
   */

  Widget getWhiteOverlay() {
    // returns a white background on the application
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget getPageForm() {
    // returns the main contents of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListView(
        children: [
          getBannerImage(),
          showOffline(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getPageTitle(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getCreateNote(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getNotesSection(),
          ),
          showErrorMessage(),
        ],
      ),
    );
  }

  Widget getCreateNote() {
    // returns the create note section of the page
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child:
      (dropDownValue==null)?
      Center(child: CircularProgressIndicator()):
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add a new note",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: portrait
                    ? MediaQuery.of(context).size.height / 40
                    : MediaQuery.of(context).size.width / 40,
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
    // returns the drop down of yachts associated with the users trips
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: AutoSizeText(
              "Adventure:",
              maxLines: 1,
              minFontSize: 3.0,
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            height: portrait
                ? MediaQuery.of(context).size.height / 35
                : MediaQuery.of(context).size.width / 35,
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
              iconSize: portrait
                  ? MediaQuery.of(context).size.height / 35
                  : MediaQuery.of(context).size.width / 35,
              onChanged: (Map<String, dynamic>? newValue) {
                setState(() {
                  dropDownValue = newValue!;
                  dateDropDownList = getDateDropDownList(newValue);
                });
              },
              items: boatList.map<DropdownMenuItem<Map<String, dynamic>>>(
                  (Map<String, dynamic> value) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: value,
                  child: Container(
                    width: portrait
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.height / 2,
                    child: AutoSizeText(
                      value["name"],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDateDropDown() {
    // returns the drop down of the dates associated with a specific yachts trips with the user
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: AutoSizeText(
              "Departure Date:",
              maxLines: 1,
              minFontSize: 3.0,
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            height: portrait
                ? MediaQuery.of(context).size.height / 35
                : MediaQuery.of(context).size.width / 35,
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
              iconSize: portrait
                  ? MediaQuery.of(context).size.height / 35
                  : MediaQuery.of(context).size.width / 35,
              onChanged: (Trip? newValue) {
                setState(() {
                  dateDropDownValue = newValue!;
                });
              },
              items: dateDropDownList.map<DropdownMenuItem<Trip>>((Trip value) {
                return DropdownMenuItem<Trip>(
                  value: value,
                  child: Container(
                    width: portrait
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.height / 2,
                    child: AutoSizeText(
                      value.charter ==
                              null
                          ? "You don't have adventures here yet."
                          : DateTime.parse(
                                      value.charter!.startDate!)
                                  .month
                                  .toString() +
                              "/" +
                              DateTime.parse(value.charter!.startDate!)
                                  .day
                                  .toString() +
                              "/" +
                              DateTime.parse(value.charter!.startDate!)
                                  .year
                                  .toString(),
                      maxLines: 1,
                      minFontSize: 3.0,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Trip> getDateDropDownList(Map<String, dynamic> boatMap) {
    // returns the list of dates to be displayed with the selected trip

    List<Trip> tempList = [];
    tripList.forEach((element) {
      if (element.boat!=null&&(element.boat!.boatId.toString() == boatMap["boatid"].toString() ||
          element.boat!.boatId.toString() == boatMap["boatId"].toString()) ){
        tempList.add(element);
      }
    });

    if (tempList.length == 0) {
      tempList = [Trip("", "", "", "", "", "", "", "" , "","")];
    }

    setState(() {
      dateDropDownValue = tempList[0];
    });

    return tempList;
  }

  List<Trip> sortTripList(List<Trip> tripList) {
    List<Trip> tempList = tripList;
    tempList.sort((a, b) =>
        DateTime.parse(b.tripDate!).compareTo(DateTime.parse(a.tripDate!)));

    return tempList;
  }

  Widget getCreateNoteButton() {
    // returns the button to create the note as it is
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            child: TextButton(
              onPressed: () {
                if (dateDropDownValue.charter != null) {
                  if ((dateDropDownValue.charter!.startDate!) != "") {
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
                "Create Note",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: AggressorColors.secondaryColor),
            ),
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
    return Image.asset(
      "assets/bannerimage.png",
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.scaleDown,
    );
  }

  Widget getPageTitle() {
    //returns the title of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Notes",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 30
                  : MediaQuery.of(context).size.width / 30,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getNotesSection() {
    //returns the section of the page that displays notes already made
    double textBoxSize = portrait
        ? MediaQuery.of(context).size.width / 4
        : MediaQuery.of(context).size.height / 4;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        color: Colors.white,
        child: notesList.length == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: .5,
                    color: Colors.grey,
                  ),
                  Container(
                    color: AggressorColors.accentYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: textBoxSize,
                            child:
                                Text("Adventure", textAlign: TextAlign.center),
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
    // returns the list item containing notes objects

    double textBoxSize = portrait
        ? MediaQuery.of(context).size.width / 4
        : MediaQuery.of(context).size.height / 4;
    noteList.clear();
    noteList.add(
      Container(
        width: double.infinity,
        color: AggressorColors.accentYellow,
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
                    child: Text("Adventure", textAlign: TextAlign.left),
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

    for (Note note in notesList) {
      note.user = widget.user;
      note.pageContext = context;
      note.callback = notesCallBack;
      noteList.add(note.getNoteRow(
        context,
        index,
      ));
      index++;
    }

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: noteList.length,
        itemBuilder: (context, position) {
          return noteList[position];
        });
  }

  Future<dynamic> getNotes() async {
    //downloads notes from aws.

    setState(() {
      loading = true;
    });
    if (!notesLoaded && online) {
      Map<String, Note> notesMap = <String, Note>{};

      List<dynamic> noteResponse =
          await AggressorApi().getNoteList(widget.user.userId!);

      for (var element in noteResponse) {
        notesMap[element["id"].toString()] = Note(
            element["id"].toString(),
            element["boatID"].toString(),
            element["destination"],
            element["startDate"],
            element["endDate"],
            element["preTripNotes"],
            element["postTripNotes"],
            element["misc"]??"",
            widget.user,
            pageContext,
            notesCallBack);
      }

      List<Note> tempNotes = [];
      notesMap.forEach((key, value) {
        if (value.boatId != null) {
          int insertAt = tripList.indexWhere((element) =>
              (element.boat != null && value.boatId != null) &&
              element.boat!.boatId! == value.boatId &&
              DateTime.parse(value.startDate!) ==
                  DateTime.parse(element.charter!.startDate!));
          if (insertAt != -1) {
            tripList[insertAt].note = value;
          }
        }
      });

      if (mounted) {
        setState(() {
          notesList = tempNotes;
          notesLoaded = true;
        });
        updateNotesCache();
      }
    } else {
      notesList = await NotesDatabaseHelper.instance.queryNotes();
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
    return "finished";
  }

  void updateNotesCache() async {
    //cleans and saves the notes to the database
    NotesDatabaseHelper notesDatabaseHelper = NotesDatabaseHelper.instance;
    try {
      await notesDatabaseHelper.deleteNotesTable();
    } catch (e) {
      print("no notes in the table");
    }

    for (var note in notesList) {
      await notesDatabaseHelper.insertNotes(note);
    }
  }

  Widget showErrorMessage() {
    // shows an error message if there is one
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
    // shows a loading line if the notes are being downloaded
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

  Widget showOffline() {
    // displays offline when the application does not have internet connection
    return online
        ? Container()
        : Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text(
                "Application is offline",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }

  VoidCallback notesCallBack() {
    // this callback ensures that notes are updated after a new one is created
    return (){
      setState(() {
        notesLoaded = false;
      });
    };
  }

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */

}
