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
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:url_launcher/url_launcher.dart';

class EditNote extends StatefulWidget {
  EditNote(
    this.user,
    this.note,
  );

  final User user;
  final Note note;

  @override
  State<StatefulWidget> createState() => new EditNoteState();
}

class EditNoteState extends State<EditNote> {
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
    setText();

    popDistance = 2;
  }

  /*
  Build
   */
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: poppingPage,
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(),
      bottomNavigationBar: getBottomNavigationBar(),
      body: Stack(
        children: [
          getBackgroundImage(),
          getPageForm(),
          getBannerImage(),
          getLoading(),
        ],
      ),),
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

  void handleBottomNavigation(int index) {
    currentIndex = index - 1;
    Navigator.pop(context);
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
            Opacity(opacity: 0, child:getBannerImage(),),
              getPageTitle(),
              getYachtInformation(),
              getDepartureDate(),
              //getReturnDate(),
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
        "Save Note",
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
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: Align(
              alignment: Alignment.topLeft,
              child: AutoSizeText(
                "Pre-Adventure Notes:",
                maxLines: 1, minFontSize:3.0,
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

      var res = await AggressorApi().updateNote(
        widget.note.startDate,
        widget.note.endDate,
        await preNotesController.getText(),
        await postNotesController.getText(),
        await miscNotesController.getText(),
        widget.note.boatId,
        widget.user.userId,
        widget.note.id,
      );

      setState(() {
        loading = false;
        notesLoaded = false;
      });

      widget.note.callback();

      var count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    } else {
      setState(() {
        loading = true;
      });

      OfflineDatabaseHelper.instance.insertOffline(
          {'id': widget.note.id, 'type': 'note', 'action': 'edit'});

      await NotesDatabaseHelper.instance.deleteNotes(widget.note.id);
      await NotesDatabaseHelper.instance.insertNotes(Note(
          widget.note.id,
          widget.note.boatId,
          widget.note.destination,
          widget.note.startDate,
          widget.note.endDate,
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
      widget.note.callback();
      var count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
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
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: Align(
              alignment: Alignment.topLeft,
              child: AutoSizeText(
                "Post-Adventure Notes:",
                maxLines: 1, minFontSize:3.0,
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
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: Align(
              alignment: Alignment.topLeft,
              child: AutoSizeText(
                "Miscellaneous Adventure Notes:",
                maxLines: 1, minFontSize:3.0,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: AutoSizeText(
              "Destination:",
             maxLines: 1, minFontSize:3.0,
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            height: portrait
                ? MediaQuery.of(context).size.height / 45
                : MediaQuery.of(context).size.width / 45,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: Container(
              height: portrait
                  ? MediaQuery.of(context).size.height / 45
                  : MediaQuery.of(context).size.width / 45,
              width: portrait
                  ? MediaQuery.of(context).size.width / 2 -
                      MediaQuery.of(context).size.height / 40 -
                      10
                  : MediaQuery.of(context).size.height / 2 -
                      MediaQuery.of(context).size.width / 40 -
                      10,
              child: AutoSizeText(
                widget.note.destination,
                maxLines: 1, minFontSize:3.0,
                textAlign: TextAlign.center,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: AutoSizeText(
              "Departure Date:",
              maxLines: 1, minFontSize:3.0,
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            height: portrait
                ? MediaQuery.of(context).size.height / 45
                : MediaQuery.of(context).size.width / 45,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: AutoSizeText(
              widget.note.startDate.split("-")[1] + "/" + widget.note.startDate.split("-")[2] + "/" + widget.note.startDate.split("-")[0],
              maxLines: 1, minFontSize:3.0,
              textAlign: TextAlign.center,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: AutoSizeText(
              "Return Date",
              maxLines: 1, minFontSize:3.0,
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            height: portrait
                ? MediaQuery.of(context).size.height / 45
                : MediaQuery.of(context).size.width / 45,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: Container(
              height: portrait
                  ? MediaQuery.of(context).size.height / 45
                  : MediaQuery.of(context).size.width / 45,
              width: portrait
                  ? MediaQuery.of(context).size.width / 2 -
                      MediaQuery.of(context).size.height / 40 -
                      10
                  : MediaQuery.of(context).size.height / 2 -
                      MediaQuery.of(context).size.width / 40 -
                      10,
              child: Text(
                widget.note.endDate,
                style: TextStyle(
                    fontSize: portrait
                        ? portrait
                            ? MediaQuery.of(context).size.height / 45
                            : MediaQuery.of(context).size.width / 45 - 4
                        : MediaQuery.of(context).size.width / 45 - 4),
                textAlign: TextAlign.center,
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

  void setText() async {
    await Future.delayed(Duration(milliseconds: 1000));

    preNotesController.insertHtml(widget.note.preTripNotes);
    postNotesController.insertHtml(widget.note.postTripNotes);
    miscNotesController.insertHtml(widget.note.miscNotes);
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
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          "Edit Note",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 26
                  : MediaQuery.of(context).size.width / 26,
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

  Future<bool> poppingPage() {
    setState(() {
      popDistance = 1;
    });
    return new Future.value(true);
  }
}
