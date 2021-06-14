import 'dart:io';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/photo.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/aggressor_colors.dart';

class GalleryView extends StatefulWidget {
  GalleryView(
    this.user,
    this.charterId,
    this.photos,
    this.trip,
  );

  final User user;
  final String charterId;
  final List<Photo> photos;
  final Trip trip;

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
    popDistance = 1;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(),
      bottomNavigationBar: getBottomNavigationBar(),
      body: PinchToZoom(
        OrientationBuilder(
          builder: (context, orientation) {
            portrait = orientation == Orientation.portrait;
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
          },
        ),
      ),
    );
  }

  /*
  Self implemented
   */

  Widget getPageForm() {
    //returns the main contents of the page
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
            Spacer(),
            getScrollButtons(),
          ],
        ),
      ),
    );
  }

  Widget getScrollButtons() {
    //returns arrow images to scroll pages on the bottom of the page

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        indexMultiplier > 1
            ? TextButton(
                child: Image(
                    image: AssetImage("assets/leftarrow.png"),
                    height: portrait ? iconSizePortrait : iconSizeLandscape,
                    width: portrait ? iconSizePortrait : iconSizeLandscape),
                onPressed: () {
                  if (indexMultiplier > 1) {
                    setState(() {
                      indexMultiplier--;
                    });
                  }
                })
            : Container(
                width: portrait ? iconSizePortrait : iconSizeLandscape,
              ),
        SizedBox(
          width: portrait ? iconSizePortrait : iconSizeLandscape,
          height: portrait ? iconSizePortrait : iconSizeLandscape,
        ),
        widget.photos.length - (9 * (indexMultiplier - 1)) > 9
            ? TextButton(
                child: Image(
                    image: AssetImage("assets/rightarrow.png"),
                    height: portrait ? iconSizePortrait : iconSizeLandscape,
                    width: portrait ? iconSizePortrait : iconSizeLandscape),
                onPressed: () {
                  if (widget.photos.length - (9 * (indexMultiplier - 1)) > 9) {
                    setState(() {
                      indexMultiplier++;
                    });
                  }
                })
            : Container(
                width: portrait ? iconSizePortrait : iconSizeLandscape,
              ),
      ],
    );
  }

  Widget getDestination() {
    //returns the destination widgets of the gallery
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        "Destination: " + widget.trip.detailDestination,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: portrait
            ? MediaQuery.of(context).size.height / 50
            : MediaQuery.of(context).size.width / 50),
      ),
    );
  }

  Widget getDate() {
    //returns the date widgets of the gallery
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
            ", " +
            DateTime.parse(widget.trip.tripDate).year.toString(),
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: portrait
            ? MediaQuery.of(context).size.height / 50
            : MediaQuery.of(context).size.width / 50),
      ),
    );
  }

  Widget getImageGrid() {
    //returns the grid of the images to be displayed
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
                        widget.photos[(index + (9 * (indexMultiplier - 1)))]
                            .imagePath,
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
    //shows the image in a larger view
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
        fit: BoxFit.fill,
      ),
    );
  }

  Widget showErrorMessage() {
    //displays an error message if there is one
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
    //loads the asset objects from the image picker
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    if (await Permission.photos.status.isDenied ||
        await Permission.camera.status.isDenied) {
      await Permission.photos.request();
      await Permission.camera.request();
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
      String path = "";
      if (result.name.toLowerCase().contains(".heic")) {
        path = await HeicToJpg.convert(
            await FlutterAbsolutePath.getAbsolutePath(result.identifier));
      } else {
        path = await FlutterAbsolutePath.getAbsolutePath(result.identifier);
      }
      File file = File(path);

      String uploadDate = formatDate(
          DateTime.parse(widget.trip.charter.startDate),
          [yyyy, '-', mm, '-', dd]);

      var response = await AggressorApi().uploadAwsFile(widget.user.userId,
          "gallery", widget.trip.charterId, file.path, uploadDate);
      await Future.delayed(Duration(milliseconds: 1000));
      if (response["status"] == "success") {
        widget.photos.add(Photo("", "", file.path, "", "", ""));
      }
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
    //returns the title of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "My Photos",
                style: TextStyle(
                    color: AggressorColors.primaryColor,
                    fontSize: portrait ? MediaQuery.of(context).size.height / 26 : MediaQuery.of(context).size.width / 26,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              child: Image(
                image: AssetImage("assets/addphotosblue.png"),
                height: portrait ? iconSizePortrait : iconSizeLandscape,
                width: portrait ? iconSizePortrait : iconSizeLandscape,
              ),
              onPressed: loadAssets,
            ),
            TextButton(
                child: Image(
                    image: AssetImage("assets/trashcan.png"),
                    height: portrait ? iconSizePortrait : iconSizeLandscape,
                    width: portrait ? iconSizePortrait : iconSizeLandscape),
                onPressed: () {
                  //TODO implement button function
                }),
          ],
        ),
      ),
    );
  }
}
