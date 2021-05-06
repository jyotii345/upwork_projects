import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/user_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sqflite/sqflite.dart';

import 'main_page.dart';

class MyProfile extends StatefulWidget {
  //TODO cannot click my profile before app is done loading initially
  MyProfile(this.user, this.logoutCallback);

  User user;
  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => new MyProfileState();
}

class MyProfileState extends State<MyProfile>
    with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  double textDisplayWidth;

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

    textDisplayWidth = MediaQuery.of(context).size.width / 2;
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

  Widget getPageForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget getName() {
    //returns the widget item containing the Name
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Name"),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getProfilePicture() {
    //returns the widget item containing the Profile picture
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Profile picture:"),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getAddress1() {
    //returns the widget item containing the address first line
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Address Line 1: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getAddress2() {
    //returns the widget item containing the address second line
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Address Line 2: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getCity() {
    //returns the widget item containing the city
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("City: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getTerritory() {
    //returns the widget item containing the territory/state
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Territory/state"),
        ),
        //TODO make this reactive to country
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getZip() {
    //returns the widget item containing the zip code
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Zip: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getCountry() {
    //returns the widget item containing the country
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Country: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getEmail() {
    //returns the widget item containing the email
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Email: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getHomePhone() {
    //returns the widget item containing the Home Phone Number
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Home Phone: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getWorkPhone() {
    //returns the widget item containing the Work Phone Number
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Work Phone"),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getMobilePhone() {
    //returns the widget item containing the Mobile Phone Number
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Mobile Phone"),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getUsername() {
    //returns the widget item containing the username
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("username:"),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getPassword() {
    //returns the widget item containing the password
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Password: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getTotalNumberOfDives() {
    //returns the widget item containing the total number of dives
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Total Number of Dives: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getAccountType() {
    //returns the widget item containing the account type
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Account Type: "),
        ),
        Expanded(
            child: Container(
          color: Colors.green,
          child: Text("placeholder item"),
        ))
      ],
    );
  }

  Widget getUpdateButton() {
    return TextButton(
        onPressed: () {
          print("update profile"); //TODO implement functionality
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
          print("signing out user");
          signOutUser();
        },
        style: TextButton.styleFrom(backgroundColor: Colors.red),
        child: Text(
          "Sign out",
          style: TextStyle(color: Colors.white),
        ));
  }

  void signOutUser() async {
    print(" ----------------------SIGNOUT----------------------");
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteUser(100);

    print("user deleted");
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
                child: Image(image: AssetImage("assets/files.png")),
                onPressed: () {
                  //TODO implement button function
                }),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
