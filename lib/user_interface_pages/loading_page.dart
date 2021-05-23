import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/gallery.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/photo_database.dart';
import 'package:aggressor_adventures/user_interface_pages/main_page.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

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
                percent > 1 ? Text("Downloading trip data: 100%", textAlign: TextAlign.center,) : Text("Downloading trip data: " +
                    int.parse((percent * 100).round().toString()).toString() +
                    "%", textAlign: TextAlign.center,),
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
    tripList = await AggressorApi().getReservationList(widget.user.contactId, loadingCallBack);

    print("trip list received");
    setState(() {
      loadedCount = tripList.length.toDouble();
      percent = ((loadedCount / loadingLength * 3));
    });

    if (tripList == null) {
      tripList = [];
    }

    for (var trip in tripList) {
      await trip.initCharterInformation();
      setState(() {
        loadedCount++;
        percent = ((loadedCount / (loadingLength * 3)));
      });
    }

    await getGalleries();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  user: widget.user,
                )));
  }

  Future<dynamic> getGalleries() async {
    //downloads images from aws. If the image is not already in storage, it will be stored on the device. Images are then added to a map based on their charterId that is used to display the images of the gallery.
    if (!photosLoaded) {
      String region = "us-east-1";
      String bucketId = "aggressor.app.user.images";
      final AwsS3Client s3client = AwsS3Client(
          region: region,
          host: "s3.$region.amazonaws.com",
          bucketId: bucketId,
          accessKey: "AKIA43MMI6CI2KP4CUUY",
          secretKey: "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");
      PhotoDatabaseHelper photoHelper = PhotoDatabaseHelper.instance;
      Map<String, Gallery> tempGalleries = <String, Gallery>{};

      try {
        for (var element in tripList) {
          setState(() {
            loadedCount++;
            percent = ((loadedCount / (tripList.length * 3)));
          });
          var response;
          try {
            response = await s3client.listObjects(
                prefix:
                    widget.user.userId + "/gallery/" + element.charterId + "/",
                delimiter: "/");
          } catch (e) {
            print(e);
          }

          if (response.contents != null) {
            for (var content in response.contents) {
              var elementJson = await jsonDecode(content.toJson());
              if (elementJson["Size"] != "0") {
                if (!tempGalleries.containsKey(element.charterId)) {
                  tempGalleries[element.charterId] = Gallery(
                      widget.user, element.charterId, <Photo>[], element);
                }
                if (!await photoHelper.keyExists(elementJson["Key"])) {
                  StreamedResponse downloadResponse = await AggressorApi()
                      .downloadAwsFile(elementJson["Key"].toString());

                  Uint8List bytes =
                      await readByteStream(downloadResponse.stream);

                  String fileName =
                      downloadResponse.headers["content-disposition"];
                  int whereIndex = fileName.indexOf("=");
                  fileName = fileName.substring(whereIndex + 1);
                  fileName.replaceAll("\"", "");

                  Directory appDocumentsDirectory =
                      await getApplicationDocumentsDirectory(); // 1
                  String appDocumentsPath = appDocumentsDirectory.path; // 2
                  String filePath = '$appDocumentsPath/$fileName';
                  print(filePath);
                  File imageFile = File(filePath);
                  imageFile.writeAsBytes(bytes);

                  Photo photo = Photo(
                      fileName,
                      widget.user.userId,
                      imageFile.path,
                      element.tripDate,
                      element.charterId,
                      elementJson["Key"]);

                  photoHelper.insertPhoto(photo);
                }
              }
            }
          }
        }
      } catch (e) {
        print(e.toString());
      }

      List<Photo> photos = await photoHelper.queryPhoto();
      photos.forEach((element) {
        if (!tempGalleries.containsKey(element.charterId)) {
          int tripIndex = 0;
          for (int i = 0; i < tripList.length - 1; i++) {
            if (tripList[i].charterId == element.charterId) {
              tripIndex = i;
            }
          }
          tempGalleries[element.charterId] = Gallery(
            widget.user,
            element.charterId,
            <Photo>[],
            tripList[tripIndex],
          );
        }
        tempGalleries[element.charterId].addPhoto(element);
      });

      setState(() {
        galleriesMap = tempGalleries;
        photosLoaded = true;
      });
    }
    return "finished";
  }

  VoidCallback loadingCallBack(){
    setState(() {
      loadedCount++;
      percent = ((loadedCount / (loadingLength * 3)));
    });
  }
}
