import 'dart:io';

import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MyTrips extends StatefulWidget {
  MyTrips(this.user);

  final User user;

  @override
  State<StatefulWidget> createState() => new MyTripsState();
}

class MyTripsState extends State<MyTrips>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  /*
  instance vars
   */

  List<Widget> pastTripsList;
  List<Widget> upcomingTripsList;

  bool timerStarted = false;
  int sliderIndex = 0;

// coordinates for a center location

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    sliderImageTimer();
    pastTripsList = [];
    upcomingTripsList = [];
  }

  /*
  Build
   */

  @override
  Widget build(BuildContext context) {
    super.build(context);
    homePage = true;
    return PinchToZoom(
      OrientationBuilder(
        builder: (context, orientation) {
          portrait = orientation == Orientation.portrait;
          return Stack(
            children: [
              getBackGroundImage(),
              getForegroundView(),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */
  Widget getForegroundView() {
    //this method returns a column containing the actual content of the page to be shown over the background image
    return ListView(
      children: [
        showOffline(),
        getSliderImages(),
        getPageTitle(),
        getSectionUpcomingTitle(),
        getUpcomingSection(getTripList(tripList)[1]),
        getSectionPastTitle(),
        getPastSection(getTripList(tripList)[0]),
      ],
    );
  }

  Widget getSliderImages() {
    //returns slider images on top of the page
    return IntrinsicHeight(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: sliderImageList.length == 0
                ? Container()
                : Stack(
                    children: [
                      Image.file(
                        File(
                          sliderImageList[sliderIndex == 0
                              ? sliderImageList.length - 1
                              : sliderIndex - 1]["filePath"],
                        ),
                        fit: BoxFit.scaleDown,
                      ),
                      FadeInImage(
                        fit: BoxFit.scaleDown,
                        placeholder: FileImage(
                          File(sliderImageList[sliderIndex == 0
                              ? sliderImageList.length - 1
                              : sliderIndex - 1]["filePath"]),
                        ),
                        image: FileImage(
                          File(sliderImageList[sliderIndex]["filePath"]),
                        ),
                      ),
                    ],
                  ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  if (sliderIndex + 1 < sliderImageList.length) {
                    setState(() {
                      sliderIndex++;
                    });
                  } else {
                    setState(() {
                      sliderIndex = 0;
                    });
                  }
                },
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white70,
                  size: portrait
                      ? MediaQuery.of(context).size.width / 7.5
                      : MediaQuery.of(context).size.height / 7.5,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  if (sliderIndex > 0) {
                    setState(() {
                      sliderIndex--;
                    });
                  } else {
                    setState(() {
                      sliderIndex = sliderImageList.length - 1;
                    });
                  }
                },
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white70,
                  size: portrait
                      ? MediaQuery.of(context).size.width / 7.5
                      : MediaQuery.of(context).size.height / 7.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getUpcomingSection(List<Trip> upcomingTrips) {
    //returns either the no upcoming trips dialogue or the listview
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
          color: Colors.white,
          child: upcomingTrips.length == 0
              ? Center(
                  child: Text(
                      "You do not have any upcoming adventures booked yet."),
                )
              : getUpcomingListViews(upcomingTrips)),
    );
  }

  Widget getPastSection(List<Trip> pastTrips) {
    //returns either the no past trips dialogue or the listview
    double textBoxSize = MediaQuery.of(context).size.width / 4.3;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Container(
          color: Colors.white,
          child: pastTrips.length == 0
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
                            child:
                                Text("Adventure", textAlign: TextAlign.center),
                          ),
                          Spacer(
                            flex: 10,
                          ),
                          SizedBox(
                            width: textBoxSize,
                            child: Text(
                              "Start Date",
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
                    Flexible(
                      child: Text(
                          "You do not have any past adventures to view yet."),
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
      upcomingTripsList
          .add(element.getUpcomingTripCard(context, refresh, portrait));
    });

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: upcomingTripsList.length,
        itemBuilder: (context, position) {
          return upcomingTripsList[upcomingTripsList.length - 1 - position];
        });
  }

  VoidCallback refresh() {
    setState(() {});
  }

  Widget getPastTripListViews(List<Trip> pastTrips) {
    //returns the list item containing past trip objects

    double textBoxSize = MediaQuery.of(context).size.width / 4.3;
    pastTripsList.clear();
    pastTripsList.add(
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
                  child: Text("Adventure", textAlign: TextAlign.center),
                ),
                Spacer(
                  flex: 10,
                ),
                SizedBox(
                  width: textBoxSize,
                  child: Text(
                    "Start Date",
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
      element.user = widget.user;
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
              "Past Adventures",
              style: TextStyle(
                color: Colors.black,
                fontSize: portrait
                    ? MediaQuery.of(context).size.height / 45
                    : MediaQuery.of(context).size.width / 45,
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
              "Upcoming Adventures",
              style: TextStyle(
                color: Colors.black,
                fontSize: portrait
                    ? MediaQuery.of(context).size.height / 45
                    : MediaQuery.of(context).size.width / 45,
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

  void sliderImageTimer() async {
    try {
      if (!timerStarted) {
        setState(() {
          timerStarted = true;
        });
        while (true) {
          await Future.delayed(Duration(seconds: 5));
          if (sliderIndex + 1 < sliderImageList.length) {
            setState(() {
              sliderIndex++;
            });
          } else {
            setState(() {
              sliderIndex = 0;
            });
          }
        }
      }
    } catch (e) {}
  }

  Widget getPageTitle() {
    //returns the the text label for the overall page
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
        child: Text(
          "Manage My Adventures",
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

  Widget showOffline() {
    //displays offline when the application does not have internet connection
    return online
        ? Container()
        : Container(
            color: Colors.red,
            child: Text(
              "Application is offline",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
  }
}
