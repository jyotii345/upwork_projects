import 'dart:io';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart' as globals;

class GalleryView extends StatefulWidget {
  GalleryView(
    this.user,
    this.charterId,
    this.photos,
    this.trip,
  );

  User user;
  String charterId;
  List<Photo> photos;
  Trip trip;

  @override
  State<StatefulWidget> createState() => new GalleryViewState();
}

class GalleryViewState extends State<GalleryView> {
  /*
  instance vars
   */

  int pageIndex = 2;
  int indexMultiplier = 1;
  String errorMessage = "";
  List<Asset> images = <Asset>[];

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
      currentIndex: pageIndex,
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
    currentIndex = index - 1;
    Navigator.pop(context);
  }

  void handlePopupClick(String value) {
    switch (value) {
      case 'My Profile':
        currentIndex = 5;
        Navigator.pop(context);
    }
  }

  Widget getPageForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
            ),
            getPageTitle(),
            getDestination(),
            getDate(),
            getImageGrid(),
            Spacer(),
            getScrollButtons(),
          ],
        ),
      ),
    );
  }

  Widget getScrollButtons() {
    double iconSize = MediaQuery.of(context).size.width / 10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            child: Image(
                image: AssetImage("assets/leftarrow.png"),
                height: iconSize,
                width: iconSize),
            onPressed: () {
              if (indexMultiplier > 1) {
                setState(() {
                  indexMultiplier--;
                });
              }
            }),
        SizedBox(
          width: iconSize,
          height: iconSize,
        ),
        TextButton(
            child: Image(
                image: AssetImage("assets/rightarrow.png"),
                height: iconSize,
                width: iconSize),
            onPressed: () {
              if (widget.photos.length - (9 * (indexMultiplier - 1)) > 9) {
                setState(() {
                  indexMultiplier++;
                });
              }
            }),
      ],
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
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        "Date: " +
            months[DateTime.parse(widget.trip.tripDate).month - 1]
                .substring(0, 3) +
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
      child: widget.photos.length > 0
          ? GridView.builder(
              shrinkWrap: true,
              itemCount: widget.photos.length - (9 * (indexMultiplier - 1)) < 9
                  ? widget.photos.length - (9 * (indexMultiplier - 1))
                  : 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    imageExpansionDialogue(Image.file(
                      File(
                        widget
                            .photos[(index + (9 * (indexMultiplier - 1)))].imagePath,
                      ),
                      fit: BoxFit.cover,
                    ));
                  },
                  child: Image.file(
                    File(
                      widget.photos[index].imagePath,
                    ),
                    fit: BoxFit.cover,
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: MediaQuery.of(context).size.width / 6,
                  maxCrossAxisExtent: MediaQuery.of(context).size.width / 4,
                  childAspectRatio: 1.2 / 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
            )
          : Center(
              child: Text(
                "You have not uploaded any images to this gallery yet.",
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  void imageExpansionDialogue(Widget content) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(title: Container(), content: content),
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

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    if (await Permission.photos.status.isDenied ||
        await Permission.camera.status.isDenied) {
      await Permission.photos.request();
      await Permission.camera.request();

      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

    //try {
    resultList = await MultiImagePicker.pickImages(
      maxImages: 300,
      enableCamera: true,
      selectedAssets: images,
      cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
      materialOptions: MaterialOptions(
        actionBarColor: "#ff428cc7",
        actionBarTitle: "Aggressor Adventures",
        allViewTitle: "All Photos",
        useDetailsView: false,
        selectCircleStrokeColor: "#ff428cc7",
      ),
    );

    for (var result in resultList) {
      File file =
          File(await FlutterAbsolutePath.getAbsolutePath(result.identifier));

      print(result.identifier);
      print(result.name);
      // var response = await AggressorApi().uploadAwsFile(
      //     widget.user.userId, "gallery", widget.trip.charterId, file.path);
      // await Future.delayed(Duration(milliseconds: 1000));
      // if (response["status"] == "success") {
        widget.photos.add(Photo("", "", file.path, "", "", ""));
      //}
    }

    setState(() {
      photosLoaded = false;
    });

    if (!mounted) return;

    setState(() {
      errorMessage = error;
    });
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
                style: TextStyle(
                    color: AggressorColors.primaryColor,
                    fontSize: MediaQuery.of(context).size.height / 26,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              child: Image(
                image: AssetImage("assets/addphotosblue.png"),
                height: iconSize,
                width: iconSize,
              ),
              onPressed: loadAssets,
            ),
            TextButton(
                child: Image(
                    image: AssetImage("assets/trashcan.png"),
                    height: iconSize,
                    width: iconSize),
                onPressed: () {
                  //TODO implement button function
                }),
          ],
        ),
      ),
    );
  }
}
