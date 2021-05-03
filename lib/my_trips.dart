import 'dart:async';

import 'package:aggressor_adventures/aggressor_colors.dart';
import 'package:aggressor_adventures/agressor_api.dart';
import 'package:aggressor_adventures/trip.dart';
import 'package:aggressor_adventures/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:aggressor_adventures/agressor_api.dart';

class MyTrips extends StatefulWidget {
  MyTrips(this.user);

  User user;

  @override
  State<StatefulWidget> createState() => new myTripsState();
}

class myTripsState extends State<MyTrips> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  bool listLoading = false;
  List<Widget> pastTripsList;
  List<Widget> upcomingTripsList;
  Future tripListFuture;

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
    tripListFuture = AggressorApi().getReservationList(widget.user.contactId);
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

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Widget getForegroundView() {
    //this method returns a column containing the actual content of the page to be shown over the background image
    return FutureBuilder(
        future: tripListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Column(
              children: [
                getMapObject(),
                getPageTitle(),
                getSectionUpcomingTitle(),
                getUpcomingSection(false, getTripList(snapshot.data)[1]),
                getSectionPastTitle(),
                getPastSection(false, getTripList(snapshot.data)[0]),
              ],
            );
          } else {
            return Column(
              children: [
                getMapObject(),
                getPageTitle(),
                getSectionUpcomingTitle(),
                getUpcomingSection(true, null),
                getSectionPastTitle(),
                getPastSection(true, null),
              ],
            );
          }
        });
  }

  Widget getUpcomingSection(bool loading, List<Trip> upcomingTrips) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Container(
            color: Colors.white,
            child: loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : getUpcomingListViews(upcomingTrips)),
      ),
    );
  }

  Widget getPastSection(bool loading, List<Trip> pastTrips) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Stack(
        children: [
          Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height / 6.5,
              width: double.infinity,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : getPastTripListViews(pastTrips)),
        ],
      ),
    );
  }


  Widget getUpcomingListViews(List<Trip> pastTrips) {
    //returns the list item containing upcoming trip objects
    pastTrips.forEach((element) {
      upcomingTripsList.add(element.getUpcomingTripCard(context));
    });

    return ListView.builder(
        shrinkWrap: true,
        itemCount: upcomingTripsList.length,
        itemBuilder: (context, position) {
          return upcomingTripsList[position];
        });
  }
  
  Widget getPastTripListViews(List<Trip> pastTrips) {
    //returns the list item containing past trip objects
    int index = 0;
    pastTrips.forEach((element) {
      pastTripsList.add(element.getPastTripCard(context, index));
      index++;
    });

    return ListView.builder(
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
          "assets/tempbkg.png", //TODO replace with final graphic
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }
}
