import 'dart:ui';

class Photo {
  String imageName;
  String userId;
  String imagePath;
  String date;
  String boatId;
  String key;

  Photo(
      String imageName,
      String userId,
      String imagePath, String date,String boatId, String key
      ) {
    this.imageName = imageName;
    this.userId = userId;
    this.imagePath = imagePath;
    this.date = date;
    this.boatId = boatId;
    this.key = key;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'imageName': imageName,
      'userId': userId,
      'imagePath': imagePath,
      'date' : date,
      'boatId' : boatId,
      'key' : key,
    };
  }
}
