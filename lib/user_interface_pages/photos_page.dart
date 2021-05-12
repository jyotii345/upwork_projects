import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Photos extends StatefulWidget {
  Photos(this.tripList);

  final List<Trip> tripList;

  @override
  State<StatefulWidget> createState() => new PhotosState();
}

class PhotosState extends State<Photos> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  Trip dropDownValue, selectionTrip;
  String departureDate = "";
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

  Widget getDestinationDropdown(List<Trip> tripList) {
    sortedTripList = [selectionTrip];
    tripList = sortTripList(tripList);
    tripList.forEach((element) {
      sortedTripList.add(element);
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Destination:",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 35,
            width: MediaQuery.of(context).size.width / 1.75,
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
              iconSize: MediaQuery.of(context).size.height / 35,
              onChanged: (Trip newValue) {
                setState(() {
                  dropDownValue = newValue;
                  departureDate = newValue.tripDate;
                });
              },
              items: sortedTripList.map<DropdownMenuItem<Trip>>((Trip value) {
                return DropdownMenuItem<Trip>(
                  value: value,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      value.detailDestination,
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
        ],
      ),
    );
  }

  List<Trip> sortTripList(List<Trip> tripList) {
    List<Trip> tempList = tripList;
    tempList.sort((a, b) =>
        DateTime.parse(b.tripDate).compareTo(DateTime.parse(a.tripDate)));

    return tempList;
  }

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
            getCreateNewGallery(),
            getMyGalleries(), //TODO finish my galleries listview
          ],
        ),
      ),
    );
  }

  Widget getDepartureInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Departure Date:",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height / 35,
              width: MediaQuery.of(context).size.width / 1.75,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Text(
                departureDate,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 40 - 4),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget getUploadPhotosButton() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height / 4,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Upload Photos",
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
              backgroundColor: AggressorColors.secondaryColor),
        ),
      ],
    );
  }

  Widget getCreateNewGallery() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CREATE NEW GALLERY",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: MediaQuery.of(context).size.height / 35,
                fontWeight: FontWeight.bold),
          ),
          getDestinationDropdown(widget.tripList),
          getDepartureInformation(),
          getUploadPhotosButton(),
        ],
      ),
    );
  }

  Widget getMyGalleries() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MY GALLERIES",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: MediaQuery.of(context).size.height / 35,
                fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Photos",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
