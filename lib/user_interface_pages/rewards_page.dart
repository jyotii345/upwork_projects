import 'package:aggressor_adventures/classes/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/aggressor_colors.dart';

class Rewards extends StatefulWidget {
  Rewards();

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
          Column(
            children: [
              Text(
                "My Certifications",
                style: TextStyle(color: AggressorColors.primaryColor),
              ),
              TextButton(
                onPressed: () {
                  print("pressed");
                },
                style: TextButton.styleFrom(
                    backgroundColor: AggressorColors.secondaryColor),
                child: Text(
                  "Add Iron Diver",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Club Membership",
                style: TextStyle(color: AggressorColors.primaryColor),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Iron Diver Awards",
                style: TextStyle(color: AggressorColors.primaryColor),
              ),
              TextButton(
                onPressed: () {
                  print("pressed");
                },
                style: TextButton.styleFrom(
                    backgroundColor: AggressorColors.secondaryColor),
                child: Text(
                  "Add Certification",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getProgressSection() {
    //returns the section of tha page that holds the progress bars
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text("VIP Progress Bar"),
          Text("VIPplus Progress Bar"),
          Text("7 Seas Progress Bar"),
          Text("Adventurer Progress Bar")
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
                  "First Last Name" +
                      "," +
                      "GA" +
                      "\nGuest since " +
                      "2010\nTotal Adventures - " +
                      "2",
                  textAlign: TextAlign.center,
                ),
                //TODO replace with the proper values for the user
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
                Text("969"),
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
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                if (sliderIndex < 2) {
                  setState(() {
                    sliderIndex++;
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

  @override
  bool get wantKeepAlive => true;
}
