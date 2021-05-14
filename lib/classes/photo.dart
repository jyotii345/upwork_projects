import 'dart:ui';

class Photo {
  String imagePath;
  String galleryName;
  String imageBytes;

  Photo(
      String userId,
      String nameF,
      String nameL,
      ) {
    this.imagePath = imagePath;
    this.galleryName = galleryName;
    this.imageBytes = imageBytes;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'imagePath': imagePath,
      'nameF': imageBytes,
      'nameL': imageBytes,
    };
  }
}
