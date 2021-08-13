import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/aggressor_colors.dart';

class AddCertification extends StatefulWidget {
  AddCertification(
    this.user,
    this.refreshState,
  );

  final User user;
  final VoidCallback refreshState;

  @override
  State<StatefulWidget> createState() => new AddCertificationState();
}

class AddCertificationState extends State<AddCertification> {
  /*
  instance vars
   */

  int pageIndex = 3;
  String errorMessage = "";

  String dropDownValue;

  bool loading = false;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();

    if(certificationOptionList[0] != " -- SELECT --"){
      certificationOptionList.insert(0, " -- SELECT -- ");
    }
    dropDownValue = " -- SELECT -- ";
   // dropDownValue = certificationOptionList[0];
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
      padding: EdgeInsets.fromLTRB(0,0,0, 10),
      child: ListView(
          children: [ getBannerImage(),


            Padding(
              padding: const EdgeInsets.all(10),
              child: getPageTitle(),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: getCertificateDropDown(),
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
            onPressed: addCertificate,
            child: Text(
              "Add Certificate",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: AggressorColors.secondaryColor),
          ),
        ),
      ],
    );
  }

  void addCertificate() async {
    //uploads the new iron diver to the API if the award is being given if the trip is valid
    setState(() {
      loading = true;
    });

    if(dropDownValue != " -- SELECT -- ") {
      var response = await AggressorApi()
          .saveCertification(widget.user.userId.toString(), dropDownValue);

      if (response["status"].toString().toLowerCase() == "success") {
        widget.refreshState();
        Navigator.pop(context);
      } else {
        setState(() {
          errorMessage = "Error adding the Certificate, please try again.";
        });
      }
    }

    setState(() {
      certificateLoaded = false;
      loading = false;
    });
  }

  Widget getCertificateDropDown() {
    //returns a drop down of certificates a user can add

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
              "Certificate Type:",
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
              child: DropdownButton<String>(
                underline: Container(),
                value: dropDownValue,
                elevation: 0,
                isExpanded: true,
                iconSize: portrait
                    ? MediaQuery.of(context).size.height / 35
                    : MediaQuery.of(context).size.width / 35,
                onChanged: (String newValue) {
                  setState(() {
                    dropDownValue = newValue;
                  });
                },
                items: certificationOptionList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        value,
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

  Widget showLoading() {
    //displays a loading bar if data is being downloaded
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }

  Widget showErrorMessage() {
    //displays an error message if there is one
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
    //returns the title of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Text(
        "Add Certification",
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

