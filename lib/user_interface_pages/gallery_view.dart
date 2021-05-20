import 'dart:io';

import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/aggressor_colors.dart';

class GalleryView extends StatefulWidget {
  GalleryView(this.charterId, this.photos, this.trip, this.callBackList);

  String charterId;
  List<Photo> photos;
  Trip trip;
  List<VoidCallback> callBackList;

  @override
  State<StatefulWidget> createState() => new GalleryViewState();
}

class GalleryViewState extends State<GalleryView> {
  /*
  instance vars
   */

  int index = 2;

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
    return Scaffold(
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
      bottomNavigationBar: getBottomNavigation(),
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
        ],
      ),
    );
  }

  /*
  Self implemented
   */

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
      onTap: (int) {
        handleBottomNavigation(int);
      },
      backgroundColor: AggressorColors.primaryColor,
      // new
      currentIndex: index,
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

  makeCall() async {
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  void handleBottomNavigation(int index) {
    widget.callBackList[index - 1]();
    Navigator.pop(context);
  }

  void handlePopupClick(String value) {
    switch (value) {
      case 'My Profile':
        widget.callBackList[5]();
        Navigator.pop(context);
    }
  }

  Widget getPageForm() {
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
            getPageTitle(),
            getDestination(),
            getDate(),
            getImageGrid(),
          ],
        ),
      ),
    );
  }

  Widget getDestination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        "Destination: " + widget.trip.detailDestination,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget getDate() {
    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        "Date: " +
            months[DateTime.parse(widget.trip.tripDate).month - 1].substring(0, 3) +
            " " +
            DateTime.parse(widget.trip.tripDate).day.toString() +
            "," +
            DateTime.parse(widget.trip.tripDate).year.toString(),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget getImageGrid() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: widget.photos.length - 1,
        itemBuilder: (context, index) {
          return Image.file(
            File(
              widget.photos[index].imagePath,
            ),
            fit: BoxFit.fill,
          );
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: (MediaQuery.of(context).size.width / 3), childAspectRatio: 1.2 / 1, crossAxisSpacing: 20, mainAxisSpacing: 20),
      ),
    );
  }

  Widget getBackgroundImage() {
    //this method return the blue background globe image that is lightly shown under the application, this also return the slightly tinted overview for it.
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.25), BlendMode.dstATop),
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
    double iconSize = MediaQuery.of(context).size.width / 10;
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "My Photos",
                style: TextStyle(color: AggressorColors.primaryColor, fontSize: MediaQuery.of(context).size.height / 26, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
                child: Image(
                  image: AssetImage("assets/addphotosblue.png"),
                  height: iconSize,
                  width: iconSize,
                ),
                onPressed: () {
                  //TODO implement button function
                }),
            TextButton(
                child: Image(image: AssetImage("assets/trashcan.png"), height: iconSize, width: iconSize),
                onPressed: () {
                  //TODO implement button function
                }),
          ],
        ),
      ),
    );
  }
}
