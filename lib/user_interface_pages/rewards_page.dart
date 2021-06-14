import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/certificate_database.dart';
import 'package:aggressor_adventures/databases/contact_database.dart';
import 'package:aggressor_adventures/databases/iron_diver_database.dart';
import 'package:aggressor_adventures/user_interface_pages/profile_edit_page.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_add_certifications_page.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_add_iron_diver_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/aggressor_colors.dart';
import 'dart:io';

class Rewards extends StatefulWidget {
  Rewards(this.user);

  final User user;

  @override
  State<StatefulWidget> createState() => new RewardsState();
}

class RewardsState extends State<Rewards> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */
  int sliderIndex = 0;

  bool loading = false;

  bool timerStarted = false;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();

    sliderImageTimer();
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
              getSliderImages(),
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
    //returns the listview containing the content of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
            ),
            showOffline(),
            getPageTitle(),
            getUserRow(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Divider(
                height: 2,
                color: Colors.grey[400],
              ),
            ),
            getProgressSection(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Divider(
                height: 2,
                color: Colors.grey[400],
              ),
            ),
            getBadgeSection(),
          ],
        ),
      ),
    );
  }

  Widget getBadgeSection() {
    //returns the bottom section containing the lists of badges and awards the user has earned
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text(
                  "My Certifications",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AggressorColors.primaryColor, fontSize: MediaQuery.of(context).size.width / 27),
                ),
                getCertificationListView(),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddCertification(widget.user, refreshState),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: AggressorColors.secondaryColor),
                    child: Text(
                      "Add Certificate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text(
                  "Club Membership",
                  style: TextStyle(color: AggressorColors.primaryColor,  fontSize: MediaQuery.of(context).size.width / 27),
                ),
                contact.vip == null
                    ? Container()
                    : Image.asset(
                        "assets/vipclub.png",
                        height: MediaQuery.of(context).size.width / 5,
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                contact.vipPlus == null
                    ? Container()
                    : Image.asset(
                        "assets/vipplusclub.png",
                        height: MediaQuery.of(context).size.width / 5,
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                contact.sevenSeas == null
                    ? Container()
                    : Image.asset(
                        "assets/sevenseasclub.png",
                        height: MediaQuery.of(context).size.width / 5,
                        width: MediaQuery.of(context).size.width / 4,
                      ), //TODO replace with seven seas logo
                contact.adventuresClub == null
                    ? Container()
                    : Image.asset(
                        "assets/adventureclub.png",
                        height: MediaQuery.of(context).size.width / 5,
                        width: MediaQuery.of(context).size.width / 4,
                      ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text(
                  "Iron Diver Awards",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AggressorColors.primaryColor, fontSize: MediaQuery.of(context).size.width / 27),
                ),
                getIronDiverListView(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddIronDiver(
                            widget.user,
                            refreshState,
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: AggressorColors.secondaryColor),
                    child: Text(
                      "Add Iron Diver",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback refreshState() {
    setState(() {});
  }

  Widget getProgressSection() {
    //returns the section of tha page that holds the progress bars
    double barHeight = portrait
        ? MediaQuery.of(context).size.height / 40
        : MediaQuery.of(context).size.width / 40;
    double barTextSize = portrait
        ? MediaQuery.of(context).size.height / 40
        : MediaQuery.of(context).size.width / 40;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              "VIP Progress Bar",
              style: TextStyle(fontSize: barTextSize),
            ),
          ),
          LinearPercentIndicator(
            percent: contact.vipCount == null
                ? 0
                : (double.parse(contact.vipCount) * 6.67) / 100,
            progressColor: Colors.green,
            lineHeight: barHeight,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              "VIPplus Progress Bar",
              style: TextStyle(fontSize: barTextSize),
            ),
          ),
          LinearPercentIndicator(
            percent: contact.vipPlusCount == null
                ? 0
                : (double.parse(contact.vipPlusCount) * 4.0) / 100,
            progressColor: Colors.green,
            lineHeight: barHeight,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              "Seven Seas Progress Bar",
              style: TextStyle(fontSize: barTextSize),
            ),
          ),
          LinearPercentIndicator(
            percent: contact.sevenSeasCount == null
                ? 0
                : (double.parse(contact.sevenSeasCount) * 14.29) / 100,
            progressColor: Colors.green,
            lineHeight: barHeight,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              "Adventurer Progress Bar",
              style: TextStyle(fontSize: barTextSize),
            ),
          ),
          LinearPercentIndicator(
            percent: contact.aaCount == null
                ? 0
                : (double.parse(contact.aaCount) * 33.34) / 100,
            progressColor: Colors.green,
            lineHeight: barHeight,
          ),
        ],
      ),
    );
  }

  Widget getUserRow() {
    //returns the row widget containing the user information and boutique points
    double sectionWidth = portrait
        ? (MediaQuery.of(context).size.width / 3) - 16
        : (MediaQuery.of(context).size.width / 3.5);
    double sectionHeight = portrait
        ? MediaQuery.of(context).size.width / 4
        : MediaQuery.of(context).size.width / 5;
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: sectionHeight,
            width: sectionWidth,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset(
                "assets/noprofile.png",
              ),
            ),
          ),
          Container(
            height: sectionHeight,
            width: sectionWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  contact.nameF +
                      " " +
                      contact.nameM +
                      " " +
                      contact.nameL +
                      ", " +
                      profileData["state"] +
                      "\nGuest since " +
                      contact.memberSince +
                      "\nTotal Adventures - " +
                      tripList.length.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: sectionHeight / 8.5),
                ),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      online ? openEditProfile() : openProfileView();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: AggressorColors.secondaryColor),
                    child: AutoSizeText(
                      "Update My Profile",
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: sectionHeight,
            width: sectionWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Boutique Points",
                      maxLines: 1,
                      style: TextStyle(color: AggressorColors.primaryColor, fontSize: sectionHeight / 8),
                    ),
                    Container(
                      height: sectionHeight / 6,
                      width: sectionHeight / 6,
                      child: TextButton(
                        onPressed: () {
                          print("pressed");
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(sectionHeight / 6, sectionHeight / 6),
                        ),
                        child: Image.asset(
                          "assets/redquestion.png",
                          height: 10,
                          width: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  contact.boutiquePoints,
                  maxLines: 1,
                  style: TextStyle(fontSize: sectionHeight / 5),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () {
                      launchRedeem();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: AggressorColors.secondaryColor),
                    child: AutoSizeText(
                      "REDEEM NOW >",
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void openProfileView() {
    setState(() {
      currentIndex = 5;
    });
  }

  void launchRedeem() async {
    await launch("https://www.aggressor.com/pages/aggressor-rewards");
  }

  Future<dynamic> openEditProfile() async {
    //loads the profile details
    if (online) {
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditMyProfile(widget.user, updateCallback, profileData)));
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

  Widget getSliderImages() {
    //returns slider images on top of the page
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          child: Image.file(
            File(sliderImageList[sliderIndex]["filePath"]),
            fit: BoxFit.fill,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6 ,
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
                size: portrait?  MediaQuery.of(context).size.width / 7.5 :  MediaQuery.of(context).size.height / 7.5,
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
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
                size: portrait?  MediaQuery.of(context).size.width / 7.5 :  MediaQuery.of(context).size.height / 7.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getCertificationListView() {
    //returns the list view of the awards the user has earned
    getCertifications();
    return certificationList.length == 0
        ? Text(
            "No certifications added yet",
            textAlign: TextAlign.center,
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: certificationList.length,
            itemBuilder: (context, position) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: .25,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/certification.png",

                        height:MediaQuery.of(context).size.width / 15 ,
                        width: MediaQuery.of(context).size.width / 15 ,
                      ),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child:
                            Text(certificationList[position]["certification"], style: TextStyle(fontSize: MediaQuery.of(context).size.width / 25),),
                      ))
                    ],
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        deleteCertificate(certificationList[position]);
                      },
                    ),
                  ],
                ),
              );
            });
  }

  void deleteCertificate(var certificate) async {
    var response = await AggressorApi()
        .deleteCertification(widget.user.userId, certificate["id"].toString());
    if (response["status"].toString().toLowerCase() == "success") {
      setState(() {
        certificationList.remove(certificate);
        getCertifications();
      });
    }
  }

  Widget getIronDiverListView() {
    //returns the list view of the awards the user has earned
    getIronDivers();
    return ironDiverList.length == 0
        ? Text(
            "No Iron Diver awards added yet",
            textAlign: TextAlign.center,
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: ironDiverList.length,
            itemBuilder: (context, position) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: .25,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/irondiver.png",
                        height:MediaQuery.of(context).size.width / 15 ,
                        width: MediaQuery.of(context).size.width / 15 ,
                      ),
                      Flexible(child: Text(ironDiverList[position]["name"], style: TextStyle(fontSize: MediaQuery.of(context).size.width / 25),))
                    ],
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        deleteIronDiver(ironDiverList[position]);
                      },
                    ),
                  ],
                ),
              );
            });
  }

  void deleteIronDiver(var ironDiver) async {
    var response = await AggressorApi()
        .deleteIronDiver(widget.user.userId, ironDiver["id"].toString());
    if (response["status"].toString().toLowerCase() == "success") {
      setState(() {
        ironDiverList.remove(ironDiver);
        getIronDivers();
      });
    } else {
      setState(() {
        //TODO show error message
      });
    }
  }

  Widget getPageTitle() {
    //returns the title of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Rewards",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 25
                  : MediaQuery.of(context).size.width / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void getCertifications() async {
    //this widget updates the certifications in the list
    try {
      setState(() {
        loading = true;
      });
    } catch (e) {
    }

    if (!certificateLoaded && online) {
      List<dynamic> tempList =
          await AggressorApi().getCertificationList(widget.user.userId);
      setState(() {
        certificationList = tempList;
        certificateLoaded = true;
      });
    }
    try {
      setState(() {
        loading = false;
      });
    } catch (e) {
    }
  }

  void updateCertificationCache() async {
    //cleans and saves the certifications to the database
    CertificateDatabaseHelper certificateDatabaseHelper =
        CertificateDatabaseHelper.instance;
    try {
      await certificateDatabaseHelper.deleteCertificateTable();
    } catch (e) {
    }

    for (var certification in certificationList) {
      await certificateDatabaseHelper.insertCertificate(
          certification['id'], certification['certification']);
    }
  }

  void getIronDivers() async {
    //this widget updates the Iron Divers in the list
    try {
      setState(() {
        loading = true;
      });
    } catch (e) {
    }
    if (!ironDiversLoaded && online) {
      List<dynamic> tempList =
          await AggressorApi().getIronDiverList(widget.user.userId);
      setState(() {
        ironDiverList = tempList;
        ironDiversLoaded = true;
      });
    }
    try {
      setState(() {
        loading = false;
      });
    } catch (e) {
    }
  }

  void updateIronDiversCache() async {
    //cleans and saves the iron divers to the database
    IronDiverDatabaseHelper ironDiverDatabaseHelper =
        IronDiverDatabaseHelper.instance;
    try {
      await ironDiverDatabaseHelper.deleteIronDiverTable();
    } catch (e) {
    }

    for (var ironDiver in ironDiverList) {
      await ironDiverDatabaseHelper.insertIronDiver(
          ironDiver['id'], ironDiver['name']);
    }
  }

  void getContactDetails() async {
    if (!contactLoaded && online) {
      var response = await AggressorApi().getContact(widget.user.contactId);
      setState(() {
        contact = Contact(
            response["contactid"],
            response["first_name"],
            response["middle_name"],
            response["last_name"],
            response["email"],
            response["vipcount"],
            response["vippluscount"],
            response["sevenseascount"],
            response["aacount"],
            response["boutique_points"],
            response["vip"],
            response["vipPlus"],
            response["sevenSeas"],
            response["adventuresClub"],
            response["memberSince"]);
        contactLoaded = true;
      });
      updateContactCache(response);
    }
  }

  void updateContactCache(var response) async {
    //cleans and saves the iron divers to the database
    ContactDatabaseHelper contactDatabaseHelper =
        ContactDatabaseHelper.instance;
    try {
      await contactDatabaseHelper.deleteContactTable();
    } catch (e) {
    }

    await contactDatabaseHelper.insertContact(
        response["contactid"],
        response["first_name"],
        response["middle_name"],
        response["last_name"],
        response["email"],
        response["vipcount"],
        response["vippluscount"],
        response["sevenseascount"],
        response["aacount"],
        response["boutique_points"],
        response["vip"],
        response["vipPlus"],
        response["sevenSeas"],
        response["adventuresClub"],
        response["memberSince"]);
  }

  Widget showLoading() {
    //displays a loading bar if data is being downloaded
    return loading
        ? Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0, 0),
            child: LinearProgressIndicator(
              backgroundColor: AggressorColors.primaryColor,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Container();
  }

  void updateCallback() {
    //update to show profile data should be reloaded
    setState(() {
      profileDataLoaded = false;
    });
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
    } catch (e) {
    }
  }

  @override
  bool get wantKeepAlive => true;
}
