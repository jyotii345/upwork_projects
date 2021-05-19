import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/file_data.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/files_database.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class MyFiles extends StatefulWidget {
  MyFiles(this.user);

  User user;

  @override
  State<StatefulWidget> createState() => new MyFilesState();
}

class MyFilesState extends State<MyFiles> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  String fileName = "";

  bool filesLoaded = false;

  List<dynamic> filesList = [];
  List<FileData> fileDataList = <FileData>[];

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
          ],
        ),
      ),
    );
  }

  Widget getUploadFile() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            "UPLOAD FILE",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: MediaQuery.of(context).size.height / 35,
                fontWeight: FontWeight.bold),
          ),
          getFilePrompt(),
          getFileInformation(),
          getUploadFileButton(),
        ],
      ),
    );
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
          onPressed: () {},
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

  Widget getFilePrompt()
  {
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
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child:
      Container(
        color: Colors.white,
        child: FutureBuilder(
          future: getFiles(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return filesList.length == 0
                  ? Column(
                mainAxisSize : MainAxisSize.min,
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
                            child: Text("Destination", textAlign: TextAlign.center),
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
                  Expanded(
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
      final AwsS3Client s3client =
      AwsS3Client(region: region, host: "s3.$region.amazonaws.com", bucketId: bucketId, accessKey: "AKIA43MMI6CI2KP4CUUY", secretKey: "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");
      ListBucketResult listBucketResult;
      FileDatabaseHelper fileHelper = FileDatabaseHelper.instance;
      List<FileData> tempFiles = [];

      try {
          var response = await s3client.listObjects(prefix: widget.user.userId + "/files/", delimiter: "/");

          if (response.contents != null) {
            response.contents.forEach((content) async {
              var elementJson = await jsonDecode(content.toJson());
              if (elementJson["Size"] != "0") {

                StreamedResponse downloadResponse = await AggressorApi().downloadAwsFile(elementJson["Key"].toString());

                Uint8List bytes = await readByteStream(downloadResponse.stream);

                String fileName = downloadResponse.headers["content-disposition"];
                int whereIndex = fileName.indexOf("=");
                fileName = fileName.substring(whereIndex + 1);
                fileName.replaceAll("\"", "");

                Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
                String appDocumentsPath = appDocumentsDirectory.path; // 2
                String filePath = '$appDocumentsPath/$fileName';
                File imageFile = File(filePath);
                imageFile.writeAsBytes(bytes);

                String date = downloadResponse.headers["date"];

                if (!await fileHelper.fileExists(fileName,)) {
                  FileData fileData = FileData( imageFile.path, date, fileName,);

                  fileHelper.insertFile(fileData);
                }
              }
            });
          }
      } catch (e) {
        print(e.toString());
      }

      print("query started");
      tempFiles = await fileHelper.queryFile();
      print("query finished");

      setState(() {
        fileDataList = tempFiles;
        filesLoaded = true;
      });
    }
    return "finished";
  }





  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */

}
