import 'dart:ui';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/note.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/notes_database.dart';
import 'package:aggressor_adventures/databases/offline_database.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNotes extends StatefulWidget {
  AddNotes(
    this.user,
    this.noteTrip,
    this.callback,
  );

  final User user;
  final Trip noteTrip;
  final VoidCallback callback;

  @override
  State<StatefulWidget> createState() => new AddNotesState();
}

class AddNotesState extends State<AddNotes> {
  /*
  instance vars
   */

  int pageIndex = 1;
  String departureDate = "";
  String returnDate = "";
  Trip dropDownValue;

  HtmlEditorController preNotesController = HtmlEditorController();
  HtmlEditorController postNotesController = HtmlEditorController();
  HtmlEditorController miscNotesController = HtmlEditorController();

  bool loading = false;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
  }

  /*
  Build
   */
  @override
  Widget build(BuildContext context) {
    popDistance = 1;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(),
      bottomNavigationBar: getBottomNavigationBar(),
      body: Stack(
        children: [
          getBackgroundImage(),
          getPageForm(),
          Container(
            height: MediaQuery.of(context).size.height / 7 + 4,
            width: double.infinity,
            color: AggressorColors.secondaryColor,
          ),
          getBannerImage(),
          getLoading(),
        ],
      ),
    );
  }

  /*
  Self implemented
   */

  makeCall() async {
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget getPageForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 7,
              ),
              getPageTitle(),
              getYachtInformation(),
              getYachtInformation(),
              getDepartureDate(),
              getReturnDate(),
              getPreTripNotes(),
              getPostTripNotes(),
              getMiscNotes(),
              getSaveNotesButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSaveNotesButton() {
    return TextButton(
      onPressed: () {
        uploadNote();
      },
      child: Text(
        "Create this Note",
        style: TextStyle(color: Colors.white),
      ),
      style:
          TextButton.styleFrom(backgroundColor: AggressorColors.secondaryColor),
    );
  }

  Widget getPreTripNotes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Pre-Adventure Notes:",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 45 - 4),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: HtmlEditor(
                controller: preNotesController,
                htmlEditorOptions:
                    HtmlEditorOptions(hint: "Pre-Adventure notes"),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.custom,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void uploadNote() async {
    if (online) {
      setState(() {
        loading = true;
      });
      String startDate = formatDate(
          DateTime.parse(widget.noteTrip.charter.startDate),
          [yyyy, '-', mm, '-', dd]);

      String endDate = formatDate(
          DateTime.parse(widget.noteTrip.charter.startDate)
              .add(Duration(days: int.parse(widget.noteTrip.charter.nights))),
          [yyyy, '-', mm, '-', dd]);

      var res = await AggressorApi().saveNote(
          startDate,
          endDate,
          await preNotesController.getText(),
          await postNotesController.getText(),
          await miscNotesController.getText(),
          widget.noteTrip.boat.boatId,
          widget.user.userId);

      setState(() {
        loading = false;
        notesLoaded = false;
      });
      widget.callback();
      Navigator.pop(context);
    } else {
      setState(() {
        loading = true;
      });
      String startDate = formatDate(
          DateTime.parse(widget.noteTrip.charter.startDate),
          [yyyy, '-', mm, '-', dd]);

      String endDate = formatDate(
          DateTime.parse(widget.noteTrip.charter.startDate)
              .add(Duration(days: int.parse(widget.noteTrip.charter.nights))),
          [yyyy, '-', mm, '-', dd]);

      OfflineDatabaseHelper.instance.insertOffline({
        'id': widget.noteTrip.boat.boatId + "_" + startDate.toString(),
        'type': 'note',
        'action': 'add',
      });

      NotesDatabaseHelper.instance.insertNotes(Note(
          widget.noteTrip.boat.boatId + "_" + startDate.toString(),
          widget.noteTrip.boat.boatId,
          widget.noteTrip.destination,
          startDate,
          endDate,
          await preNotesController.getText(),
          await postNotesController.getText(),
          await miscNotesController.getText(),
          null,
          null,
          null));
      setState(() {
        loading = false;
        notesLoaded = false;
      });
      widget.callback();
      Navigator.pop(context);

      setState(() {
        loading = false;
      });
    }
  }

  Widget getPostTripNotes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Post-Adventure Notes:",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 45 - 4),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: HtmlEditor(
                controller: postNotesController,
                htmlEditorOptions:
                    HtmlEditorOptions(hint: "Post-Adventure notes"),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.custom,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMiscNotes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Miscellaneous Adventure Notes:",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 45 - 4),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: HtmlEditor(
                controller: miscNotesController,
                htmlEditorOptions:
                    HtmlEditorOptions(hint: "Miscellaneous adventure notes"),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.custom,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getYachtInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Destination:",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 45,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 45,
                width: MediaQuery.of(context).size.width / 2 -
                    MediaQuery.of(context).size.height / 40 -
                    10,
                child: Text(
                  widget.noteTrip.boat.name,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 45 - 4),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDepartureDate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Departure Date:",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 45,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Text(
                DateTime.parse(widget.noteTrip.charter.startDate)
                        .month
                        .toString() +
                    "/" +
                    DateTime.parse(widget.noteTrip.charter.startDate)
                        .day
                        .toString() +
                    "/" +
                    DateTime.parse(widget.noteTrip.charter.startDate)
                        .year
                        .toString(),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 45 - 4),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getReturnDate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Return Date",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 45,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 45,
                width: MediaQuery.of(context).size.width / 2 -
                    MediaQuery.of(context).size.height / 40 -
                    10,
                child: Text(
                  DateTime.parse(widget.noteTrip.charter.startDate)
                          .add(Duration(
                              days: int.parse(widget.noteTrip.charter.nights)))
                          .month
                          .toString() +
                      "/" +
                      DateTime.parse(widget.noteTrip.charter.startDate)
                          .add(Duration(
                              days: int.parse(widget.noteTrip.charter.nights)))
                          .day
                          .toString() +
                      "/" +
                      DateTime.parse(widget.noteTrip.charter.startDate)
                          .add(Duration(
                              days: int.parse(widget.noteTrip.charter.nights)))
                          .year
                          .toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 45 - 4),
                  textAlign: TextAlign.center,
                ),
              ),
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
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/pagebackground.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            color: Colors.white.withOpacity(.6),
          ),
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
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          "Add Note",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 26,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getLoading() {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }
}
