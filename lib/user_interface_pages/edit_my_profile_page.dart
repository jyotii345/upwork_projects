import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/trip_database.dart';
import 'package:aggressor_adventures/databases/user_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class EditMyProfile extends StatefulWidget {
  //TODO cannot click my profile before app is done loading initially
  EditMyProfile(
      this.user, this.logoutCallback, this.updateCallback, this.profileData);

  final User user;
  final VoidCallback logoutCallback, updateCallback;
  final Map<String, dynamic> profileData;

  @override
  State<StatefulWidget> createState() => new EditMyProfileState();
}

class EditMyProfileState extends State<EditMyProfile>
    with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  final formKey = new GlobalKey<FormState>();

  String errorMessage = "";

  bool isLoading = false;

  double textDisplayWidth, textSize;

  Map<String, dynamic> countryDropDownSelection;
  Map<String, dynamic> stateDropDownSelection;

  List<dynamic> countryList = [], stateList = [];

  bool stateAndCountryLoaded = false;

  String name,
      profileImagePath,
      address1,
      address2,
      city,
      territory,
      zip,
      country,
      email,
      homePhone,
      workPhone,
      mobilePhone,
      username,
      password,
      totalDives,
      accountType;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
  }

  /*
  Build
   */
  @override
  Widget build(BuildContext context) {
    super.build(context);

    textDisplayWidth = MediaQuery.of(context).size.width / 2.5;

    textSize = MediaQuery.of(context).size.width / 30;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: AppBar().preferredSize.height,
          child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xff59a3c0),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        title: Image.asset(
          "assets/logo.png",
          height: AppBar().preferredSize.height,
          fit: BoxFit.fitHeight,
        ),
        actions: <Widget>[],
      ),
      body: Stack(
        children: [
          getBackgroundImage(),
          getPageForm(),
          Container(
            height: MediaQuery.of(context).size.height / 7 + 4,
            width: double.infinity,
            color: AggressorColors.secondaryColor,
          ),
          getBannerImage(),
          getLoadingWheel(),
        ],
      ),
    );
  }

  /*
  Self implemented
   */

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      errorMessage = "";
      isLoading = true;
    });

    if (validateAndSave()) {
      try {
        if (countryDropDownSelection["country"] == "USA") {
          territory = stateDropDownSelection["stateAbbr"];
        }

        if (password != "") {
          if (!validatePassword(password)) {
            throw Exception(
              "Password does not meet security requirements: \n• Password must be 8 characters long or larger\n• Password must contain at least one numerical digit\n• Password must contain at least one capital letter\n• Password must contain one special character",
            );
          }
        }

        if(totalDives == ""){
          totalDives = null;
        }

        var jsonResponse = await AggressorApi().saveProfileData(
            widget.user.userId,
            widget.profileData["first"],
            widget.profileData["last"],
            email,
            address1,
            address2,
            city,
            country == "2" ? territory : "",
            country != "2" ? territory : "",
            country,
            zip,
            username,
            password != "" ? password : null,
            homePhone,
            workPhone,
            mobilePhone);

        print(jsonResponse.toString());
        if (jsonResponse["status"] == "success") {
          stateAndCountryLoaded = false;
          widget.updateCallback();
          showSuccessDialogue();
        } else {
          throw Exception("Error updating account, please try again.");
        }

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print('caught Error: $e');
        setState(() {
          errorMessage = e.message;
          isLoading = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  bool validatePassword(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(password);
  }

  void showSuccessDialogue() {
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
                    },
                    child: new Text('Continue')),
              ],
            ));
  }

  Widget getPageForm() {
    return FutureBuilder(
        future: getCountryAndState(),
        builder: (context, snapshot) {
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
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 7,
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
                        getEmail(),
                        getHomePhone(),
                        getWorkPhone(),
                        getMobilePhone(),
                        getUsername(),
                        getPassword(),
                        getTotalNumberOfDives(),
                        getAccountType(),
                        getUpdateButton(),
                        getSignOutButton(),
                        showErrorMessage(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
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
                name,
                style: TextStyle(fontSize: textSize),
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
                  onPressed: () {},
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
              profileImagePath == ""
                  ? Text("No file chosen")
                  : Text(profileImagePath)
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
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    initialValue: address1,
                    style: TextStyle(fontSize: textSize),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Address 1 can\'t be empty' : null,
                    onSaved: (value) => address1 = value.trim(),
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
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  initialValue: address2,
                  style: TextStyle(fontSize: textSize),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                  onSaved: (value) => address2 = value.trim(),
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
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    initialValue: city,
                    style: TextStyle(fontSize: textSize),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'City can\'t be empty' : null,
                    onSaved: (value) => city = value.trim(),
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
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    initialValue: zip,
                    style: TextStyle(fontSize: textSize),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Zip code can\'t be empty' : null,
                    onSaved: (value) => zip = value.trim(),
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
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    initialValue: email,
                    style: TextStyle(fontSize: textSize),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Email can\'t be empty' : null,
                    onSaved: (value) => email = value.trim(),
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
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  initialValue: homePhone,
                  style: TextStyle(fontSize: textSize),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                  onSaved: (value) => homePhone = value.trim(),
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
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    initialValue: workPhone,
                    style: TextStyle(fontSize: textSize),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    onSaved: (value) => workPhone = value.trim(),
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
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  initialValue: mobilePhone,
                  style: TextStyle(fontSize: textSize),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                  onSaved: (value) => mobilePhone = value.trim(),
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
                username,
                style: TextStyle(fontSize: textSize),
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
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  initialValue: "",
                  style: TextStyle(fontSize: textSize),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                  onSaved: (value) =>
                      password == "" ? () {} : password = value.trim(),
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
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: totalDives == null || totalDives == ""
                      ? Text(
                          "0",
                          style: TextStyle(fontSize: textSize),
                        )
                      : Text(
                          totalDives,
                          style: TextStyle(fontSize: textSize),
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
              accountType,
              style: TextStyle(fontSize: textSize),
            ),
          ),
        ),
      ],
    );
  }

  Widget getUpdateButton() {
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

  Widget getSignOutButton() {
    return TextButton(
        onPressed: () {
          signOutUser();
        },
        style: TextButton.styleFrom(backgroundColor: Colors.red),
        child: Text(
          "Sign out",
          style: TextStyle(color: Colors.white),
        ));
  }

  void signOutUser() async {
    //sings user out and clears databases
    UserDatabaseHelper helper = UserDatabaseHelper.instance;
    await helper.deleteUser(100);

    TripDatabaseHelper tripDatabaseHelper = TripDatabaseHelper.instance;
    await tripDatabaseHelper.deleteTripTable();

    widget.logoutCallback();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyApp()));
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

  Widget getPageTitle() {
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
                    fontSize: MediaQuery.of(context).size.height / 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
                child: Image(image: AssetImage("assets/filesblue.png"),height: MediaQuery.of(context).size.width / 10,width: MediaQuery.of(context).size.width / 10),
                onPressed: () {
                  //TODO implement button function
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
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: DropdownButton<Map<String, dynamic>>(
                  isExpanded: true,
                  isDense: true,
                  value: stateDropDownSelection,
                  underline: Container(),
                  onChanged: (Map<String, dynamic> newValue) {
                    setState(() {
                      stateDropDownSelection = newValue;
                      country == "2"
                          ? territory = newValue["stateAbbr"]
                          : () {};
                    });
                  },
                  items: stateList
                      .map<DropdownMenuItem<Map<String, dynamic>>>((value) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(value["state"],
                            style: TextStyle(fontSize: textSize)),
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
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    initialValue: territory,
                    style: TextStyle(fontSize: textSize),
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
    print("getting drop down");

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton<Map<String, dynamic>>(
            isExpanded: true,
            isDense: true,
            value: countryDropDownSelection,
            onChanged: (Map<String, dynamic> newValue) {
              setState(() {
                countryDropDownSelection = newValue;
                country = newValue["countryid"].toString();
              });
            },
            items: countryList
                .map<DropdownMenuItem<Map<String, dynamic>>>((value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    value["country"],
                    style: TextStyle(fontSize: textSize),
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

  Future<dynamic> getCountryAndState() async {
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
      accountType = widget.profileData["account_type"];

      countryList = await AggressorApi().getCountries();
      stateList = await AggressorApi().getStates();
      countryDropDownSelection = countryList[0];
      stateDropDownSelection = stateList[0];

      countryList.forEach((element) {
        if (element["countryid"].toString() == country) {
          countryDropDownSelection = element;
        }
      });

      country == "2"
          ? stateList.forEach((element) {
              if (element["stateAbbr"].toString() == territory) {
                stateDropDownSelection = element;
              }
            })
          : () {};

      setState(() {
        stateAndCountryLoaded = true;
      });
    }
    return "finished";
  }

  Widget showErrorMessage() {
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
    return isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }

  @override
  bool get wantKeepAlive => true;
}
