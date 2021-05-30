/*
creates a user class to hold the contens of a user class
 */
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

  Map<String, dynamic> toMap() {
    //create a map object from user object
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
