import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      'date' : date,
      'fileName' : fileName,
    };
  }

  Widget getFileRow(BuildContext context, int index) {
    double textBoxSize = MediaQuery.of(context).size.width / 4;

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
              Expanded(
                child: SizedBox(
                  width: textBoxSize,
                  child: Text(fileName,
                      textAlign: TextAlign
                          .left), //TODO replace with actual destination
                ),
              ),
              SizedBox(
                width: textBoxSize,
                //TODO everything with this date should be replaced with embarkment date soon.
                child: Text(
                  date,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: textBoxSize / 2,
                child: IconButton(
                    icon: Image.asset("assets/trashcan.png"),
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
}
