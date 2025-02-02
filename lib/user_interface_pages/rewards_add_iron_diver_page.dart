import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/material.dart';
import '../classes/aggressor_colors.dart';

class AddIronDiver extends StatefulWidget {
  AddIronDiver(this.user, this.refreshState);

  final User user;
  final VoidCallback refreshState;

  @override
  State<StatefulWidget> createState() => new AddIronDiverState();
}

class AddIronDiverState extends State<AddIronDiver> {
  /*
  instance vars
   */

  int pageIndex = 3;
  String errorMessage = "";

  Map<String, dynamic> dropDownValue = {};

  List<Trip> dateDropDownList = [];
  Trip dateDropDownValue = Trip("", "", "", "", "", "", "", "", "", "");
  bool loading = false;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    dropDownValue = boatList[0];
    dateDropDownValue = Trip("", "", "", "", "", "", "", "", "", "");
    dateDropDownValue.charter = Charter("", "", "", "", "", "", "", "", "");

    popDistance = 1;
  }

  /*
  Build
   */

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: poppingPage,
      child: OrientationBuilder(
        builder: (context, orientation) {
          portrait = orientation == Orientation.portrait;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: getAppBar(),
            bottomNavigationBar: getBottomNavigationBar(),
            body: Stack(
              children: [
                getBackgroundImage(),
                getWhiteOverlay(),
                getPageForm(),
                showLoading(),
              ],
            ),
          );
        },
      ),
    );
  }

  /*
  Self implemented
   */

  Widget getWhiteOverlay() {
    //returns a white background on the application
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget getPageForm() {
    //returns the main contents of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListView(
        children: [
          getBannerImage(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getPageTitle(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getYachtDropDown(boatList),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getDateDropDown(),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: getAddButton(),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: showErrorMessage(),
          ),
        ],
      ),
    );
  }

  Widget getAddButton() {
    //returns the add button to upload an iron diver award
    return Row(
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
            onPressed: addIronDiver,
            child: Text(
              "Add Iron Diver Award",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: AggressorColors.secondaryColor),
          ),
        ),
      ],
    );
  }

  void addIronDiver() async {
    //uploads the new iron diver to the API if the award is being given if the trip is valid
    setState(() {
      loading = true;
    });

    if (dropDownValue["name"] == " -- SELECT -- " ||
        dateDropDownValue.charter == null ||
        dateDropDownValue.charter!.startDate == "") {
      setState(() {
        errorMessage = "You must select a trip to add an Iron Diver.";
      });
    } else {
      var response = await AggressorApi().saveIronDiver(
          widget.user.userId.toString(), dropDownValue["boatid"].toString());

      if (response["status"].toString().toLowerCase() == "success") {
        widget.refreshState();
        Navigator.pop(context);
      } else {
        setState(() {
          errorMessage = "Error adding the Iron Diver Award, please try again.";
        });
      }
    }

    setState(() {
      ironDiversLoaded = false;
      loading = false;
    });
  }

  Widget getYachtDropDown(List<Map<String, dynamic>> boatList) {
    //returns a drop down of all yachts that an adventure is associated with

    List<Map<String, dynamic>> displayList = [];
    boatList.forEach((element) {
      if (element["iron_divers"] != "no") {
        displayList.add(element);
      }
    });
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: Text(
              "Adventure:",
              style: TextStyle(
                  fontSize: portrait
                      ? MediaQuery.of(context).size.height / 50
                      : MediaQuery.of(context).size.width / 50),
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            child: Container(
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
                items: displayList.map<DropdownMenuItem<Map<String, dynamic>>>(
                    (Map<String, dynamic> value) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: value,
                    child: Container(
                      width: portrait
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.height / 2,
                      child: Text(
                        value["name"],
                        style: TextStyle(
                            fontSize: portrait
                                ? MediaQuery.of(context).size.height / 40 - 4
                                : MediaQuery.of(context).size.width / 40 - 4),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDateDropDown() {
    //returns a drop down of all dates when a trip is on a particular yacht

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: Text(
              "DepartureDate:",
              style: TextStyle(
                  fontSize: portrait
                      ? MediaQuery.of(context).size.height / 50
                      : MediaQuery.of(context).size.width / 50),
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            child: Container(
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
                items:
                    dateDropDownList.map<DropdownMenuItem<Trip>>((Trip value) {
                  return DropdownMenuItem<Trip>(
                    value: value,
                    child: Container(
                      color: value.charter == null
                          ? AggressorColors.accentYellow
                          : null,
                      width: portrait
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.height / 2,
                      child: Text(
                        value.charter == null
                            ? "You have no adventures here yet."
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
                        style: TextStyle(
                            fontSize: portrait
                                ? MediaQuery.of(context).size.height / 40 - 4
                                : MediaQuery.of(context).size.width / 40 - 4),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Trip> getDateDropDownList(Map<String, dynamic> boatMap) {
    //generates the list of dates a trip is scheduled on a particular yacht
    List<Trip> tempList = [];
    tripList.forEach((element) {
      if (element.boat!.boatId.toString() == boatMap["boatid"].toString()) {
        tempList.add(element);
      }
    });

    if (tempList.length == 0) {
      tempList = [Trip("", "", "", "", "", "", "", "", "", "")];
    }

    setState(() {
      dateDropDownValue = tempList[0];
    });

    return tempList;
  }

  Widget getBackgroundImage() {
    // this method return the blue background globe image that is lightly shown under the application, this also return the slightly tinted overview for it.
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
    // returns banner image
    return Image.asset(
      "assets/bannerimage.png",
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.scaleDown,
    );
  }

  Widget showLoading() {
    // displays a loading bar if data is being downloaded
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }

  Widget showErrorMessage() {
    // displays an error message if there is one
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

  Widget getPageTitle() {
    // returns the title of the page

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Text(
        "Add Iron Diver Award",
        style: TextStyle(
            color: AggressorColors.primaryColor,
            fontSize: portrait
                ? MediaQuery.of(context).size.height / 30
                : MediaQuery.of(context).size.width / 30,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<bool> poppingPage() {
    setState(() {
      popDistance = 0;
    });
    return new Future.value(true);
  }
}
