/*
creates a user class to hold the contens of a user class
 */
import 'dart:convert';

class User {
  String? userId;
  String? nameF;
  String? nameL;
  String? email;
  String? contactId;
  String? OFYContactId;
  String? userType;
  String? contactType;

  User(
    String userId,
    String nameF,
    String nameL,
    String email,
    String contactId,
    String OFYContactId,
    String userType,
    String? contactType,
  ) {
    //default constructor
    this.userId = userId;
    this.nameF = nameF;
    this.nameL = nameL;
    this.email = email;
    this.contactId = contactId;
    this.OFYContactId = OFYContactId;
    this.userType = userType;
    this.contactType = contactType;
  }

  static Map<String, dynamic> toMap({required User userData}) {
    //create a map object from user object
    return {
      'userId': userData.userId,
      'nameF': userData.nameF,
      'nameL': userData.nameL,
      'email': userData.email,
      'contactId': userData.contactId,
      'OFYContactId': userData.OFYContactId,
      'userType': userData.userType,
      'contactType': userData.contactType,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userID'].toString();
    nameF = json['first'];
    nameL = json['last'];
    email = json['email'];
    contactId = json['contactID'];
    OFYContactId = json['OFYcontactID'];
    userType = json['user_type'];
    contactType = json['contact_type'];
  }

  User.fromDesJson(Map<String, dynamic> json) {
    userId = json['userId'].toString();
    nameF = json['nameF'];
    nameL = json['nameL'];
    email = json['email'];
    contactId = json['contactId'];
    OFYContactId = json['OFYContactId'];
    userType = json['userType'];
    contactType = json['contactType'];
  }

  static String serialize(User model) =>
      json.encode(User.toMap(userData: model));

  static User deserialize(String json) => User.fromDesJson(jsonDecode(json));
}
