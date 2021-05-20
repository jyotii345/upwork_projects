import 'dart:async';

import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:aggressor_adventures/classes/aggressor_api.dart';

class MyTrips extends StatefulWidget {
  MyTrips(this.user, this.tripList);

  final User user;
  final List<Trip> tripList;

  @override
  State<StatefulWidget> createState() => new myTripsState();
}

class myTripsState extends State<MyTrips> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  List<Widget> pastTripsList;
  List<Widget> upcomingTripsList;

  Completer<GoogleMapController> _controller =
      Completer(); //object for asyn map loading

  static const LatLng _center =
      const LatLng(0, 0); // coordinates for a center location

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    pastTripsList = [];
    upcomingTripsList = [];
  }

  /*
  Build
   */

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        getBackGroundImage(),
        getForegroundView(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */

  void _onMapCreated(GoogleMapController controller) { //TODO ios google maps install
    _controller.complete(controller);
  }

  Widget getForegroundView() {
    //this method returns a column containing the actual content of the page to be shown over the background image
    return ListView(
      children: [
        getMapObject(),
        getPageTitle(),
        getSectionUpcomingTitle(),
        getUpcomingSection(getTripList(widget.tripList)[1]),
        getSectionPastTitle(),
        getPastSection(getTripList(widget.tripList)[0]),
      ],
    );
  }

  Widget getUpcomingSection(List<Trip> upcomingTrips) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
          color: Colors.white,
          child: upcomingTrips.length == 0
              ? Center(
                  child: Text("You do not have any upcoming trips booked yet."),
                )
              : getUpcomingListViews(upcomingTrips)),
    );
  }

  Widget getPastSection(List<Trip> pastTrips) {
    double textBoxSize = MediaQuery.of(context).size.width / 4.3;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Container(
          color: Colors.white,
          child: pastTrips.length == 0
              ? Column(
                  children: [
                    Container(
                      height: .5,
                      color: Colors.grey,
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: textBoxSize,
                            child: Text("Conf#", textAlign: TextAlign.center),
                          ),
                          Spacer(
                            flex: 10,
                          ),
                          SizedBox(
                            width: textBoxSize,
                            child: Text("Yacht", textAlign: TextAlign.center),
                          ),
                          Spacer(
                            flex: 10,
                          ),
                          SizedBox(
                            width: textBoxSize,
                            child: Text(
                              "Embarkment Date",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: textBoxSize / 2,
                          ),
                          SizedBox(
                            width: textBoxSize / 2,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          Text("You do not have any past trips to view yet."),
                    ),
                  ],
                )
              : getPastTripListViews(pastTrips)),
    );
  }

  Widget getUpcomingListViews(List<Trip> upcomingTrips) {
    //returns the list item containing upcoming trip objects

    upcomingTripsList.clear();
    upcomingTrips.forEach((element) {
      upcomingTripsList.add(element.getUpcomingTripCard(context));
    });

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: upcomingTripsList.length,
        itemBuilder: (context, position) {
          return upcomingTripsList[upcomingTripsList.length - 1 - position];
        });
  }

  Widget getPastTripListViews(List<Trip> pastTrips) {
    //returns the list item containing past trip objects

    double textBoxSize = MediaQuery.of(context).size.width / 4.3;
    pastTripsList.clear();
    pastTripsList.add(
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
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: textBoxSize,
                  child: Text("Conf#", textAlign: TextAlign.center),
                ),
                Spacer(
                  flex: 10,
                ),
                SizedBox(
                  width: textBoxSize,
                  child: Text("Yacht", textAlign: TextAlign.center),
                ),
                Spacer(
                  flex: 10,
                ),
                SizedBox(
                  width: textBoxSize,
                  child: Text(
                    "Embarkment Date",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: textBoxSize / 2,
                ),
                SizedBox(
                  width: textBoxSize / 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    int index = 0;
    pastTrips.forEach((element) {
      pastTripsList.add(element.getPastTripCard(context, index));
      index++;
    });

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pastTripsList.length,
        itemBuilder: (context, position) {
          return pastTripsList[position];
        });
  }

  Widget getSectionPastTitle() {
    //returns the past trips title and divider
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Past Trips",
              style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.height / 45,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Container(
            color: AggressorColors.secondaryColor,
            height: 1.5,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  List<List<Trip>> getTripList(List<Trip> tripList) {
    //returns the list of all active trips and sorts them by upcoming or past
    List<Trip> pastList = [];
    List<Trip> upcomingList = [];

    double textBoxSize = MediaQuery.of(context).size.width / 4.3;
    tripList.sort((a, b) =>
        DateTime.parse(b.tripDate).compareTo(DateTime.parse(a.tripDate)));

    tripList.forEach((element) {
      if (DateTime.parse(element.tripDate).isBefore(DateTime.now())) {
        pastList.add(element);
      } else {
        upcomingList.add(element);
      }
    });

    return [pastList, upcomingList];
  }

  Widget getSectionUpcomingTitle() {
    //returns the upcoming trips title and divider
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Upcoming Trips",
              style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.height / 45,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Container(
            color: AggressorColors.secondaryColor,
            height: 1.5,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  Widget getPageTitle() {
    //returns the the text label for the overall page
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
        child: Text(
          "Manage My Trips",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 30,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getMapObject() {
    //TODO change map size to full world view, potential switch away from google maps
    //returns a box to take up the top fifth of the available space in the view showing a google maps object. The map is locked from moving it.
    return SizedBox(
      width: MediaQuery.of(context).size.width, // or use fixed size like 200
      height: MediaQuery.of(context).size.height / 5,
      child: GoogleMap(
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
        ),
      ),
    );
  }

  Widget getBackGroundImage() {
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
}
