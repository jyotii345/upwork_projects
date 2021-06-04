import 'dart:typed_data';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/user_interface_pages/main_page.dart';
import 'package:aggressor_adventures/user_interface_pages/profile_link_page.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage(this.user);

  final User user;

  @override
  State<StatefulWidget> createState() => new LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  /*
  instance vars
   */

  double percent = 0.0;

  /*
  initState

  Build
   */

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: AppBar().preferredSize.height,
          child: IconButton(
            icon: Container(
              child: Image.asset("assets/callicon.png"),
            ),
            onPressed: makeCall,
          ),
        ),
        title: Image.asset(
          "assets/logo.png",
          height: AppBar().preferredSize.height,
          fit: BoxFit.fitHeight,
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
            child: SizedBox(
              height: AppBar().preferredSize.height,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton<String>(
                    onSelected: handlePopupClick,
                    child: Container(
                      child: Image.asset(
                        "assets/menuicon.png",
                      ),
                    ),
                    itemBuilder: (BuildContext context) {
                      return {
                        "My Profile",
                      }.map((String option) {
                        return PopupMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList();
                    }),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                CircularPercentIndicator(
                  radius: MediaQuery.of(context).size.width / 3,
                  percent: percent > 1 ? 1 : percent,
                  animateFromLastPercent: true,
                  backgroundColor: AggressorColors.secondaryColor,
                  progressColor: AggressorColors.primaryColor,
                ),
                percent > 1
                    ? Text(
                        "Downloading trip data: 100%",
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        "Downloading trip data: " +
                            int.parse((percent * 100).round().toString())
                                .toString() +
                            "%",
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: getBottomNavigation(),
    );
  }

/*
  self implemented
   */

  makeCall() async {
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePopupClick(String value) {
    switch (value) {
      case 'My Profile':
        print("loading");
    }
  }

  Widget getBottomNavigation() {
    /*
    returns a bottom navigation bar widget containing the pages desired and their icon types. This is only for the look of the bottom navigation bar
     */

    double iconSize = MediaQuery.of(context).size.width / 8;
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (int) {},
      backgroundColor: AggressorColors.primaryColor,
      // new
      currentIndex: 0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      items: [
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/tripsactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/tripspassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/notesactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/notespassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/photosactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/photospassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/rewardsactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/rewardspassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/filesactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/filespassive.png"),
          ),
          label: '',
        ),
      ],
    );
  }

  void loadData() async {
    setState(() {
      Wakelock.enable();
    });

    updateSliderImages();

    getContactDetails();

    var profileLinkResponse =
        await AggressorApi().checkProfileLink(widget.user.userId);

    if (profileLinkResponse["status"] != "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfileLinkPage(widget.user, profileLinkResponse["messsage"]),
        ),
      );
    }

    boatList = await AggressorApi().getBoatList();
    ironDiverList = await AggressorApi().getIronDiverList(widget.user.userId);
    certificationList =
        await AggressorApi().getCertificationList(widget.user.userId);

    var tempList = await AggressorApi()
        .getReservationList(widget.user.contactId, loadingCallBack);
    setState(() {
      tripList = tempList;
    });

    setState(() {
      loadedCount = tripList.length.toDouble();
      percent = ((loadedCount / loadingLength * 2));
    });

    if (tripList == null) {
      tripList = [];
    }

    for (var trip in tripList) {
      trip.user = widget.user;
      await trip.initCharterInformation();
      setState(() {
        loadedCount++;
        percent = ((loadedCount / (loadingLength * 2)));
      });
    }

    setState(() {
      Wakelock.disable();
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  user: widget.user,
                )));
  }

  Future<dynamic> updateSliderImages() async {
    //TODO store these files somewhere
    List<String> fileNames = await AggressorApi().getRewardsSliderList();
    for (var file in fileNames) {
      var fileResponse = await AggressorApi()
          .getRewardsSliderImage(file.substring(file.indexOf("/") + 1));
      Uint8List bytes = await readByteStream(fileResponse.stream);
      sliderImageList.add(bytes);
    }
    return "done";
  }

  VoidCallback loadingCallBack() {
    setState(() {
      loadedCount++;
      percent = ((loadedCount / (loadingLength * 2)));
    });
  }

  void getContactDetails() async {
    //initialize the contact details needed for the page
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
    });
  }
}
