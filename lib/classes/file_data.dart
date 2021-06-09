/*
file_data class to hold the contents of a file object generated from the aws s3 bucket
 */
import 'dart:convert';
import 'dart:ui';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/files_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class FileData {
  String filePath;
  String date;
  String fileName;
  String boatId;
  User user;

  FileData(String filePath, String date, String fileName, String boatId) {
    //default constructor
    this.filePath = filePath;
    this.date = date;
    this.fileName = fileName;
    this.boatId = boatId;
  }

  Map<String, dynamic> toMap() {
    //create a map object from file_data object
    return {
      'filePath': filePath,
      'date': date,
      'fileName': fileName,
    };
  }

  Widget getFileRow(BuildContext context, int index) {
    //create a file row widget to display on the files page
    double textBoxSize = MediaQuery.of(context).size.width / 4;
    double iconSize = MediaQuery.of(context).size.width / 15;

    return Column(
      children: [
        Container(
          height: .5,
          color: Colors.grey,
        ),
        Container(
          color: index % 2 == 0 ? Colors.white : Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "assets/filearrow.png",
                height: iconSize,
                width: iconSize,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: openFile,
                    child: SizedBox(
                      width: textBoxSize,
                      child: Text(
                        fileName,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: AggressorColors.secondaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: textBoxSize,
                child: Text(
                  date,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                child: IconButton(
                    icon: Image.asset(
                      "assets/trashcan.png",
                      height: iconSize,
                      width: iconSize,
                    ),
                    onPressed: () {
                      deleteFile();
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void deleteFile() async{
    var res = await AggressorApi().deleteAwsFile(user.userId.toString(), "files", boatId.toString(), date.toString(), filePath.toString());
    await FileDatabaseHelper.instance.deleteFile(filePath);
    print(json.decode(await res.stream.bytesToString()));
    filesLoaded = false;
  }

  Future<void> openFile() async {
    //opens the contents of a file on the defualt application for the native device
    final _result = await OpenFile.open(filePath);
  }

  void setUser(User user){
    this.user = user;
  }
}
