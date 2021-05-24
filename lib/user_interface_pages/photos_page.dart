import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/gallery.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/photo_database.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aggressor_adventures/classes/globals.dart' as galleryMap;

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

  Trip dropDownValue, selectionTrip;
  String departureDate = "", errorMessage = "";
  List<Trip> sortedTripList;
  List<dynamic> galleriesList = [];
  List<Asset> images = <Asset>[];
  bool loading = true;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    selectionTrip =
        Trip(DateTime.now().toString(), "", "", "", " -- SELECT -- ", "", "");
    selectionTrip.charter = Charter(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      " -- SELECT -- ",
    );
    dropDownValue = selectionTrip;
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
        Container(
          height: MediaQuery.of(context).size.height / 7 + 4,
          width: double.infinity,
          color: AggressorColors.secondaryColor,
        ),
        getBannerImage(),
      ],
    );
  }

  /*
  Self implemented
   */

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
            showLoading(),
            getPageTitle(),
            getCreateNewGallery(),
            getMyGalleries(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget getDestinationDropdown(List<Trip> tripList) {
    sortedTripList = [selectionTrip];
    tripList = sortTripList(tripList);
    tripList.forEach((element) {
      sortedTripList.add(element);
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Destination:",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 35,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: DropdownButton<Trip>(
                underline: Container(),
                value: dropDownValue,
                elevation: 0,
                isExpanded: true,
                iconSize: MediaQuery.of(context).size.height / 35,
                onChanged: (Trip newValue) {
                  setState(() {
                    dropDownValue = newValue;
                    departureDate = DateTime.parse(newValue.charter.startDate)
                            .month
                            .toString() +
                        "/" +
                        DateTime.parse(newValue.charter.startDate)
                            .day
                            .toString() +
                        "/" +
                        DateTime.parse(newValue.charter.startDate)
                            .year
                            .toString();
                  });
                },
                items: sortedTripList.map<DropdownMenuItem<Trip>>((Trip value) {
                  return DropdownMenuItem<Trip>(
                    value: value,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        value.charter.destination == " -- SELECT -- "
                            ? value.charter.destination
                            : value.charter.destination +
                                " - " +
                                DateTime.parse(value.charter.startDate)
                                    .month
                                    .toString() +
                                "/" +
                                DateTime.parse(value.charter.startDate)
                                    .day
                                    .toString() +
                                "/" +
                                DateTime.parse(value.charter.startDate)
                                    .year
                                    .toString(),
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height / 40 - 4),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Trip> sortTripList(List<Trip> tripList) {
    List<Trip> tempList = tripList;
    tempList.sort((a, b) =>
        DateTime.parse(b.tripDate).compareTo(DateTime.parse(a.tripDate)));

    return tempList;
  }

  Widget getDepartureInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Departure Date:",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
            ),
          ),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.height / 35,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Text(
                  departureDate,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 40 - 4),
                  textAlign: TextAlign.center,
                )),
          ),
        ],
      ),
    );
  }

  Widget getUploadPhotosButton() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height / 4,
        ),
        TextButton(
          onPressed: loadAssets,
          child: Text(
            "Upload Photos",
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
              backgroundColor: AggressorColors.secondaryColor),
        ),
      ],
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = '';

    setState(() {
      errorMessage = "";
    });

    if (await Permission.photos.status.isDenied ||
        await Permission.camera.status.isDenied) {
      await Permission.photos.request();
      await Permission.camera.request();

      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

    if (dropDownValue.charter.destination == " -- SELECT -- ") {
      setState(() {
        errorMessage = "You must select a trip to create a gallery for.";
      });
    } else {
      //try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#ff428cc7",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#ff428cc7",
        ),
      );

      for (var element in resultList) {
        File file =
            File(await FlutterAbsolutePath.getAbsolutePath(element.identifier));

        var response = await AggressorApi().uploadAwsFile(
            widget.user.userId, "gallery", dropDownValue.charterId, file.path);

        await Future.delayed(Duration(milliseconds: 1000));
        if (response["status"] == "success") {
          setState(() {
            photosLoaded = false;
          });
        }
      }
      ;

      if (!mounted) return;

      setState(() {
        images = resultList;
        errorMessage = error;
        photosLoaded = false;
      });
    }
  }

  Widget getCreateNewGallery() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CREATE NEW GALLERY",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: MediaQuery.of(context).size.height / 35,
                fontWeight: FontWeight.bold),
          ),
          getDestinationDropdown(tripList),
          getDepartureInformation(),
          getUploadPhotosButton(),
        ],
      ),
    );
  }

  Widget getMyGalleries() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MY GALLERIES",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: MediaQuery.of(context).size.height / 35,
                fontWeight: FontWeight.bold),
          ),
          getGalleriesSection(),
        ],
      ),
    );
  }

  Widget getGalleriesSection() {
    double textBoxSize = MediaQuery.of(context).size.width / 4;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        color: Colors.white,
        child: galleryMap.galleriesMap.length == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: .5,
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: textBoxSize,
                            child: Text("Destination",
                                textAlign: TextAlign.center),
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

    getGalleries();

    double textBoxSize = MediaQuery.of(context).size.width / 4;
    galleriesList.clear();
    galleriesList.add(
      Container(
        width: double.infinity,
        color: Colors.grey[100],
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
                    child: Text("Destination", textAlign: TextAlign.left),
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
    galleryMap.galleriesMap.forEach((key, value) {
      galleriesList.add(value.getGalleryRow(context, index));
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

  Widget getPageTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Photos",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<dynamic> getGalleries() async {
    //downloads images from aws. If the image is not already in storage, it will be stored on the device. Images are then added to a map based on their charterId that is used to display the images of the gallery.

    setState(() {
      loading = true;
    });
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
              widget.user, element.charterId, <Photo>[], tripList[tripIndex]);
        }
        tempGalleries[element.charterId].addPhoto(element);
      });

      setState(() {
        galleryMap.galleriesMap = tempGalleries;
        photosLoaded = true;
      });
    }
    // setState(() {
    //   loading = false; TODO remove these comments after testing
    // });
    return "finished";
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

  Widget showLoading(){
    return loading ? LinearProgressIndicator(color: AggressorColors.primaryColor,) : Container();
  }

  @override
  bool get wantKeepAlive => true;
}
