import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/file_data.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/files_database.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class MyFiles extends StatefulWidget {
  MyFiles(
    this.user,
  );

  final User user;

  @override
  State<StatefulWidget> createState() => new MyFilesState();
}

class MyFilesState extends State<MyFiles> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  String fileName = "";

  Trip dropDownValue, selectionTrip;

  bool loading = false;
  bool uploading = false;

  List<dynamic> filesList = [];
  List<dynamic> fileNameList = [];
  List<Trip> sortedTripList;

  String errorMessage = "";

  FilePickerResult result;

  TextEditingController fileNameController = TextEditingController();

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    selectionTrip =
        Trip(DateTime.now().toString(), "", "", "", "General", "", "", "", "");
    selectionTrip.detailDestination = "General";
    selectionTrip.charterId = "General";
    dropDownValue = selectionTrip;
  }

  /*
  Build
   */

  @override
  Widget build(BuildContext context) {
    super.build(context);

     //clearFiles();
    getFiles();

    return OrientationBuilder(builder: (context, orientation) {
      portrait = orientation == Orientation.portrait;
      return PinchToZoom(
        Stack(
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
    });
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
            showOffline(),
            showLoading(),
            getPageTitle(),
            getUploadFile(),
            getFilesSection(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget getUploadFile() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Upload file",
              style: TextStyle(
                  color: AggressorColors.secondaryColor,
                  fontSize: portrait
                      ? MediaQuery.of(context).size.height / 40
                      : MediaQuery.of(context).size.width / 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
          getFilePrompt(),
          getDestinationDropdown(tripList),
          getFileInformation(),
          getFileName(),
          getUploadFileButton(),
        ],
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
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: Text(
              "Destination:",
              style: TextStyle(
                  fontSize: portrait
                      ? MediaQuery.of(context).size.height / 50
                      : MediaQuery.of(context).size.width / 50),
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
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
              value: dropDownValue,
              elevation: 0,
              isExpanded: true,
              iconSize: portrait
                  ? MediaQuery.of(context).size.height / 35
                  : MediaQuery.of(context).size.width / 35,
              onChanged: (Trip newValue) {
                setState(() {
                  dropDownValue = newValue;
                });
              },
              items: sortedTripList.map<DropdownMenuItem<Trip>>((Trip value) {
                return DropdownMenuItem<Trip>(
                  value: value,
                  child: Container(
                    width: portrait
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.height / 2,
                    child: Text(
                      value.detailDestination == "General"
                          ? value.detailDestination
                          : value.detailDestination +
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
                          fontSize: portrait
                              ? MediaQuery.of(context).size.height / 40 - 4
                              : MediaQuery.of(context).size.width / 40 - 4),
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

  Widget getFileInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: Text(
              "Select File:",
              style: TextStyle(
                  fontSize: portrait
                      ? MediaQuery.of(context).size.height / 45
                      : MediaQuery.of(context).size.width / 45),
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            child: GestureDetector(
              onTap: pickFile,
              child: Container(
                  height: portrait
                      ? MediaQuery.of(context).size.height / 35
                      : MediaQuery.of(context).size.width / 35,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: Text(
                    fileName,
                    style: TextStyle(
                        fontSize: portrait
                            ? MediaQuery.of(context).size.height / 40 - 4
                            : MediaQuery.of(context).size.width / 40 - 4),
                    textAlign: TextAlign.center,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFileName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: portrait
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.width / 6,
            child: Text(
              "File Name:",
              style: TextStyle(
                  fontSize: portrait
                      ? MediaQuery.of(context).size.height / 45
                      : MediaQuery.of(context).size.width / 45),
            ),
          ),
          Container(
            width: portrait
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            child: Container(
                height: portrait
                    ? MediaQuery.of(context).size.height / 35
                    : MediaQuery.of(context).size.width / 35,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    controller: fileNameController,
                    decoration: InputDecoration(
                      hintText: "File Name",
                      contentPadding: EdgeInsets.all(7.5),
                    ),
                    style: TextStyle(
                        fontSize: portrait
                            ? MediaQuery.of(context).size.height / 40 - 4
                            : MediaQuery.of(context).size.width / 40 - 4),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget getUploadFileButton() {
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
                ? MediaQuery.of(context).size.height / 4
                : MediaQuery.of(context).size.width / 2.5,
            child: TextButton(
              onPressed: uploading || !photosLoaded ? () {} : uploadFile,
              child: Text(
                uploading ? "Uploading, please wait..." : "Upload File",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: AggressorColors.secondaryColor),
            ),
          ),
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

  Widget getPageTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Files",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 25
                  : MediaQuery.of(context).size.width / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getFilePrompt() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Files must be uploaded as: PDF, TXT, DOC, JPG, PNG",
          style: TextStyle(
              color: Colors.grey[400],
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 55
                  : MediaQuery.of(context).size.width / 55,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getFilesSection() {
    double textBoxSize = portrait
        ? MediaQuery.of(context).size.width / 4
        : MediaQuery.of(context).size.height / 4;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
          color: Colors.white,
          child: fileDataList.length == 0
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
                          Expanded(
                            child: SizedBox(
                              width: textBoxSize,
                              child: Text("File Name",
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
                      child: Text("You do not have any files to view yet."),
                    ),
                  ],
                )
              : getFilesView()),
    );
  }

  Widget getFilesView() {
    //returns the list item containing fileData objects

    double textBoxSize = portrait
        ? MediaQuery.of(context).size.width / 4
        : MediaQuery.of(context).size.height / 4;
    filesList.clear();
    filesList.add(
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
                    child: Text("File Name", textAlign: TextAlign.left),
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

    fileDataList.forEach((value) {
        filesList.add(value.getFileRow(context, index));
        index++;
    });

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: filesList.length,
        itemBuilder: (context, position) {
          return filesList[position];
        });
  }

  Future<dynamic> getFiles() async {
    //downloads file from aws. If the file is not already in storage, it will be stored on the device.

    if (!filesLoaded && online) {
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
      FileDatabaseHelper fileHelper = FileDatabaseHelper.instance;
      List<FileData> tempFiles = [];

      var mapsList = await s3client.listObjects(
          prefix: widget.user.userId + "/config/files/nameMaps/",
          delimiter: "/");

      fileNameList.clear();
      for (var value in mapsList.contents) {
        try {
          if (double.parse(value.size) > 0) {
            fileNameList.add(await jsonDecode(value.toJson()));
          }
        } catch (e) {
          print("no map found or map error ");
        }
      }

      if (fileNameList.length > 0) {
        fileNameList.sort((a, b) => DateTime.parse(b["LastModified"])
            .compareTo((DateTime.parse(a["LastModified"]))));

        var mapResult =
            await AggressorApi().downloadAwsFile(fileNameList[0]["Key"]);
        var bytes = await readByteStream(mapResult.stream);
        var dirData = await getApplicationDocumentsDirectory();
        String path = dirData.toString();
        if (path.contains("'")) {
          path = path.replaceAll("'", "");
        }
        if (path.contains("Directory: ")) {
          path = path.replaceAll("Directory: ", "");
        }
        path += "/FileDisplayNames.txt";

        File mapsFile = File(path);
        await mapsFile.writeAsBytes(bytes);
        var mapRaw = mapsFile
            .readAsStringSync()
            .replaceAll("{", "")
            .replaceAll("}", "")
            .split(",");
        mapRaw.forEach((element) {
          if (element.split(':')[0].toString().replaceAll("\"", "").trim() !=
                  "status" &&
              element.split(':')[0].toString().replaceAll("\"", "").trim() !=
                  "message") {
            fileDisplayNames[element.split(':')[0].toString().trim()] =
                element.split(':')[1].toString().trim();
          }
        });
      }

      try {
        for (var element in tripList) {
          var response;
          try {
            response = await s3client.listObjects(
                prefix: widget.user.userId +
                    "/files/" +
                    element.charterId +
                    "/" +
                    formatDate(DateTime.parse(element.charter.startDate),
                        [yyyy, '-', mm, '-', dd]).toString() +
                    "/",
                delimiter: "/");
            if (response.contents != null) {
              response.contents.forEach((content) async {
                var elementJson = await jsonDecode(content.toJson());
                if (elementJson["Size"] != "0") {
                  if (!await FileDatabaseHelper.instance.fileExists(
                      elementJson["Key"].toString().substring(
                          elementJson["Key"].toString().lastIndexOf("/") +
                              1))) {
                    StreamedResponse downloadResponse = await AggressorApi()
                        .downloadAwsFile(elementJson["Key"].toString());

                    Uint8List bytes =
                        await readByteStream(downloadResponse.stream);

                    String fileName = elementJson["Key"];
                    int whereIndex = fileName.lastIndexOf("/");
                    fileName = fileName.substring(whereIndex + 1);

                    Directory appDocumentsDirectory =
                        await getApplicationDocumentsDirectory(); // 1
                    String appDocumentsPath = appDocumentsDirectory.path; // 2
                    String filePath = '$appDocumentsPath/$fileName';
                    File tempFile = File(filePath);
                    tempFile.writeAsBytes(bytes);

                    String date = elementJson["Key"].toString().substring(
                        elementJson["Key"].toString().lastIndexOf('/') - 10,
                        elementJson["Key"].toString().lastIndexOf('/'));

                    FileData fileData = FileData(
                        tempFile.path,
                        date,
                        fileName,
                        "",
                        element.charter == null
                            ? "general"
                            : element.charter.charterId);
                    fileHelper.insertFile(fileData);
                  }
                }
              });
            }
          } catch (e) {}
        }

        var response = await s3client.listObjects(
            prefix: widget.user.userId + "/files/general/general/",
            delimiter: "/");

        if (response.contents != null) {
          for (var content in response.contents) {
            var elementJson = await jsonDecode(content.toJson());
            if (elementJson["Size"] != "0") {
              if (!await FileDatabaseHelper.instance.fileExists(
                  elementJson["Key"].toString().substring(
                      elementJson["Key"].toString().lastIndexOf("/") + 1))) {
                StreamedResponse downloadResponse = await AggressorApi()
                    .downloadAwsFile(elementJson["Key"].toString());

                Uint8List bytes = await readByteStream(downloadResponse.stream);

                String fileName = elementJson["Key"];
                int whereIndex = fileName.lastIndexOf("/");
                fileName = fileName.substring(whereIndex + 1);

                Directory appDocumentsDirectory =
                    await getApplicationDocumentsDirectory(); // 1
                String appDocumentsPath = appDocumentsDirectory.path; // 2
                String filePath = '$appDocumentsPath/$fileName';
                File tempFile = File(filePath);
                tempFile.writeAsBytes(bytes);

                fileDataList.forEach((element) {});
                if (!await fileHelper.fileExists(
                  fileName,
                )) {
                  FileData fileData = FileData(
                      tempFile.path, "general", fileName, "", "general");

                  fileHelper.insertFile(fileData);
                }
              }
            }
          }
        }
      } catch (e) {}

      tempFiles = await fileHelper.queryFile();

      for (var element in tempFiles) {
        if ((element.displayName == "" || element.displayName == null) &&
            fileDisplayNames.containsKey(element.fileName)) {
          element.setDisplayName(fileDisplayNames[element.fileName]);
          await FileDatabaseHelper.instance.deleteFile(element.fileName);
          await FileDatabaseHelper.instance.insertFile(element);
        }
        element.setUser(widget.user);
        element.setCallback(() {
          setState(() {
            filesLoaded = false;
          });
        });
      }

      setState(() {
        loading = false;
        fileDataList = tempFiles;
        filesLoaded = true;
      });
    } else {
      //TODO test offline mode names
      if (!filesLoaded) {
        setState(() {
          loading = true;
        });
        var tempList = await FileDatabaseHelper.instance.queryFile();
        setState(() {
          fileDataList = tempList;
          filesLoaded = true;
          loading = false;
        });

        for (var element in fileDataList) {
          if (element.displayName == "" &&
              fileDisplayNames.containsKey(element.fileName)) {
            element.setDisplayName(fileDisplayNames[element.fileName]);
            await FileDatabaseHelper.instance.deleteFile(element.fileName);
            await FileDatabaseHelper.instance.insertFile(element);
          }
          element.setUser(widget.user);
          element.setCallback(() {
            setState(() {
              filesLoaded = false;
            });
          });
        }
      }
    }
    return "finished";
  }

  void pickFile() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'doc', 'jpg', 'png'],
    );

    setState(() {
      fileName = result.names[0];
    });
  }

  void clearFiles() async {
    //TODO remove this after files uploads are fixed
    String region = "us-east-1";
    String bucketId = "aggressor.app.user.images";
    final AwsS3Client s3client = AwsS3Client(
        region: region,
        host: "s3.$region.amazonaws.com",
        bucketId: bucketId,
        accessKey: "AKIA43MMI6CI2KP4CUUY",
        secretKey: "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");

    var path = widget.user.userId + "/files/general/general/";
    var resList = await s3client.listObjects(prefix: path, delimiter: "/");
    for (var value in resList.contents) {
      if (double.parse(value.size) > 0) {
        var res = await AggressorApi().deleteAwsFile(
            widget.user.userId,
            "files",
            "general",
            "general",
            value.key.substring(value.key.lastIndexOf("/") + 1));
      }
    }
  }

  void uploadFile() async {
    //uploads a file to the aws bucket
    setState(() {
      loading = true;
      uploading = true;
    });
    try {
      if (online) {
        if (result != null) {
          String uploadDate = dropDownValue.charter == null
              ? "general"
              : formatDate(DateTime.parse(dropDownValue.charter.startDate),
                  [yyyy, '-', mm, '-', dd]);

          var uploadResult = await AggressorApi().uploadAwsFile(
              widget.user.userId,
              "files",
              dropDownValue.charterId,
              result.files.single.path,
              uploadDate);

          if (uploadResult["status"] == "success") {
            Uint8List bytes = File(result.files.single.path).readAsBytesSync();
            Directory appDocumentsDirectory =
                await getApplicationDocumentsDirectory(); // 1
            String appDocumentsPath = appDocumentsDirectory.path; // 2
            String filePath = '$appDocumentsPath/' + uploadResult["filename"];
            File tempFile = File(filePath);
            tempFile.writeAsBytes(bytes);

            print(uploadResult["filename"]);
            FileDatabaseHelper.instance.insertFile(FileData(
                tempFile.path,
                uploadDate,
                uploadResult["filename"],
                fileNameController.text,
                dropDownValue.charterId));

            setState(() {
              fileDisplayNames[uploadResult["filename"].toString()] =
                  fileNameController.text.toString();
              filesLoaded = false;
              fileName = "";
              result = null;
            });
          } else {
            setState(() {
              errorMessage = "File failed to upload, please try again.";
            });
          }
        }
      } else {
        setState(() {
          errorMessage = "Must be online to upload a file";
          loading = false;
          uploading = false;
        });
      }
    } catch (e) {
      print("error uploading file");
    }

    bool namesUpdated = false;
    while (!namesUpdated) {
      namesUpdated = await updateDisplayNameStorage();
    }
    setState(() {
      fileNameController.clear();
      loading = false;
      uploading = false;
    });
  }

  Future<bool> updateDisplayNameStorage() async {
    String region = "us-east-1";
    String bucketId = "aggressor.app.user.images";

    fileDataList.forEach((element) {
      //ensures all values are in the new map even if they are loaded from offline
      if (!fileDisplayNames.containsKey(element.fileName)) {
        fileDisplayNames[element.fileName] = element.displayName;
      }
    });

    String dataDir = (await getApplicationDocumentsDirectory()).path;
    File displayNameFile = File(dataDir + "/FileDisplayNames.txt");
    displayNameFile =
        await displayNameFile.writeAsString(fileDisplayNames.toString());

    int count = 0;
    for (var element in fileNameList) {
      if (count > 3) {
        count++;
      } else {
        try {
          await AggressorApi().deleteAwsFile(
              widget.user.userId,
              "config",
              "files",
              "nameMaps",
              element["Key"]
                  .toString()
                  .substring(element["Key"].toString().lastIndexOf("/") + 1));
        } catch (e) {
          print("delete failed, continuing");
        }
      }
    }

    try {
      var uploading = await AggressorApi().uploadAwsFile(widget.user.userId,
          "config", "files", displayNameFile.path, "nameMaps");
      return true;
    } catch (e) {
      print("error");
      return false;
    }
  }

  Widget showErrorMessage() {
    //displays an error message if there is an error to be shown
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
    //displays a loading bar if data is being downloaded
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
    //displays offline when the application does not have internet connection
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

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */

}
