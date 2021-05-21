import 'dart:ui';

class Photo {
  String imageName;
  String userId;
  String imagePath;
  String date;
  String charterId;
  String key;

  Photo(
      String imageName,
      String userId,
      String imagePath, String date,String charterId, String key
      ) {
    this.imageName = imageName;
    this.userId = userId;
    this.imagePath = imagePath;
    this.date = date;
    this.charterId = charterId;
    this.key = key;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'imageName': imageName,
      'userId': userId,
      'imagePath': imagePath,
      'date' : date,
      'charterId' : charterId,
      'key' : key,
    };
  }
}
