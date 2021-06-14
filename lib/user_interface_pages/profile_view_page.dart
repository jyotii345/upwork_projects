import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/user_interface_pages/profile_edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  MyProfile(
    this.user,
  );

  final User user;

  @override
  State<StatefulWidget> createState() => new MyProfileState();
}

class MyProfileState extends State<MyProfile>
    with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

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

    homePage = true;
    return PinchToZoom(
      OrientationBuilder(
        builder: (context, orientation) {
          portrait = orientation == Orientation.portrait;
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
        },
      ),
    );
  }

  /*
  Self implemented
   */

  Widget getPageForm() {
    //shows the main contents of the page
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
            showOffline(),
            getPageTitle(),
            getPageContents(),
          ],
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text(
                "Application is offline",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }

  Widget getPageContents() {
    //shows the contents of the user data
    return FutureBuilder(
        future: getProfileContents(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  getPersonalInfo(),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Account information: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: portrait ? MediaQuery.of(context).size.width / 25 : MediaQuery.of(context).size.height / 25),
                    ),
                  ),
                  getAccountInformation(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Address: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: portrait ? MediaQuery.of(context).size.width / 25 : MediaQuery.of(context).size.height / 25),
                    ),
                  ),
                  getAddress(),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget getAddress() {
    //gets the address of the user
    String territory = profileData["country"].toString() == "2"
        ? profileData["state"]
        : profileData["province"];
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          Text(profileData["address1"]),
          profileData["address2"] == ""
              ? Container()
              : Text(profileData["address2"]),
          Text(profileData["city"] +
              ", " +
              territory +
              " " +
              getCountry(profileData["country"].toString())),
        ],
      ),
    );
  }

  String getCountry(String countryCode) {
    //gets the country list from the api
    String country = countryCode;
    countriesList.forEach((element) {
      if (element["countryid"].toString() == countryCode) {
        country = element["country"];
      }
    });
    return country;
  }

  Widget getAccountInformation() {
    //displays the account information section
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Username: "),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: double.infinity,
              child: Text(
                profileData["username"],
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Account Type: "),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: double.infinity,
              child: Text(
                profileData["account_type"],
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text("Dives completed: "),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: double.infinity,
              child: Text(
                profileData["dives"],
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getPersonalInfo() {
    //returns the personal information section
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: portrait ? MediaQuery.of(context).size.width / 4 : MediaQuery.of(context).size.height / 4,
          width: portrait ? MediaQuery.of(context).size.width / 4 : MediaQuery.of(context).size.height / 4,
          child: Icon(
            //TODO find a way to get user images
            Icons.person,
            size: portrait ? MediaQuery.of(context).size.height / 8 : MediaQuery.of(context).size.width / 8,
          ),
          color: Colors.grey,
        ),
        Container(
          height: portrait ? MediaQuery.of(context).size.width / 4 : MediaQuery.of(context).size.height / 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileData["first"] + " " + profileData["last"],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(profileData["email"]),
              Text("Home Phone: " + profileData["home_phone"]),
              Text("Work Phone: " + profileData["work_phone"]),
              Text("Mobile Phone: " + profileData["mobile_phone"]),
            ],
          ),
        ),
      ],
    );
  }

  Future<dynamic> getProfileContents() async {
    //loads the profile details
    if (!profileDataLoaded) {
      var jsonResponse =
          await AggressorApi().getProfileData(widget.user.userId);
      if (jsonResponse["status"] == "success") {
        var jsonResponseCountries = await AggressorApi().getCountries();
        setState(() {
          countriesList = jsonResponseCountries;
          profileData = jsonResponse;
          profileDataLoaded = true;
        });
      }
    }
    return "finished";
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
        fit: BoxFit.fill,
      ),
    );
  }

  Widget getPageTitle() {
    //returns the page's title
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "My Profile",
              style: TextStyle(
                  color: AggressorColors.primaryColor,
                  fontSize: portrait ? MediaQuery.of(context).size.height / 26 : MediaQuery.of(context).size.width / 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: portrait ? MediaQuery.of(context).size.height / 20 : MediaQuery.of(context).size.width / 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AggressorColors.primaryColor),
              child: IconButton(
                iconSize: portrait ? MediaQuery.of(context).size.height / 35 : MediaQuery.of(context).size.width / 35,
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditMyProfile(
                              widget.user, updateCallback, profileData)));
                },
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateCallback() {
    //update to show profile data should be reloaded
    setState(() {
      profileDataLoaded = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
