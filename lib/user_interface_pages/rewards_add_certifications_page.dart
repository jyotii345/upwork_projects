import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  List<Trip> dateDropDownList = [];
  bool loading = false;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    dropDownValue = certificationOptionList[0];
  }

  /*
  Build
   */

  @override
  Widget build(BuildContext context) {
    homePage = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:getAppBar(),
      bottomNavigationBar: getBottomNavigationBar(),
      body: Stack(
        children: [
          getBackgroundImage(),
          getPageForm(),
          showLoading(),
          Container(
            height: MediaQuery.of(context).size.height / 7 + 4,
            width: double.infinity,
            color: AggressorColors.secondaryColor,
          ),
          getBannerImage(),
        ],
      ),
    );
  }

  /*
  Self implemented
   */

  makeCall() async {
    //calls the provided number when clicked
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePopupClick(String value) {
    //handles the options in the menu bar
    switch (value) {
      case 'My Profile':
        currentIndex = 5;
        Navigator.pop(context);
    }
  }

  Widget getPageForm() {
    //returns the main contents of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
            ),
            getPageTitle(),
            getCertificateDropDown(),
            getAddButton(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget getAddButton() {
    //returns the add button to upload an iron diver award
    return Center(
      child: TextButton(
        onPressed: addCertificate,
        child: Text(
          "Add Certificate",
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
            backgroundColor: AggressorColors.secondaryColor),
      ),
    );
  }

  void addCertificate() async {
    //uploads the new iron diver to the API if the award is being given if the trip is valid
    setState(() {
      loading = true;
    });

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Certificate Type:",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 35,
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
                iconSize: MediaQuery.of(context).size.height / 35,
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
                            fontSize:
                                MediaQuery.of(context).size.height / 40 - 4),
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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 7,
      child: Image.asset(
        "assets/bannerimage.png",
        fit: BoxFit.cover,
      ),
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
            fontSize: MediaQuery.of(context).size.height / 26,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
