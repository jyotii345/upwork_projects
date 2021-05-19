import 'dart:ui';

class Photo {
  String imageName;
  String userId;
  String byteString;
  String date;
  String charterId;

  Photo(
      String imageName,
      String userId,
      String byteString, String date,String charterId
      ) {
    this.imageName = imageName;
    this.userId = userId;
    this.byteString = byteString;
    this.date = date;
    this.charterId = charterId;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'imageName': imageName,
      'userId': userId,
      'byteString': byteString,
      'date' : date,
      'charterId' : charterId,
    };
  }
}
