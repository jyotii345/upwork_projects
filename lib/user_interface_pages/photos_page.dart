import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/gallery.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/offline_database.dart';
import 'package:aggressor_adventures/databases/photo_database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Photos extends StatefulWidget {
  Photos(
    this.user,
  );

  final User user;

  @override
  State<StatefulWidget> createState() => new PhotosState();
}

class PhotosState extends State<Photos> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  Map<String, dynamic>? dropDownValue = boatList.isEmpty ? null : boatList[0];
  String departureDate = "", errorMessage = "";
  List<dynamic> galleriesList = [];
  List<XFile> images = <XFile>[];
  bool loading = false;
  List<Trip> dateDropDownList = [];
  Trip dateDropDownValue = Trip(
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  );
  bool uploading = false;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    dateDropDownValue = Trip(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    );
    dateDropDownValue.charter = Charter("", "", "", "", "", "", "", "", "");
    // dropDownValue =boatList.isEmpty?null: boatList[0];
    if (boatList.isEmpty) {
      getBoatList();
    }
    if (tripList.isEmpty) {
      updateTripListList();
    }
  }

  updateTripListList() async {
    setState(() {
      loading = true;
    });
    var tempList =
        await AggressorApi().getReservationList(widget.user.contactId!, () {});
    tripList = tempList;
    for (var trip in tripList) {
      trip.user = widget.user;
      await trip.initCharterInformation();

      // setState(() {
      //   if(percent<0.9){
      //     percent += .05;
      //   }
      //   // percent += (loadedCount / (loadingLength));
      // });
    }

    await getGalleries();
    setState(() {
      loading = false;
    });
  }

  void getBoatList() async {
    //set the initial boat list
    setState(() {
      loading = true;
    });
    boatList = await AggressorApi().getBoatList();
    dropDownValue = boatList.isEmpty ? null : boatList[0];

    setState(() {
      loading = false;
    });
  }

  /*
  Build
   */
  @override
  Widget build(BuildContext context) {
    super.build(context);

    homePage = true;

    // getGalleries();

    return PinchToZoom(
      OrientationBuilder(builder: (context, orientation) {
        portrait = orientation == Orientation.portrait;
        return Stack(
          children: [
            getBackgroundImage(),
            getWhiteOverlay(),
            getPageForm(),
          ],
        );
      }),
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
    //returns the main contents of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListView(
        children: [
          getBannerImage(),
          showOffline(),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: showLoading(),
          // ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getPageTitle(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getCreateNewGallery(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getMyGalleries(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: showErrorMessage(),
          ),
        ],
      ),
    );
  }

  Widget getYachtDropDown(List<Map<String, dynamic>> boatList) {
    //returns a drop down of all yachts that an adventure is associated with

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: AutoSizeText(
              "Adventure:",
              maxLines: 1,
              minFontSize: 3.0,
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4.2
                : MediaQuery.of(context).size.width / 2.6,
            height: portrait
                ? MediaQuery.of(context).size.height / 35
                : MediaQuery.of(context).size.width / 35,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: DropdownButton<Map<String, dynamic>>(
              underline: Container(),
              value: dropDownValue,
              elevation: 0,
              isExpanded: true,
              iconSize: portrait
                  ? MediaQuery.of(context).size.height / 35
                  : MediaQuery.of(context).size.width / 35,
              onChanged: (Map<String, dynamic>? newValue) async {
                dropDownValue = newValue!;

                dateDropDownList = await getDateDropDownList(newValue);

                setState(() {});
              },
              items: boatList.map<DropdownMenuItem<Map<String, dynamic>>>(
                  (Map<String, dynamic> value) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: value,
                  child: Container(
                    width: portrait
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.height / 2,
                    child: AutoSizeText(
                      value["name"],
                      maxLines: 1,
                      minFontSize: 3.0,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDateDropDown() {
    //returns a drop down of all dates when a trip is on a particular yacht

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: AutoSizeText(
              "Departure Date:",
              maxLines: 1,
              minFontSize: 3.0,
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4.2
                : MediaQuery.of(context).size.width / 2.5,
            height: portrait
                ? MediaQuery.of(context).size.height / 35
                : MediaQuery.of(context).size.width / 35,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: DropdownButton<Trip>(
              underline: Container(),
              value: dateDropDownValue,
              elevation: 0,
              isExpanded: true,
              iconSize: portrait
                  ? MediaQuery.of(context).size.height / 35
                  : MediaQuery.of(context).size.width / 35,
              onChanged: (Trip? newValue) {
                setState(() {
                  dateDropDownValue = newValue!;
                });
              },
              items: dateDropDownList.map<DropdownMenuItem<Trip>>((Trip value) {
                return DropdownMenuItem<Trip>(
                  value: value,
                  child: Container(
                    width: portrait
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.height / 2,
                    child: AutoSizeText(
                      value.charter == null
                          ? "You don't have adventures here yet."
                          : DateTime.parse(
                                      value.charter!.startDate!)
                                  .month
                                  .toString() +
                              "/" +
                              DateTime.parse(value.charter!.startDate!)
                                  .day
                                  .toString() +
                              "/" +
                              DateTime.parse(value.charter!.startDate!)
                                  .year
                                  .toString(),
                      maxLines: 1,
                      minFontSize: 3.0,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Trip>> getDateDropDownList(Map<String, dynamic> boatMap) async {
    //generates the list of dates a trip is scheduled on a particular yacht
    List<Trip> tempList = [];
// Future.forEach(tripList, (element) => null)

    await Future.forEach(tripList, (Trip element) {
      if (element.boat != null &&
          (element.boat!.boatId.toString() == boatMap["boatid"].toString() ||
              element.boat!.boatId.toString() ==
                  boatMap["boatId"].toString())) {
        tempList.add(element);
      }
    });

    if (tempList.length == 0) {
      tempList = [Trip("", "", "", "", "", "", "", "", "")];
    }

    setState(() {
      dateDropDownValue = tempList[0];
    });

    return tempList;
  }

  Widget getUploadPhotosButton() {
    //returns the button to create a new gallery
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4.2
                : MediaQuery.of(context).size.width / 2.5,
            child: TextButton(
              onPressed: uploading ? () {} : loadAssets,
              child: AutoSizeText(
                uploading ? "Uploading, please wait..." : "Upload Photos",
                style: TextStyle(color: Colors.white),
                maxLines: 1,
                minFontSize: 3.0,
              ),
              style: TextButton.styleFrom(
                  backgroundColor: AggressorColors.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadAssets() async {
    //loads images as an asset object that are selected from an image picker
    List<XFile> resultList = <XFile>[];
    String error = '';

    setState(() {
      uploading = true;
      errorMessage = "";
    });

    if (await Permission.photos.status.isDenied ||
        await Permission.camera.status.isDenied) {
      await Permission.photos.request();
      await Permission.camera.request();

      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

    if (dropDownValue!["name"] == " -- SELECT -- " ||
        dateDropDownValue.charter == null ||
        dateDropDownValue.charter!.startDate == "") {
      setState(() {
        errorMessage = "You must select a trip to create a gallery for.";
      });
    } else {
      resultList = await ImagePicker().pickMultiImage();
      setState(() {
        loading = true;
      });

      if (online) {
        for (var element in resultList) {
          String path = "";
          if (element.name.toLowerCase().contains(".heic")) {
            // path = (await HeicToJpg.convert(
            //     await FlutterAbsolutePath.getAbsolutePath(element.identifier)))!;
          } else {
            // path =
            // await FlutterAbsolutePath.getAbsolutePath(element.identifier);
          }
          File file = File(path);

          String uploadDate = formatDate(
              DateTime.parse(dateDropDownValue.charter!.startDate!),
              [yyyy, '-', mm, '-', dd]);

          await AggressorApi().uploadAwsFile(
              widget.user.userId.toString(),
              "gallery",
              dateDropDownValue.charter!.boatId.toString(),
              file.path,
              uploadDate);

          await Future.delayed(Duration(milliseconds: 1000));
        }

        setState(() {
          photosLoaded = false;
          uploading = false;
          loading = false;
          images = resultList;
          errorMessage = error;
        });

        if (!mounted) return;
      } else {
        for (var element in resultList) {
          String path = "";
          if (element.name.toLowerCase().contains(".heic")) {
            // path = (await HeicToJpg.convert(
            //     await FlutterAbsolutePath.getAbsolutePath(element.identifier)))!;
          } else {
            // path =
            //     await FlutterAbsolutePath.getAbsolutePath(element.identifier);
          }
          File file = File(path);

          String uploadDate = formatDate(
              DateTime.parse(dateDropDownValue.charter!.startDate!),
              [yyyy, '-', mm, '-', dd]);

          await PhotoDatabaseHelper.instance.insertPhoto(Photo(
              imageName: element.name,
              userId: widget.user.userId!,
              imagePath: file.path,
              date: uploadDate,
              boatId: dateDropDownValue.charter!.boatId!,
              key: null));
          await OfflineDatabaseHelper.instance.insertOffline(
              {'type': "image", 'action': "add", 'id': file.path});
        }

        setState(() {
          photosLoaded = false;
          loading = false;
          images = resultList;
          errorMessage = error;
        });

        if (!mounted) return;

        setState(() {
          loading = false;
          uploading = false;
        });
      }
    }
  }

  Widget getCreateNewGallery() {
    //returns the create a gallery section of the page
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (dropDownValue == null || loading)
              ? Center(child: CircularProgressIndicator())
              : Wrap(
                  // physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                      "Create new gallery",
                      style: TextStyle(
                          color: AggressorColors.secondaryColor,
                          fontSize: portrait
                              ? MediaQuery.of(context).size.height / 40
                              : MediaQuery.of(context).size.width / 40,
                          fontWeight: FontWeight.bold),
                    ),
                    getYachtDropDown(boatList),
                    getDateDropDown(),
                    getUploadPhotosButton(),
                  ],
                )
        ],
      ),
    );
  }

  Widget getMyGalleries() {
    //returns the header for the my galleries section
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My galleries",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: portrait
                    ? MediaQuery.of(context).size.height / 40
                    : MediaQuery.of(context).size.width / 40,
                fontWeight: FontWeight.bold),
          ),
          getGalleriesSection(),
        ],
      ),
    );
  }

  Widget getGalleriesSection() {
    //returns the gallery section of the page
    double textBoxSize = portrait
        ? MediaQuery.of(context).size.width / 4
        : MediaQuery.of(context).size.height / 4;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        color: Colors.white,
        child: galleriesMap.length == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: .5,
                    color: Colors.grey,
                  ),
                  Container(
                    color: AggressorColors.accentYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: textBoxSize,
                            child:
                                Text("Adventure", textAlign: TextAlign.center),
                          ),
                        ),
                        SizedBox(
                          width: textBoxSize,
                          child: Text("Date", textAlign: TextAlign.center),
                        ),
                        SizedBox(
                          width: textBoxSize / 2,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Text(
                        "You do not have any photo galleries to view yet."),
                  ),
                ],
              )
            : getGalleriesListView(),
      ),
    );
  }

  Widget getGalleriesListView() {
    //returns the list item containing gallery objects

    double textBoxSize = portrait
        ? MediaQuery.of(context).size.width / 4
        : MediaQuery.of(context).size.height / 4;
    galleriesList.clear();
    galleriesList.add(
      Container(
        width: double.infinity,
        color: AggressorColors.accentYellow,
        child: Column(
          children: [
            Container(
              height: .5,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    width: textBoxSize,
                    child: Text("Adventure", textAlign: TextAlign.left),
                  ),
                ),
                SizedBox(
                  width: textBoxSize,
                  child: Text("Date", textAlign: TextAlign.left),
                ),
                SizedBox(
                  width: textBoxSize / 2,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    int index = 0;
    galleriesMap.forEach((key, value) {
      if (value.photos!.length > 0) {
        galleriesList.add(value.getGalleryRow(context, index));
        galleriesMap[key]!.setCallback(pageCallback);
      }
      index++;
    });

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: galleriesList.length,
        itemBuilder: (context, position) {
          return galleriesList[position];
        });
  }

  VoidCallback pageCallback() {
    return () {
      setState(() {
        photosLoaded = false;
      });
    };
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
    return Image.asset(
      "assets/bannerimage.png",
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.scaleDown,
    );
  }

  Widget getPageTitle() {
    //returns the title of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Photos",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 30
                  : MediaQuery.of(context).size.width / 30,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<dynamic> getGalleries() async {
    //downloads images from aws. If the image is not already in storage, it will be stored on the device. Images are then added to a map based on their charterId that is used to display the images of the gallery.

    if (!photosLoaded && online) {
      setState(() {
        loading = true;
      });

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
          var response;
          try {
            response = await s3client.listObjects(
                prefix: widget.user.userId! +
                    "/gallery/" +
                    element.boat!.boatId! +
                    "/" +
                    formatDate(DateTime.parse(element.charter!.startDate!),
                        [yyyy, '-', mm, '-', dd]).toString() +
                    "/",
                delimiter: "/");
          } catch (e) {
            print(e.toString());
          }

          if (response.contents != null) {
            for (var content in response.contents) {
              var elementJson = await jsonDecode(content.toJson());
              if (elementJson["Size"] != "0") {
                if (!tempGalleries.containsKey(element.reservationId)) {
                  tempGalleries[element.reservationId!] = Gallery(
                      widget.user, element.reservationId!, <Photo>[], element);
                }
                if (!await photoHelper.keyExists(elementJson["Key"])) {
                  StreamedResponse downloadResponse = await AggressorApi()
                      .downloadAwsFile(elementJson["Key"].toString());

                  Uint8List bytes =
                      await readByteStream(downloadResponse.stream);

                  String fileName =
                      downloadResponse.headers["content-disposition"]!;
                  int whereIndex = fileName.indexOf("=");
                  fileName = fileName.substring(whereIndex + 1);
                  fileName.replaceAll("\"", "");

                  Directory appDocumentsDirectory =
                      await getApplicationDocumentsDirectory(); // 1
                  String appDocumentsPath = appDocumentsDirectory.path; // 2
                  String filePath = '$appDocumentsPath/$fileName';
                  File imageFile = File(filePath);
                  imageFile.writeAsBytes(bytes);

                  await element.initCharterInformation();

                  Photo photo = Photo(
                      imageName: fileName,
                      userId: widget.user.userId!,
                      imagePath: imageFile.path,
                      date: element.tripDate!,
                      boatId: element.boat!.boatId!,
                      key: elementJson["Key"]);

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
        int tripIndex = 0;
        for (int i = 0; i < tripList.length; i++) {
          // print(tripList[i].boat.boatId + " " + element.boatId);
          // print( formatDate(DateTime.parse(tripList[i].charter.startDate),
          //     [yyyy, '-', mm, '-', dd]).toString() + " " +
          //     element.date);

          if (tripList[i].boat!.boatId == element.boatId &&
              formatDate(DateTime.parse(tripList[i].charter!.startDate!),
                      [yyyy, '-', mm, '-', dd]).toString() ==
                  element.date) {
            tripIndex = i;
          }
        }

        if (!tempGalleries.containsKey(tripList[tripIndex].reservationId)) {
          tempGalleries[tripList[tripIndex].reservationId!] = Gallery(
              widget.user,
              element.boatId ?? "",
              <Photo>[],
              tripList[tripIndex]);
        } else {
          if (!tempGalleries[tripList[tripIndex].reservationId]!
              .photos!
              .contains(element)) {
            tempGalleries[tripList[tripIndex].reservationId]!.addPhoto(element);
          }
        }
      });

      if (mounted) {
        setState(() {
          galleriesMap = tempGalleries;
          photosLoaded = true;
          loading = false;
        });
      }
    } else if (!photosLoaded && !online) {
      setState(() {
        loading = true;
      });
      var tempPhotosList = await PhotoDatabaseHelper.instance.queryPhoto();
      var tempGalleriesMap = await getGalleriesOffline(tempPhotosList);
      setState(() {
        galleriesMap = tempGalleriesMap;
        photosLoaded = true;
        loading = false;
      });
    }
    return "finished";
  }

  Widget showErrorMessage() {
    // displays an error message if there is one
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

  Widget showLoading() {
    // displays a loading bar if data is being downloaded
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

  Widget showOffline() {
    // displays offline when the application does not have internet connection
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

  Future<dynamic> getGalleriesOffline(List<Photo> photos) async {
    // downloads images from aws. If the image is not already in storage, it will be stored on the device. Images are then added to a map based on their charterId that is used to display the images of the gallery.

    Map<String, Gallery> tempGalleries = <String, Gallery>{};
    photos.forEach((element) {
      int tripIndex = 0;
      for (int i = 0; i < tripList.length - 1; i++) {
        if (tripList[i].boat!.boatId! == element.boatId &&
            formatDate(DateTime.parse(tripList[i].charter!.startDate!),
                    [yyyy, '-', mm, '-', dd]) ==
                element.date) {
          tripIndex = i;
        }
      }

      if (!tempGalleries.containsKey(tripList[tripIndex].reservationId)) {
        tempGalleries[tripList[tripIndex].reservationId!] = Gallery(
            widget.user, element.boatId!, <Photo>[], tripList[tripIndex]);
      } else {
        tempGalleries[tripList[tripIndex].reservationId]!.addPhoto(element);
      }
    });
    return tempGalleries;
  }

  @override
  bool get wantKeepAlive => true;
}
