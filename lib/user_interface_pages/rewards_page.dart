import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_add_certifications_page.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_add_iron_diver_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../classes/aggressor_colors.dart';

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

    return Stack(
      children: [
        getBackgroundImage(),
        getPageForm(),
        getSliderImages(),
      ],
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
                  style: TextStyle(color: AggressorColors.primaryColor),
                ),
                getCertificationListView(),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCertification(
                                    widget.user,
                                  )));
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
                  style: TextStyle(color: AggressorColors.primaryColor),
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
                  style: TextStyle(color: AggressorColors.primaryColor),
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
                                  )));
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

  Widget getProgressSection() {
    //returns the section of tha page that holds the progress bars
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("VIP Progress Bar"),
          ),
          LinearPercentIndicator(
            percent: contact.vipCount == null
                ? 0
                : (double.parse(contact.vipCount) * 6.67) / 100,
            progressColor: Colors.green,
            lineHeight: 20,
          ), //TODO dynamic height
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("VIPplus Progress Bar"),
          ),
          LinearPercentIndicator(
            percent: contact.vipPlusCount == null
                ? 0
                : (double.parse(contact.vipPlusCount) * 4.0) / 100,
            progressColor: Colors.green,
            lineHeight: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Seven Seas Progress Bar"),
          ),
          LinearPercentIndicator(
            percent: contact.sevenSeasCount == null
                ? 0
                : (double.parse(contact.sevenSeasCount) * 14.29) / 100,
            progressColor: Colors.green,
            lineHeight: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Adventurer Progress Bar"),
          ),
          LinearPercentIndicator(
            percent: contact.aaCount == null
                ? 0
                : (double.parse(contact.aaCount) * 33.34) / 100,
            progressColor: Colors.green,
            lineHeight: 20,
          ),
        ],
      ),
    );
  }

  Widget getUserRow() {
    //returns the row widget containing the user information and boutique points
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 4,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset(
                "assets/noprofile.png",
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width / 4,
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
                ),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      print("pressed");
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: AggressorColors.secondaryColor),
                    child: Text(
                      "Update My Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width / 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Boutique Points",
                      style: TextStyle(color: AggressorColors.primaryColor),
                    ),
                    Container(
                      height: 15,
                      width: 15,
                      child: TextButton(
                        onPressed: () {
                          print("pressed");
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(10, 10),
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
                Text(contact.boutiquePoints),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () {
                      print("pressed");
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: AggressorColors.secondaryColor),
                    child: Text(
                      "REDEEM NOW >",
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
          child: Image.memory(
            sliderImageList[sliderIndex],
            fit: BoxFit.fill,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
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
                size: MediaQuery.of(context).size.width / 7.5,
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
                }
                else{
                  setState(() {
                    sliderIndex = sliderImageList.length - 1;
                  });
                }
              },
              child: Icon(
                Icons.chevron_left,
                color: Colors.white70,
                size: MediaQuery.of(context).size.width / 7.5,
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
                child: GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/certification.png",
                        height: 25, //TODO replace with a dynamic value
                        width: 25,
                      ),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child:
                            Text(certificationList[position]["certification"]),
                      ))
                    ],
                  ),
                  onLongPressStart: (LongPressStartDetails details) =>
                      showOptionsMenuCertificate(
                          details, certificationList[position]),
                ),
              );
            });
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
                child: GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/irondiver.png",
                        height: 25,
                        width: 25,
                      ),
                      Flexible(child: Text(ironDiverList[position]["name"]))
                    ],
                  ),
                  onLongPressStart: (LongPressStartDetails details) =>
                      showOptionsMenuIronDiver(
                          details, ironDiverList[position]),
                ),
              );
            });
  }

  void showOptionsMenuIronDiver(
      LongPressStartDetails details, var ironDiver) async {
    //display the delete option for an iron diver
    RenderBox overlay = Overlay.of(context).context.findRenderObject();

    int selection = await showMenu(
      position: RelativeRect.fromRect(
          details.globalPosition & Size(20, 20), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      context: context,
      items: <PopupMenuEntry<int>>[
        PopupMenuItem(
          value: 0,
          child: Text('Delete'),
        )
      ],
    );

    if (selection == 0) {
      var response = await AggressorApi()
          .deleteIronDiver(widget.user.userId, ironDiver["id"].toString());
      if (response["status"].toString().toLowerCase() == "success") {
        setState(() {
          getIronDivers();
        });
      } else {
        setState(() {
          //TODO show error message
        });
      }
    }
  }

  void showOptionsMenuCertificate(
      LongPressStartDetails details, var certificate) async {
    //display the delete option for a certificate
    RenderBox overlay = Overlay.of(context).context.findRenderObject();

    int selection = await showMenu(
      position: RelativeRect.fromRect(
          details.globalPosition & Size(20, 20), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      context: context,
      items: <PopupMenuEntry<int>>[
        PopupMenuItem(
          value: 0,
          child: Text('Delete'),
        )
      ],
    );

    if (selection == 0) {
      var response = await AggressorApi().deleteCertification(
          widget.user.userId, certificate["id"].toString());
      if (response["status"].toString().toLowerCase() == "success") {
        setState(() {
          getCertifications();
        });
      } else {
        setState(() {
          //TODO show error message
        });
      }
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
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void getCertifications() async {
    //this widget updates the certifications in the list
    //TODO add loading indicators

    if (!certificateLoaded) {
      List<dynamic> tempList =
          await AggressorApi().getCertificationList(widget.user.userId);
      setState(() {
        certificationList = tempList;
        certificateLoaded = true;
      });
    }
  }

  void getIronDivers() async {
    //this widget updates the Iron Divers in the list
    //TODO add loading indicators
    if (!ironDiversLoaded) {
      List<dynamic> tempList =
          await AggressorApi().getCertificationList(widget.user.userId);
      setState(() {
        certificationList = tempList;
        ironDiversLoaded = true;
      });
    }
  }

  void getContactDetails() async {
    if (!contactLoaded) {
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
    }
  }

  @override
  bool get wantKeepAlive => true;
}
