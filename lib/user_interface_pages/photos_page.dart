import 'dart:io';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/aws_helper.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Photos extends StatefulWidget {
  Photos(this.user, this.tripList);

  final List<Trip> tripList;
  final User user;

  @override
  State<StatefulWidget> createState() => new PhotosState();
}

class PhotosState extends State<Photos> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  Trip dropDownValue, selectionTrip;
  String departureDate = "", errorMessage;
  List<Trip> sortedTripList;
  List<dynamic> galleriesList = [];

  List<Asset> images = <Asset>[];

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    selectionTrip =
        Trip(DateTime.now().toString(), "", "", "", " -- SELECT -- ", "", "");
    selectionTrip.detailDestination = " -- SELECT -- ";
    dropDownValue = selectionTrip;
    getGalleries();
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
          Container(
            height: MediaQuery.of(context).size.height / 35,
            width: MediaQuery.of(context).size.width / 1.75,
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
                  departureDate = newValue.tripDate;
                });
              },
              items: sortedTripList.map<DropdownMenuItem<Trip>>((Trip value) {
                return DropdownMenuItem<Trip>(
                  value: value,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      value.detailDestination,
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
            getCreateNewGallery(),
            getMyGalleries(), //TODO finish my galleries listview
          ],
        ),
      ),
    );
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
          Container(
              height: MediaQuery.of(context).size.height / 35,
              width: MediaQuery.of(context).size.width / 1.75,
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
        actionBarTitle: "Example App",
        allViewTitle: "All Photos",
        useDetailsView: false,
        selectCircleStrokeColor: "#ff428cc7",
      ),
    );

    //TODO upload to aws for testing
    print(File(
        await FlutterAbsolutePath.getAbsolutePath(resultList[0].identifier)));

    String region = "us-east-1";
    String bucketId = "aggressor.app.user.images";
    String directory = widget.user.userId.toString() +
        "/gallery/" +
        selectionTrip.charterId.toString() +
        "_" +
        selectionTrip.tripDate.toString();

    File file = File(
        await FlutterAbsolutePath.getAbsolutePath(resultList[0].identifier));

    print("uploading");
    await AwsS3.uploadFile(
      accessKey: "AKIA43MMI6CI2KP4CUUY",
      secretKey: "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",
      file: file,
      bucket: bucketId,
      region: region,
      destDir: directory,
    );
    // } catch (e) {
    //   print(e.toString());
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      errorMessage = error;
    });
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
          getDestinationDropdown(widget.tripList),
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
    double textBoxSize = MediaQuery.of(context).size.width / 4.3;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 6.5,
            width: double.infinity,
            child: FutureBuilder(
              future: getGalleries(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  galleriesList.clear();
                  if (snapshot.data.keyCount == 0) {
                    galleriesList = [];
                  } else {
                    print("handle galleries objects here");
                  }

                  return galleriesList.length == 0
                      ? Column(
                          children: [
                            Container(
                              height: .5,
                              color: Colors.grey,
                            ),
                            Container(
                              color: Colors.grey[300],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: textBoxSize,
                                    child: Text("Destination:",
                                        textAlign: TextAlign.center),
                                  ),
                                  Spacer(
                                    flex: 10,
                                  ),
                                  SizedBox(
                                    width: textBoxSize,
                                    child: Text("Date:",
                                        textAlign: TextAlign.center),
                                  ),
                                  Spacer(
                                    flex: 10,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                  "You do not have any photo galleries to view yet."),
                            ),
                          ],
                        )
                      : getGalleriesListView(galleriesList);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getGalleriesListView(List<dynamic> galleryFutureList) {
    //returns the list item containing gallery objects

    double textBoxSize = MediaQuery.of(context).size.width / 4.3;
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
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: textBoxSize,
                  child: Text("Destination", textAlign: TextAlign.center),
                ),
                Spacer(
                  flex: 10,
                ),
                SizedBox(
                  width: textBoxSize,
                  child: Text("Date", textAlign: TextAlign.center),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    int index = 0;
    galleryFutureList.forEach((element) {
      galleriesList.add(element.getPastTripCard(context, index));
      index++;
    });

    return ListView.builder(
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

  Future<ListBucketResult> getGalleries() async {
    String region = "us-east-1";
    String bucketId = "aggressor.app.user.images";
    final AwsS3Client s3client = AwsS3Client(
        region: region,
        host: "s3.$region.amazonaws.com",
        bucketId: bucketId,
        accessKey: "AKIA43MMI6CI2KP4CUUY",
        secretKey: "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");
    ListBucketResult listBucketResult;
    try {
       listBucketResult = await s3client.listObjects(
          prefix: widget.user.userId + "/gallery/", delimiter: "/");
    }
    catch(e){
      print(e.toString());
      listBucketResult = ListBucketResult();
    }
    return listBucketResult;
  }

  @override
  bool get wantKeepAlive => true;
}
