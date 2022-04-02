import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/note.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/user_interface_pages/notes_edit_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'file_trip_page.dart';

class ViewNote extends StatefulWidget {
  ViewNote(
    this.user,
    this.note,
  );

  final User user;
  final Note note;

  @override
  State<StatefulWidget> createState() => new ViewNoteState();
}

class ViewNoteState extends State<ViewNote> {
  /*
  instance vars
   */

  bool loading = false;

  /*
  initState
   */
  @override
  void initState() {
    print("notes view page");
    super.initState();
    popDistance = 1;
  }

  /*
  Build
   */
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: poppingPage,
      child: PinchToZoom(
        OrientationBuilder(
          builder: (context, orientation) {
            portrait = orientation == Orientation.portrait;
            return Scaffold(
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
              ),
            );
          },
        ),
      ),
    );
  }

  /*
  Self implemented
   */

  makeCall() async {
    //calls the given number from the application
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  void handleBottomNavigation(int index) {
    //handles what the application does when the bottom navigation bar is clicked
    currentIndex = index - 1;
    Navigator.pop(context);
  }

  Widget getPageForm() {
    //returns the main contents of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: ListView(
            children: [
              Opacity(
                opacity: 0,
                child: getBannerImage(),
              ),
              getPageTitle(),
              getYachtInformation(),
              getDepartureDate(),
              //getReturnDate(),
              getPreTripTitle(),
              getPreTripNotes(),
              getPostTripTitle(),
              getPostTripNotes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPreTripTitle() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AutoSizeText(
        "Pre-Adventure Notes:",
        maxLines: 1,
        minFontSize: 3.0,
      ),
    );
  }

  Widget getPostTripTitle() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AutoSizeText(
        "Post-Adventure Notes:",
        maxLines: 1,
        minFontSize: 3.0,
      ),
    );
  }

  Widget getPreTripNotes() {
    //returns the pre trip notes portion of the page
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: portrait
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.width / 3,
        // decoration: ShapeDecoration(
        //   shape: RoundedRectangleBorder(
        //     side: BorderSide(width: 1.0, style: BorderStyle.solid),
        //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //   ),
        // ),
        child: Html(
          data: widget.note.preTripNotes,
        ),
      ),
    );
  }

  Widget getPostTripNotes() {
    //returns the post trip notes portion of the page
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: portrait
            ? MediaQuery.of(context).size.height / 3
            : MediaQuery.of(context).size.width / 3,
        // decoration: ShapeDecoration(
        //   shape: RoundedRectangleBorder(
        //     side: BorderSide(width: 1.0, style: BorderStyle.solid),
        //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //   ),
        // ),
        child: Html(
          data: widget.note.postTripNotes,
        ),
      ),
    );
  }

  Widget getYachtInformation() {
    //returns the information about the yacht and trip the notes are saved for
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
              maxLines: 1,
              minFontSize: 3.0,
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
                maxLines: 1,
                minFontSize: 3.0,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDepartureDate() {
    //returns the date the trip the note is for begins
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
              maxLines: 1,
              minFontSize: 3.0,
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
              widget.note.startDate.split("-")[1] +
                  "/" +
                  widget.note.startDate.split("-")[2] +
                  "/" +
                  widget.note.startDate.split("-")[0],
              maxLines: 1,
              minFontSize: 3.0,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget getReturnDate() {
    //returns the date the trip the note is for ends
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: Text(
              "Return Date",
              style: TextStyle(
                  fontSize: portrait
                      ? MediaQuery.of(context).size.height / 45 - 4
                      : MediaQuery.of(context).size.width / 45 - 4),
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
                widget.note.startDate,
                style: TextStyle(
                    fontSize: portrait
                        ? MediaQuery.of(context).size.height / 45 - 4
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
    //returns the title for the page
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "View Note",
                  style: TextStyle(
                      color: AggressorColors.primaryColor,
                      fontSize: portrait
                          ? MediaQuery.of(context).size.height / 30
                          : MediaQuery.of(context).size.width / 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                iconSize: portrait
                    ? MediaQuery.of(context).size.height / 20
                    : MediaQuery.of(context).size.width / 20,
                icon: Image.asset("assets/filesblue.png"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FilesTripPage(widget.user, widget.note.startDate),
                    ),
                  );
                },
                color: Colors.white,
              ),
              Container(
                height: portrait
                    ? MediaQuery.of(context).size.height / 20
                    : MediaQuery.of(context).size.width / 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AggressorColors.secondaryColor),
                child: IconButton(
                  iconSize: portrait
                      ? MediaQuery.of(context).size.height / 35
                      : MediaQuery.of(context).size.width / 35,
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditNote(widget.user, widget.note)));
                  },
                  color: Colors.white,
                ),
              ),
            ],
          )),
    );
  }

  Widget getLoading() {
    //if data is loading it displays the loading icon
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }

  Future<bool> poppingPage() {
    setState(() {
      popDistance = 0;
    });
    return new Future.value(true);
  }
}
