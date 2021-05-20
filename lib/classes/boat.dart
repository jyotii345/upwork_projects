import 'dart:ui';

class Boat {
  String boatId;
  String name;
  String abbreviation;
  String email;
  String active;
  String imageLink;

  Boat(String boatId, String name, String abbreviation, String email, String active, String imageLink) {
    this.boatId = boatId;
    this.name = name;
    this.abbreviation = abbreviation;
    this.email = email;
    this.active = active;
    this.imageLink = imageLink;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'boatId': boatId,
      'name': name,
      'abbreviation': abbreviation,
      'email': email,
      'active': active,
      'imageLink': imageLink,
    };
  }
}
