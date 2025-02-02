import 'dart:io';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/profile_database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../databases/states_database.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

import 'package:timezone/data/latest_10y.dart' as tz;
class EditMyProfile extends StatefulWidget {
  EditMyProfile(this.user, this.updateCallback, this.profileData);

  final User user;
  final VoidCallback updateCallback;
  final Map<String, dynamic> profileData;

  @override
  State<StatefulWidget> createState() => new EditMyProfileState();
}

class EditMyProfileState extends State<EditMyProfile> {
  /*
  instance vars
   */

  final formKey = new GlobalKey<FormState>();

  String errorMessage = "";

  bool isLoading = false;

  double textDisplayWidth = 0, textSize = 0, textSizeInputField = 0;

  Map<String, dynamic> countryDropDownSelection = {};
  Map<String, dynamic> stateDropDownSelection = {};

  bool stateAndCountryLoaded = false;
  String timeZoneDropDownValue = "";
  // List<String> timeZonesList = [];




  // String name = "",
  //     profileImagePath = "",
  //     address1 = "",
  //     address2 = "",
  //     city = "",
  //     territory = "",
  //     zip = "",
  //     country = "",
  //     email = "",
  //     homePhone = "",
  //     workPhone = "",
  //     mobilePhone = "",
  //     username = "",
  //     totalDives = "",
  //     totalAdventures = "",
  //     accountType = "";
  //
  // String? password;

  String? name ,
      profileImagePath,
      address1 ,
      address2,
      city ,
      territory ,
      zip ,
      country,
      timeZone,
      email ,
      homePhone ,
      workPhone,
      mobilePhone,
      username ,
      totalDives ,
      totalAdventures ,
      accountType ,
      password;

  File? selectionFile;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
    // timeZoneFsList=[];
    // tz.timeZoneDatabase.locations.forEach((key, value) {
    //   timeZonesList.add(value.name);
    // });
    // timeZoneDropDownValue = timeZonesList.first;
    // print(tz.timeZoneDatabase.locations.length);

