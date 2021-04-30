import 'dart:ui';

class User {
  String userId;
  String nameF;
  String nameL;
  String email;
  String contactId;
  String OFYContactId;
  String userType;
  String contactType;

  User(
    String userId,
    String nameF,
    String nameL,
    String email,
    String contactId,
    String OFYContactId,
    String userType,
    String contactType,
  ) {
    this.userId = userId;
    this.nameF = nameF;
    this.nameL = nameL;
    this.email = email;
    this.contactId = contactId;
    this.OFYContactId = OFYContactId;
    this.userType = userType;
    this.contactType = contactType;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nameF': nameF,
      'nameL': nameL,
      'email': email,
      'contactId': contactId,
      'OFYContactId': OFYContactId,
      'userType': userType,
      'contactType': contactType,
    };
  }
}
