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

  List<Widget> pastTripsList;

  Widget pastTableHeader = Container(
    width: double.infinity,
    color: Colors.grey[300],
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Conf#"),
        Text("Yacht"),
        Text("Embarkment Date")
      ],
    ),
  );

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

    pastTripsList = [pastTableHeader];
    getTripList();
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
    return Column(
      children: [
        getMapObject(),
        getPageTitle(),
        getSectionUpcomingTitle(),
        getUpcomingSection(),
        getSectionPastTitle(),
        getPastSection(),
      ],
    );
  }

  Widget getUpcomingSection() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getPastSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 6.5,
            width: double.infinity,
          ),
          getPastTripListViews(),
        ],
      ),
    );
  }

  Widget getPastTripListViews() {
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


  Future<void> getTripList() async{
    var tripList = AggressorApi().getReservationList(widget.user.contactId);
    print(tripList);
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
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
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
          "assets/tempbkg.png", //TODO replace remp images with final images
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }
}
