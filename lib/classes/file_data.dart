import 'dart:io';
import 'dart:ui';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class FileData {
  String filePath;
  String date;
  String fileName;

  FileData(String filePath, String date, String fileName) {
    this.filePath = filePath;
    this.date = date;
    this.fileName = fileName;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'filePath': filePath,
      'date': date,
      'fileName': fileName,
    };
  }

  Widget getFileRow(BuildContext context, int index) {
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
                      print("pressed");
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Future<void> openFile() async {
    final _result = await OpenFile.open(filePath);
    print(_result.message);
    print(_result.type);
  }
}