    // getStatesList();
    popDistance = 1;
  }

  //
  // void getStatesList() async {
  //   //set the initial states list
  //   statesList = await AggressorApi().getStates();
  //   updateStatesCache();
  // }

  void updateStatesCache() async {
    //cleans and saves the states to the database
    StatesDatabaseHelper statesDatabaseHelper = StatesDatabaseHelper.instance;
    try {
      await statesDatabaseHelper.deleteStatesTable();
    } catch (e) {
      print("no notes in the table");
    }

    for (var state in statesList) {
      await statesDatabaseHelper.insertStates(state);
    }


  }

  /*
  Build
   */
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: poppingPage,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBar(),
        bottomNavigationBar: getCouponBottomNavigationBar(),
        body: PinchToZoom(
          OrientationBuilder(
            builder: (context, orientation) {
              portrait = orientation == Orientation.portrait;
              textDisplayWidth = portrait
                  ? MediaQuery.of(context).size.width / 2.5
                  : MediaQuery.of(context).size.height / 2.5;
              textSize = portrait
                  ? MediaQuery.of(context).size.width / 30
                  : MediaQuery.of(context).size.height / 30;
              textSizeInputField = portrait
                  ? MediaQuery.of(context).size.width / 37
                  : MediaQuery.of(context).size.height / 37;
              return Stack(
                children: [
                  getBackgroundImage(),
                  getPageForm(),
                  getBannerImage(),
                  getLoadingWheel(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /*
  Self implemented
   */

  bool validateAndSave() {
    //ensure all fields are valid before saving
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    //once data is verified send the data
    setState(() {
      errorMessage = "";
      isLoading = true;
    });

    if (validateAndSave()) {
      try {
        if (countryDropDownSelection["country"] == "USA") {
          territory = stateDropDownSelection["stateAbbr"];
        }

        if (password!=null && password != "") {
          if (!validatePassword(password!)) {
            throw Exception(
              "Password does not meet security requirements: \n• Password must be 8 characters long or larger\n• Password must contain at least one numerical digit\n• Password must contain at least one capital letter\n• Password must contain one special character",
            );
          }
        }

        if (totalDives == "") {
          totalDives = null;
        }

        if (totalAdventures == "") {
          totalAdventures = null;
        }

        if (selectionFile != null) {
           await AggressorApi()
              .uploadUserImage(widget.user.userId!, selectionFile!.path);

          var dirData = (await getApplicationDocumentsDirectory()).path;
          var bytes = selectionFile!.readAsBytesSync();
          File temp = File(dirData + "/" + profileData["avatar"]);
          await temp.writeAsBytes(bytes);
        }

        var jsonResponse = await AggressorApi().saveProfileData(
            widget.user.userId!,
            widget.profileData["first"],
            widget.profileData["last"],
            email!,
            address1!,
            address2!,
            city!,
            country == "2" ? territory??"" : "",
            country != "2" ? territory??"" : "",
            country!,
            timeZone!,
            zip!,
            username!,
            password != "" ? password : null,
            homePhone!,
            workPhone!,
            mobilePhone!);

        if (jsonResponse["status"] == "success") {
          stateAndCountryLoaded = false;
          await loadProfileDetails();
          widget.updateCallback();
          showSuccessDialogue();
        } else {
          throw Exception("Error updating account, please try again.");
        }

        setState(() {
          userImage = selectionFile!;
          isLoading = false;
        });
      } catch (e) {
        print('caught Error: $e');
        setState(() {
          errorMessage = e.toString();//.message;
          isLoading = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  bool validatePassword(String password) {
    //ensures password meets the requirements
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(password);
  }

  Future<dynamic> loadProfileDetails() async {
    //loads the initial value of the users profile data
    var jsonResponse = await AggressorApi().getProfileData(widget.user.userId!);
    if (jsonResponse["status"] == "success") {
      setState(() {
        profileData = jsonResponse;
        profileDataLoaded = true;
      });
    }
    await updateProfileDetailsCache(jsonResponse);

    return "loaded";
  }

  Future<dynamic> updateProfileDetailsCache(var response) async {
    //cleans and saves the profile to the database
    ProfileDatabaseHelper profileDatabaseHelper =
        ProfileDatabaseHelper.instance;
    try {
      await profileDatabaseHelper.deleteProfileTable();
    } catch (e) {
      print("no profile in the table");
    }

    await profileDatabaseHelper.insertProfile(
      response['userId'],
      response['first'],
      response['last'],
      response['email'],
      response['address1'],
      response['address2'],
      response['address2'],
      response['state'],
      response['province'],
      response['country'].toString(),
      response['time_zone'],
      response['zip'],
      response['username'],
      response['password'],
      response['homePhone'],
      response['workPhone'],
      response['mobilePhone'],
    );

    return "updated";
  }

  void showSuccessDialogue() {
    //shows a success message when the profile is updated successfully
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text('Success'),
              content: new Text("Profile has been successfully updated"),
              actions: <Widget>[
                new TextButton(
                    onPressed: () {
                      int popCount = 0;
                      Navigator.popUntil(context, (route) {
                        return popCount++ == 2;
                      });
                      popDistance = 0;
                    },
                    child: new Text('Continue')),
              ],
            ));
  }

  Widget getPageForm() {
    //returns the main contents of the page
    return FutureBuilder(
        future: getCountryAndState(),
        builder: (context, snapshot) {
          try{
            if (snapshot.hasData && snapshot.data != null) {
              return Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          Opacity(
                            opacity: 0,
                            child: getBannerImage(),
                          ),
                          getPageTitle(),
                          getName(),
                          getProfilePicture(),
                          getAddress1(),
                          getAddress2(),
                          getCity(),
                          getTerritory(),
                          getZip(),
                          getCountry(),
                          getTimeZone(),
                          getEmail(),
                          getHomePhone(),
                          getWorkPhone(),
                          getMobilePhone(),
                          getUsername(),
                          getPassword(),
                          getTotalNumberOfDives(),
                          getTotalAdventures(),
                          //getAccountType(),
                          getUpdateButton(),
                          showErrorMessage(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
          catch(e){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget getName() {
    //returns the widget item containing the Name
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "Name",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                name!,
                style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getProfilePicture() {
    //returns the widget item containing the Profile picture
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "Profile picture:",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Row(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    loadAssets();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      "Choose file",
                      style: TextStyle(color: Colors.black, fontSize: textSize),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: MediaQuery.of(context).size.width -
                      (textDisplayWidth + textSize * 11),
                  child: profileImagePath == ""
                      ? Text("No file chosen")
                      : Text(
                          profileImagePath!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontSize: textSize),
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getAddress1() {
    //returns the widget item containing the address first line
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "Address Line 1: ",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),

                  child: TextFormField(
                    initialValue: address1,
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    validator: (value) =>
                        (value==null||value.isEmpty) ? 'Address 1 can\'t be empty' : null,
                    onSaved: (value) => address1 = value!.trim(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAddress2() {
    //returns the widget item containing the address second line
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text(
            "Address Line 2: ",
            style: TextStyle(fontSize: textSize),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),

                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                child: TextFormField(
                  initialValue: address2,
                  style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                  onSaved: (value) => address2 = value!.trim(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getCity() {
    //returns the widget item containing the city
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "City: ",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child: TextFormField(
                    initialValue: city,
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    validator: (value) =>
                        (value==null||(value.isEmpty)) ? 'City can\'t be empty' : null,
                    onSaved: (value) => city = value!.trim(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTerritory() {
    //returns the widget item containing the territory/state
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: countryDropDownSelection["country"] == "USA"
              ? Text(
                  "State",
                  style: TextStyle(fontSize: textSize),
                )
              : Text(
                  "Province",
                  style: TextStyle(fontSize: textSize),
                ),
        ),
        getTerritoryDropDown(),
      ],
    );
  }

  Widget getZip() {
    //returns the widget item containing the zip code
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "Zip: ",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child: TextFormField(
                    initialValue: zip,
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    validator: (value) =>
                       (value==null|| (value.isEmpty)) ? 'Zip code can\'t be empty' : null,
                    onSaved: (value) => zip = value.toString().trim(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCountry() {
    //returns the widget item containing the country
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text(
            "Country: ",
            style: TextStyle(fontSize: textSize),
          ),
        ),
        getCountryDropDown(),
      ],
    );
  }
  Widget getTimeZone() {
    //returns the widget item containing the country
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text(
            "TimeZone: ",
            style: TextStyle(fontSize: textSize),
          ),
        ),
        getTimeZoneDropDown(),
      ],
    );
  }

  // Widget getTimeZone() {
  //   //returns the field prompting for the email
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
  //     child: DropdownButtonFormField<String>(
  //       decoration: new InputDecoration(
  //         icon: Icon(
  //           Icons.more_time,
  //           color: AggressorColors.secondaryColor,
  //         ),
  //       ),
  //       value: dropDownValue,
  //       // hint: Text('Please choose account type'),
  //       items: timeZones.map((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: new Text(value),
  //         );
  //       }).toList(),
  //       onChanged: (newValue) {
  //         setState(() {
  //           dropDownValue = newValue.toString();
  //         });
  //       },
  //     ),
  //   );
  // }


  Widget getEmail() {
    //returns the widget item containing the email
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "Email: ",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child: TextFormField(
                    initialValue: email,
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    validator: (value) =>
                        (value==null||value.isEmpty) ? 'Email can\'t be empty' : null,
                    onSaved: (value) => email = value!.trim(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getHomePhone() {
    //returns the widget item containing the Home Phone Number
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text(
            "Home Phone: ",
            style: TextStyle(fontSize: textSize),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                child: TextFormField(
                  initialValue: homePhone,
                  style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                  onSaved: (value) => homePhone = value!.trim(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getWorkPhone() {
    //returns the widget item containing the Work Phone Number
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "Work Phone",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child: TextFormField(
                    initialValue: workPhone,
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    onSaved: (value) => workPhone = value!.trim(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMobilePhone() {
    //returns the widget item containing the Mobile Phone Number
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text(
            "Mobile Phone",
            style: TextStyle(fontSize: textSize),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                child: TextFormField(
                  initialValue: mobilePhone,
                  style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                  onSaved: (value) => mobilePhone = value!.trim(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getUsername() {
    //returns the widget item containing the username
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "username:",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                username!,
                style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getPassword() {
    //returns the widget item containing the password
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text(
            "Password: ",
            style: TextStyle(fontSize: textSize),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                child: TextFormField(
                  initialValue: "",
                  style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                  onSaved: (value) =>
                      password == "" ? () {} : password = value!.trim(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getTotalNumberOfDives() {
    //returns the widget item containing the total number of dives
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "Total Number of Dives: ",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child: totalDives == null || totalDives == ""
                      ? Text(
                          "0",
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                        )
                      : Text(
                          totalDives!,
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTotalAdventures() {
    //returns the widget item containing the total number of dives
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: textDisplayWidth,
            child: Text(
              "Total Number of Adventures: ",
              style: TextStyle(fontSize: textSize),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child: totalAdventures == null || totalAdventures == ""
                      ? Text(
                          "0",
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                        )
                      : Text(
                          totalAdventures!,
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAccountType() {
    //returns the widget item containing the account type
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text(
            "Account Type: ",
            style: TextStyle(fontSize: textSize),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              accountType!,
              style: TextStyle(fontSize: textSize),
            ),
          ),
        ),
      ],
    );
  }

  Widget getUpdateButton() {
    //returns a button to verify you are done with your updates
    return TextButton(
        onPressed: () {
          setState(() {
            errorMessage = "";
          });
          validateAndSubmit();
        },
        style: TextButton.styleFrom(
            backgroundColor: AggressorColors.secondaryColor),
        child: Text(
          "Update Profile",
          style: TextStyle(color: Colors.white),
        ));
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
    //returns the title of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: Text(
                "My Profile",
                style: TextStyle(
                    color: AggressorColors.primaryColor,
                    fontSize: portrait
                        ? MediaQuery.of(context).size.height / 30
                        : MediaQuery.of(context).size.width / 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
                child: Image(
                    image: AssetImage("assets/filesblue.png"),
                    height: portrait
                        ? MediaQuery.of(context).size.width / 10
                        : MediaQuery.of(context).size.height / 10,
                    width: portrait
                        ? MediaQuery.of(context).size.width / 10
                        : MediaQuery.of(context).size.height / 10),
                onPressed: () {
                }),
          ],
        ),
      ),
    );
  }

  Widget getTerritoryDropDown() {
    return countryDropDownSelection["country"] == "USA"
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: DropdownButton<Map<String, dynamic>>(
                  isExpanded: true,
                  value: stateDropDownSelection,
                  underline: Container(),
                  onChanged: (Map<String, dynamic>? newValue) {
                    setState(() {
                      stateDropDownSelection = newValue!;
                      if
                      (country == "2"){
                           territory = newValue["stateAbbr"];}

                    });
                  },
                  items: statesList
                      .map<DropdownMenuItem<Map<String, dynamic>>>((value) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                        child: Container(
                          child: Text(value["state"],
                            style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),),
                        ),
                      ),
                      value: value,
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child: TextFormField(
                    initialValue: territory,
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget getCountryDropDown() {
    //returns a dropdown of all countries

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton<Map<String, dynamic>>(
            isExpanded: true,
            value: countryDropDownSelection,
            onChanged: (Map<String, dynamic>? newValue) {
              setState(() {
                countryDropDownSelection = newValue!;
                country = newValue["countryid"].toString();
              });
            },
            items: countriesList
                .map<DropdownMenuItem<Map<String, dynamic>>>((value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child: Text(
                    value["country"],
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                  ),
                ),
                value: value,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  Widget getTimeZoneDropDown() {
    //returns a dropdown of all countries

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid,color:inputBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: timeZone,
            onChanged: ( newValue) {
              setState(() {
                timeZoneDropDownValue = newValue.toString();
                timeZone = newValue.toString();
              });
            },
            items: timeZones.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: textSizeInputField,color: inputTextColor),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );

  }

  Future<dynamic> getCountryAndState() async {
    // load the initial data for the page
    if (!stateAndCountryLoaded) {
      name = widget.profileData["first"] + " " + widget.profileData["last"];
      profileImagePath = widget.profileData["avatar"];
      address1 = widget.profileData["address1"];
      address2 = widget.profileData["address2"];
      city = widget.profileData["city"];
      zip = widget.profileData["zip"];
      country = widget.profileData["country"].toString();
      country == "2"
          ? territory = widget.profileData["state"]
          : territory = widget.profileData["province"];
      email = widget.profileData["email"];
      homePhone = widget.profileData["home_phone"];
      workPhone = widget.profileData["work_phone"];
      mobilePhone = widget.profileData["mobile_phone"];
      username = widget.profileData["username"];
      password = "";
      totalDives = widget.profileData["dives"].toString();
      totalAdventures = widget.profileData["totalAdventures"].toString();
      accountType = widget.profileData["account_type"];
      timeZone=widget.profileData["time_zone"];

      countryDropDownSelection = countriesList[0];

      stateDropDownSelection =statesList.isEmpty?{}: statesList[0];

      countriesList.forEach((element) {
        if (element["countryid"].toString() == country) {
          countryDropDownSelection = element;
        }
      });

      if (country == "2") {
        statesList.forEach((element) {
          if (element["stateAbbr"].toString() == territory) {
            stateDropDownSelection = element;
          }
        });
      }

      try {
        setState(() {
          stateAndCountryLoaded = true;
        });
      } catch (e) {
        print(e.toString());
      }
    }
    return "finished";
  }

  Widget showErrorMessage() {
    // returns the value of an error message if there is an error message to display
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

  Widget getLoadingWheel() {
    // returns a loading wheel if data is loading or sending
    return isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }

  Future<void> loadAssets() async {
    // loads the asset objects from the image picker
    // List<Asset> resultList = <Asset>[];
    String error = '';

    if (await Permission.photos.status.isDenied ||
        await Permission.camera.status.isDenied) {
      await Permission.photos.request();
      await Permission.camera.request();
    }

    // try {
    // resultList = await MultiImagePicker.pickImages(
    //   maxImages: 1,
    //   enableCamera: true,
    //   selectedAssets: resultList,
    //   cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
    //   materialOptions: MaterialOptions(
    //     actionBarColor: "#ff428cc7",
    //     actionBarTitle: "Aggressor Adventures",
    //     allViewTitle: "All Photos",
    //     useDetailsView: false,
    //     selectCircleStrokeColor: "#ff428cc7",
    //   ),
    // );

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      selectionFile = file;

      setState(() {
        profileImagePath =
            selectionFile!.path.substring(selectionFile!.path.lastIndexOf("/") + 1);

        userImage = selectionFile!;
      });
    } else {
      // User canceled the picker
    }

    // String path = "";
    // var tempPath =
    //
    //     resultList.first.
    //
    //     await FilePicker.getAbsolutePath(resultList[0].identifier);
    // if (tempPath.toLowerCase().contains(".heic")) {
    //   path = (await HeicToJpg.convert(tempPath))!;
    // } else {
    //   path = tempPath;
    // }
    // selectionFile = File(path);
    //
    // setState(() {
    //   profileImagePath =
    //       selectionFile!.path.substring(selectionFile!.path.lastIndexOf("/") + 1);
    //
    //   userImage = selectionFile!;
    // });

    if (!mounted) return;

    setState(() {
      errorMessage = error;
    });
  }

  Future<bool> poppingPage() {
    setState(() {
      popDistance = 0;
    });
    return new Future.value(true);
  }
}
