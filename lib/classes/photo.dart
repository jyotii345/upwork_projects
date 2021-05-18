import 'dart:ui';

class Photo {
  String imageName;
  String userId;
  String gallery;
  String charterId;

  Photo(
      String imageName,
      String userId,
      String gallery,String charterId
      ) {
    this.imageName = imageName;
    this.userId = userId;
    this.gallery = gallery;
    this.charterId = charterId;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'imageName': imageName,
      'userId': userId,
      'gallery': gallery,
      'charterId' : charterId,
    };
  }
}
