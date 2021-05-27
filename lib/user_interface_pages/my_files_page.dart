import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/file_data.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/files_database.dart';
import 'package:chunked_stream/chunked_stream.dart';
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

  bool filesLoaded = false;

  List<dynamic> filesList = [];
  List<FileData> fileDataList = <FileData>[];

  List<Trip> sortedTripList;

  String errorMessage = "";

  FilePickerResult result;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    selectionTrip =
        Trip(DateTime.now().toString(), "", "", "", "General", "", "");
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "UPLOAD FILE",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: MediaQuery.of(context).size.height / 35,
                fontWeight: FontWeight.bold),
          ),
          getFilePrompt(),
          getDestinationDropdown(tripList),
          getFileInformation(),
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
                  });
                },
                items: sortedTripList.map<DropdownMenuItem<Trip>>((Trip value) {
                  return DropdownMenuItem<Trip>(
                    value: value,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
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

  Widget getFileInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "File Name:",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 45),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: pickFile,
              child: Container(
                  height: MediaQuery.of(context).size.height / 35,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: Text(
                    fileName,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 40 - 4),
                    textAlign: TextAlign.center,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget getUploadFileButton() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height / 4,
        ),
        TextButton(
          onPressed: uploadFile,
          child: Text(
            "Upload File",
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
              backgroundColor: AggressorColors.secondaryColor),
        ),
      ],
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

  Widget getPageTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Files",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 25,
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
              fontSize: MediaQuery.of(context).size.height / 55,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getFilesSection() {
    double textBoxSize = MediaQuery.of(context).size.width / 4;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: getFiles(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return fileDataList.length == 0
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
                              Expanded(
                                child: SizedBox(
                                  width: textBoxSize,
                                  child: Text("Destination",
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              SizedBox(
                                width: textBoxSize,
                                child:
                                    Text("Date", textAlign: TextAlign.center),
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
                  : getFilesView();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget getFilesView() {
    //returns the list item containing fileData objects

    double textBoxSize = MediaQuery.of(context).size.width / 4;
    filesList.clear();
    filesList.add(
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
    if (!filesLoaded) {
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

      try {
        for (var element in tripList) {
          var response;
          try {
            response = await s3client.listObjects(
                prefix:
                    widget.user.userId + "/files/" + element.charterId + "/",
                delimiter: "/");

            if (response.contents != null) {
              response.contents.forEach((content) async {
                var elementJson = await jsonDecode(content.toJson());
                if (elementJson["Size"] != "0") {
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

                  String date = downloadResponse.headers["date"].substring(4);

                  if (!await fileHelper.fileExists(
                    fileName,
                  )) {
                    FileData fileData = FileData(
                      tempFile.path,
                      date, //TODO potentially replace with embarkment date
                      fileName,
                    );

                    fileHelper.insertFile(fileData);
                  }
                }
              });
            }
          } catch (e) {}
        }

        var response = await s3client.listObjects(
            prefix: widget.user.userId + "/files/general/", delimiter: "/");

        if (response.contents != null) {
          for (var content in response.contents) {
            var elementJson = await jsonDecode(content.toJson());
            if (elementJson["Size"] != "0") {
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

              String date = downloadResponse.headers["date"]
                  .substring(5, downloadResponse.headers["date"].length - 13);

              if (!await fileHelper.fileExists(
                fileName,
              )) {
                FileData fileData = FileData(
                  tempFile.path,
                  date,
                  fileName,
                );

                fileHelper.insertFile(fileData);
              }
            }
          }
        }
      } catch (e) {
        print(e.toString());
      }

      tempFiles = await fileHelper.queryFile();

      setState(() {
        fileDataList = tempFiles;
        filesLoaded = true;
      });
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

  void uploadFile() async{
    if (result != null) {
      var uploadResult = await AggressorApi().uploadAwsFile(widget.user.userId,
          "files", dropDownValue.charterId, result.files.single.path);
      if (uploadResult["status"] == "success") {
        setState(() {
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

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */

}
