import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_summernote/flutter_summernote.dart';

class Notes extends StatefulWidget {
  Notes(this.user, this.tripList);

  User user;
  List<Trip> tripList;

  @override
  State<StatefulWidget> createState() => new NotesState();
}

class NotesState extends State<Notes> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */
  String departureDate = "";
  String returnDate = "";
  Trip dropDownValue;

  Trip selectionTrip;

  GlobalKey<FlutterSummernoteState> preNotesEditor = GlobalKey();
  GlobalKey<FlutterSummernoteState> postNotesEditor = GlobalKey();
  GlobalKey<FlutterSummernoteState> miscNotesEditor = GlobalKey();

  List<Trip> sortedTripList;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    selectionTrip =
        Trip(DateTime.now().toString(), "", "", "", " -- SELECT -- ", "", "");
    selectionTrip.detailDestination = " -- SELECT -- ";
    dropDownValue = selectionTrip;
  }

  /*
  Build
   */
  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
            ),
            getPageTitle(),
            getDestinationDropdown(widget.tripList),
            getDepartureDate(),
            getReturnDate(),
            getPreTripNotes(),
            getPostTripNotes(),
            getMiscNotes(),
            getSaveNotesButton(),
          ],
        ),
      ),
    );
  }

  Widget getSaveNotesButton() {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Save My Notes",
        style: TextStyle(color: Colors.white),
      ),
      style:
          TextButton.styleFrom(backgroundColor: AggressorColors.secondaryColor),
    );
  }

  Widget getPreTripNotes() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height / 6,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Pre-Trip Notes:",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width / 1.525,
          child: FlutterSummernote(
            //TODO fix text size
            key: preNotesEditor,
            hasAttachment: false,
            customToolbar: """
                            [
                            ]
                           """,
            showBottomToolbar: false,
          ),
        ),
      ],
    );
  }

  Widget getPostTripNotes() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height / 6,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Post-Trip Notes:",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width / 1.525,
          child: FlutterSummernote(
            //TODO fix text size
            key: postNotesEditor,
            hasAttachment: false,
            customToolbar: """
          [
          ]
        """,
            showBottomToolbar: false,
          ),
        ),
      ],
    );
  }

  Widget getMiscNotes() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height / 6,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Post-Trip Notes:",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width / 1.525,
          child: FlutterSummernote(
            //TODO fix text size
            key: miscNotesEditor,
            hasAttachment: false,
            customToolbar: """
          [
          ]
        """,
            showBottomToolbar: false,
          ),
        ),
      ],
    );
  }

  Widget getDestinationDropdown(List<Trip> tripList) {
    sortedTripList = [selectionTrip];
    tripList = sortTripList(tripList);
    tripList.forEach((element) {
      sortedTripList.add(element);
    });

    return Row(
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
        Container(
          height: MediaQuery.of(context).size.height / 45,
          width: MediaQuery.of(context).size.width / 2,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton<Trip>(
            underline: Container(),
            value: dropDownValue,
            elevation: 0,
            isExpanded: true,
            iconSize: MediaQuery.of(context).size.height / 40,
            onChanged: (Trip newValue) {
              setState(() {
                dropDownValue = newValue;
                departureDate = newValue.tripDate;
                returnDate =
                    "not implemented"; //TODO place return date here when uploaded
              });
            },
            items: sortedTripList.map<DropdownMenuItem<Trip>>((Trip value) {
              return DropdownMenuItem<Trip>(
                value: value,
                child: Container(
                  height: MediaQuery.of(context).size.height / 45,
                  width: MediaQuery.of(context).size.width / 2 -
                      MediaQuery.of(context).size.height / 40 -
                      10,
                  child: Text(
                    value.detailDestination,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 45 - 4),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<Trip> sortTripList(List<Trip> tripList) {
    List<Trip> tempList = tripList;
    tempList.sort((a, b) =>
        DateTime.parse(b.tripDate).compareTo(DateTime.parse(a.tripDate)));

    return tempList;
  }

  Widget getDepartureDate() {
    return Row(
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
        Container(
          height: MediaQuery.of(context).size.height / 45,
          width: MediaQuery.of(context).size.width / 2,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: Text(
            departureDate,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 45 - 4),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget getReturnDate() {
    return Row(
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
        Container(
          height: MediaQuery.of(context).size.height / 45,
          width: MediaQuery.of(context).size.width / 2,
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
              returnDate,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
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
          "assets/tempbkg.png", //TODO replace with final graphic
          fit: BoxFit.fill,
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: Text(
                "My Trip Notes",
                style: TextStyle(
                    color: AggressorColors.primaryColor,
                    fontSize: MediaQuery.of(context).size.height / 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
                child: Image(image: AssetImage("assets/files.png")),
                onPressed: () {
                  //TODO implement button function
                }),
            TextButton(
                child: Image(image: AssetImage("assets/photos.png")),
                onPressed: () {
                  //TODO implement button function
                }),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
