import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/fcm_helper.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/certificate_database.dart';
import 'package:aggressor_adventures/databases/contact_database.dart';
import 'package:aggressor_adventures/databases/iron_diver_database.dart';
import 'package:aggressor_adventures/user_interface_pages/profile_edit_page.dart';
import 'package:aggressor_adventures/user_interface_pages/redeem_points_page.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_add_certifications_page.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_add_iron_diver_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/aggressor_colors.dart';
import 'dart:io';

import '../databases/states_database.dart';

class Rewards extends StatefulWidget {
  Rewards(this.user);

  final User user;

  @override
  State<StatefulWidget> createState() => new RewardsState();
}

class RewardsState extends State<Rewards> {
  /*
  instance vars
   */

  bool loading = false;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();

    if (contact == null) {
      getContactDetails();
    }
    if (ironDiverList.isEmpty) {
      getIronDiverList();
    }
  }

  void getIronDiverList() async {
    //set the initial iron diver awards
    ironDiverList = await AggressorApi().getIronDiverList(widget.user.userId!);
    updateIronDiversCache();
  }

  /*
  Build
   */

  @override
  Widget build(BuildContext context) {
    homePage = true;
    return PinchToZoom(
      OrientationBuilder(
        builder: (context, orientation) {
          portrait = orientation == Orientation.portrait;
          return Stack(
            children: [
              getBackgroundImage(),
              getWhiteOverlay(),
              (contact == null || loading)
                  ? Center(child: CircularProgressIndicator())
                  : getPageForm(),
            ],
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
    //returns the listview containing the content of the page
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 10),
        child: ListView(
          children: [
            getSliderImages(),
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
            getAllStarListView(),
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
      padding: const EdgeInsets.fromLTRB(15.0, 5, 15.0, 0.0),
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
                  style: TextStyle(
                      color: AggressorColors.primaryColor,
                      fontSize: MediaQuery.of(context).size.width / 27,
                      fontWeight: FontWeight.bold),
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
                    child: AutoSizeText(
                      "Add Certificate",
                      style: TextStyle(color: Colors.white),
                      minFontSize: 3.0,
                      maxLines: 1,
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AggressorColors.primaryColor,
                      fontSize: MediaQuery.of(context).size.width / 27,
                      fontWeight: FontWeight.bold),
                ),
                contact!.vip == null
                    ? Container()
                    : Image.asset(
                        "assets/vipclub.png",
                        height: MediaQuery.of(context).size.width / 10,
                        width: MediaQuery.of(context).size.width / 9,
                      ),
                contact!.vipPlus == null
                    ? Container()
                    : Image.asset(
                        "assets/vipplusclub.png",
                        height: MediaQuery.of(context).size.width / 10,
                        width: MediaQuery.of(context).size.width / 9,
                      ),
                contact!.sevenSeas == null
                    ? Container()
                    : Image.asset(
                        "assets/sevenseasclub.png",
                        height: MediaQuery.of(context).size.width / 10,
                        width: MediaQuery.of(context).size.width / 9,
                      ),
                contact!.adventuresClub == null
                    ? Container()
                    : Image.asset(
                        "assets/adventureclub.png",
                        height: MediaQuery.of(context).size.width / 10,
                        width: MediaQuery.of(context).size.width / 9,
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
                  style: TextStyle(
                      color: AggressorColors.primaryColor,
                      fontSize: MediaQuery.of(context).size.width / 27,
                      fontWeight: FontWeight.bold),
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
                    child: AutoSizeText(
                      "Add Iron Diver",
                      style: TextStyle(color: Colors.white),
                      minFontSize: 3.0,
                      maxLines: 1,
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
    return () {
      setState(() {});
    };
  }

  void showBoutiqueDialogue() {
    //shows a dialogue showing what the boutique points are fod
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              contentPadding: EdgeInsets.all(5),
              title: new Text(
                'Aggressor Boutique Points',
                style: TextStyle(
                  color: AggressorColors.secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              content: Container(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 5, 5),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: const <TextSpan>[
                            TextSpan(
                                text: 'Ways to earn boutique points: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text:
                                  ' You earn 400 points for making a Reservation & Deposit, 100 for completing Guest Surveys after each adventure, and 100 as a Birthday gift.One point is equivalent to \$.05. Example: 100 points equal \$5. Points do not expire, however, redeemed points do.\n',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: const <TextSpan>[
                            TextSpan(
                                text: 'FAQ’s\n\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'Do redeemed points expire? - ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text:
                                  'Yes, when you redeem points a coupon code is created for use in the Aggressor Boutique. That coupon code will expire 2 years from the day it is created. You can see unused coupon codes by clicking the “View Past Coupons” button on the “Redeem Points” page.\n\n',
                            ),
                            TextSpan(
                                text: 'Can I combine my coupons? - ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text:
                                  'Yes, you can type in multiple coupon codes at check out.\n\n',
                            ),
                            TextSpan(
                                text:
                                    'Can I use my coupon on sale items and/or with other discounts & specials? - ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: 'Yes\n\n',
                            ),
                            TextSpan(
                                text: 'Are there any restrictions? - ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text:
                                  'Yes, coupons can only be redeemed on items from the Aggressor Boutique. They can not be used for Aggressor Adventure trips, travel or merchandise at our destination stores.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                new TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('Continue')),
              ],
            ));
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
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Text(
              "VIP Progress Bar",
              style: TextStyle(fontSize: barTextSize),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: LinearPercentIndicator(
              percent: (contact!.vipCount == null || contact!.vipCount == "")
                  ? 0
                  : (double.parse(contact!.vipCount!) * 6.67) / 100 > 1.0
                      ? 1.0
                      : (double.parse(contact!.vipCount!) * 6.67) / 100,
              progressColor: Colors.green,
              lineHeight: barHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Text(
              "VIPplus Progress Bar",
              style: TextStyle(fontSize: barTextSize),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: LinearPercentIndicator(
              percent:
                  (contact!.vipPlusCount == null || contact!.vipPlusCount == "")
                      ? 0
                      : (double.parse(contact!.vipPlusCount!) * 4.0) / 100 > 1.0
                          ? 1.0
                          : (double.parse(contact!.vipPlusCount!) * 4.0) / 100,
              progressColor: Colors.green,
              lineHeight: barHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Text(
              "Seven Seas Progress Bar",
              style: TextStyle(fontSize: barTextSize),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: LinearPercentIndicator(
              percent: (contact!.sevenSeasCount == null ||
                      contact!.sevenSeasCount == "")
                  ? 0
                  : (double.parse(contact!.sevenSeasCount!) * 14.29) / 100 > 1.0
                      ? 1.0
                      : (double.parse(contact!.sevenSeasCount!) * 14.29) / 100,
              progressColor: Colors.green,
              lineHeight: barHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Text(
              "Adventurer Progress Bar",
              style: TextStyle(fontSize: barTextSize),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: LinearPercentIndicator(
              percent: (contact!.aaCount == null || contact!.aaCount == "")
                  ? 0
                  : (double.parse(contact!.aaCount!) * 33.34) / 100 > 1.0
                      ? 1.0
                      : (double.parse(contact!.aaCount!) * 33.34) / 100,
              progressColor: Colors.green,
              lineHeight: barHeight,
            ),
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
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: sectionHeight,
              width: sectionHeight,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: userImage.existsSync()
                    ? Image.file(
                        userImage,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        "assets/noprofile.png",
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            Container(
              height: sectionHeight,
              width: sectionWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (contact != null && contact!.nameF == null)
                      ? Text(
                          contact!.nameF.toString() +
                              " " +
                              contact!.nameL! +
                              "\nGuest since " +
                              contact!.memberSince! +
                              "\nTotal Adventures - " +
                              profileData["totalAdventures"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: sectionHeight / 8.5,
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {

                          // FCMHelper.
                          // sendNotification();

                          online ? openEditProfile() : openProfileView();

                        },
                        style: TextButton.styleFrom(
                            backgroundColor: AggressorColors.secondaryColor),
                        child: AutoSizeText(
                          "Update My Profile",
                          maxLines: 1,
                          minFontSize: 3.0,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: sectionHeight + 1,
              width: sectionWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          "Boutique Points",
                          maxLines: 1,
                          style: TextStyle(
                              color: AggressorColors.primaryColor,
                              fontSize: sectionHeight / 9,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: sectionHeight / 6,
                        width: sectionHeight / 6,
                        child: TextButton(
                          onPressed: () {
                            showBoutiqueDialogue();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize:
                                Size(sectionHeight / 6, sectionHeight / 6),
                          ),
                          child: Image.asset(
                            "assets/redquestion.png",
                            height: sectionHeight / 6,
                            width: sectionHeight / 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    contact!.boutiquePoints!,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: sectionHeight / 5,
                        fontWeight: FontWeight.bold),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RedeemPointsPage(
                                contact!.contactId!,
                                widget.user,
                                contact != null &&
                                        contact!.boutiquePoints != null &&
                                        contact!.boutiquePoints!.isNotEmpty
                                    ? int.parse(contact!.boutiquePoints!)
                                    : 0,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: AggressorColors.secondaryColor),
                        child: AutoSizeText(
                          "REDEEM NOW >",
                          maxLines: 1,
                          minFontSize: 3.0,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void openProfileView() {
    setState(() {
      currentIndex = 4;
    });
  }

  void launchRedeem() async {
    await launchUrl(Uri.parse("https://www.aggressor.com/pages/aggressor-rewards"));
  }

  Future<dynamic> openEditProfile() async {
    //loads the profile details

    setState(() {
      loading = true;
    });

    if (online) {
      if (!profileDataLoaded) {
        var jsonResponse =
            await AggressorApi().getProfileData(widget.user.userId!);
        statesList = await AggressorApi().getStates();
        if (jsonResponse["status"] == "success") {
          var jsonResponseCountries = await AggressorApi().getCountries();
          setState(() {
            countriesList = jsonResponseCountries;
            profileData = jsonResponse;
            profileDataLoaded = true;
          });
          updateStatesCache();
          getUserProfileImageData();
        }

        // getStatesList();

      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditMyProfile(widget.user, updateCallback, profileData)));
    }
    setState(() {
      loading = false;
    });
    return "finished";
  }

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
    return Image.asset(
      "assets/rewardspage.png",
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.scaleDown,
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
                        height: MediaQuery.of(context).size.width / 15,
                        width: MediaQuery.of(context).size.width / 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          certificationList[position]["certification"],
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 50),
                        ),
                      )
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
        .deleteCertification(widget.user.userId!, certificate["id"].toString());
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
                        height: MediaQuery.of(context).size.width / 15,
                        width: MediaQuery.of(context).size.width / 15,
                      ),
                      Text(
                        ironDiverList[position]["name"],
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 50),
                      )
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
        .deleteIronDiver(widget.user.userId!, ironDiver["id"].toString());
    if (response["status"].toString().toLowerCase() == "success") {
      setState(() {
        ironDiverList.remove(ironDiver);
        getIronDivers();
      });
    } else {
      setState(() {});
    }
  }

  Widget getPageTitle() {
    //returns the title of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "My Rewards",
            style: TextStyle(
                color: AggressorColors.primaryColor,
                fontSize: portrait
                    ? MediaQuery.of(context).size.height / 30
                    : MediaQuery.of(context).size.width / 30,
                fontWeight: FontWeight.bold),
          ),
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
    } catch (e) {}

    if (!certificateLoaded && online) {
      List<dynamic> tempList =
          await AggressorApi().getCertificationList(widget.user.userId!);
      setState(() {
        certificationList = tempList;
        certificateLoaded = true;
      });
    }
    try {
      setState(() {
        loading = false;
      });
    } catch (e) {}
  }

  void updateCertificationCache() async {
    //cleans and saves the certifications to the database
    CertificateDatabaseHelper certificateDatabaseHelper =
        CertificateDatabaseHelper.instance;
    try {
      await certificateDatabaseHelper.deleteCertificateTable();
    } catch (e) {}

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
    } catch (e) {}
    if (!ironDiversLoaded && online) {
      List<dynamic> tempList =
          await AggressorApi().getIronDiverList(widget.user.userId!);
      setState(() {
        ironDiverList = tempList;
        ironDiversLoaded = true;
      });
    }
    try {
      setState(() {
        loading = false;
      });
    } catch (e) {}
  }

  void updateIronDiversCache() async {
    //cleans and saves the iron divers to the database
    IronDiverDatabaseHelper ironDiverDatabaseHelper =
        IronDiverDatabaseHelper.instance;
    try {
      await ironDiverDatabaseHelper.deleteIronDiverTable();
    } catch (e) {}

    for (var ironDiver in ironDiverList) {
      await ironDiverDatabaseHelper.insertIronDiver(
          ironDiver['id'].toString(), ironDiver['name'].toString());
    }
  }

  void getContactDetails() async {
    if (!contactLoaded && online) {
      var response = await AggressorApi().getContact(widget.user.contactId!);
      setState(() {
        contact = mapContact(response);
        contactLoaded = true;
      });
      updateContactCache(response);
    }
    // else {
    //   List res = await ContactDatabaseHelper.instance.queryContact();
    //
    //   if (res.length > 0) {
    //     setState(() {
    //       contact = mapContact(res.first);
    //       contactLoaded = true;
    //     });
    //   }
    // }
  }

  void updateContactCache(var response) async {
    //cleans and saves the iron divers to the database
    ContactDatabaseHelper contactDatabaseHelper =
        ContactDatabaseHelper.instance;
    try {
      await contactDatabaseHelper.deleteContactTable();
    } catch (e) {}

    await contactDatabaseHelper.insertContact(
      response["contactid"] ?? "",
      response["first_name"] ?? "",
      response["middle_name"] ?? "",
      response["last_name"] ?? "",
      response["email"] ?? "",
      response["vipcount"] ?? "",
      response["vippluscount"] ?? "",
      response["sevenseascount"] ?? "",
      response["aacount"] ?? "",
      response["boutique_points"] ?? "",
      response["vip"] ?? "",
      response["vipPlus"] ?? "",
      response["sevenSeas"] ?? "",
      response["adventuresClub"] ?? "",
      response["memberSince"] ?? "",
    );
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
    // update to show profile data should be reloaded
    setState(() {
      profileDataLoaded = false;
      userImageRetreived = false;
    });
  }

  Widget showOffline() {
    // displays offline when the application does not have internet connection
    return online
        ? Container()
        : Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  "Application is offline",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
  }

  Widget getAllStarListView() {
    // returns the list view of the awards the user has earned
    getAllStars();
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5, 15.0, 0.0),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text(
                  "All-Star Club",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AggressorColors.primaryColor,
                      fontSize: MediaQuery.of(context).size.width / 27,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: allStarsList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset("assets/allstarnew.jpg"),
                    AutoSizeText(
                      allStarsList[index]["year"],
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> getAllStars() async {
    if (!allStarLoaded) {
      var allStarJson = await AggressorApi().getAllStar(widget.user.contactId!);

      List<dynamic> tempList = [];
      for (var element in allStarJson) {
        tempList.add(element);
      }
      setState(() {
        allStarsList = tempList;
        allStarLoaded = true;
      });
    }
  }

  Future<dynamic> getUserProfileImageData() async {
    if (!userImageRetreived) {
      try {
        var userImageRes = await AggressorApi()
            .downloadUserImage(widget.user.userId!, profileData["avatar"]);

        var bytes = await readByteStream(userImageRes.stream);
        var dirData = (await getApplicationDocumentsDirectory()).path;
        File temp = File(dirData + "/" + profileData["avatar"]);
        await temp.writeAsBytes(bytes);

        setState(() {
          userImageRetreived = true;
          userImage = temp;
        });
      } catch (e) {
        var dirData = (await getApplicationDocumentsDirectory()).path;

        setState(() {
          userImageRetreived = true;

          userImage = File(dirData + "/" + profileData["avatar"]);
        });
      }
    } else {
      var dirData = (await getApplicationDocumentsDirectory()).path;
      setState(() {
        userImage = File(dirData + "/" + profileData["avatar"]);
      });
    }
  }
}

Contact mapContact(response) {
  return Contact(
    response["contactid"] ?? "",
    response["first_name"] ?? "",
    response["middle_name"] ?? "",
    response["last_name"] ?? "",
    response["email"] ?? "",
    response["vipcount"] ?? "",
    response["vippluscount"] ?? "",
    response["sevenseascount"] ?? "",
    response["aacount"] ?? "",
    response["boutique_points"] ?? "",
    response["vip"] ?? "",
    response["vipPlus"] ?? "",
    response["sevenSeas"] ?? "",
    response["adventuresClub"] ?? "",
    response["memberSince"] ?? "",
  );
}
