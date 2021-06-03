/*
creates a contact class to hold the contents of a contact class
 */
class Contact {
  String contactId;
  String nameF;
  String nameM;
  String nameL;
  String email;
  String vipCount;
  String vipPlusCount;
  String sevenSeasCount;
  String aaCount;
  String boutiquePoints;

  Contact(
    String contactId,
    String nameF,
    String nameM,
    String nameL,
    String email,
    String vipCount,
    String vipPlusCount,
    String sevenSeasCount,
    String aaCount,
    String boutiquePoints,
  ) {
    //default constructor

    this.contactId = contactId;
    this.nameF = nameF;
    this.nameM = nameM;
    this.nameL = nameL;
    this.email = email;
    this.vipCount = vipCount;
    this.vipPlusCount = vipPlusCount;
    this.sevenSeasCount = sevenSeasCount;
    this.aaCount = aaCount;
    this.boutiquePoints = boutiquePoints;
  }

  Map<String, dynamic> toMap() {
    //create a map object from user object
    return {
      'contactId': contactId,
      'nameF': nameF,
      'nameM': nameM,
      'nameL': nameL,
      'email': email,
      'vipCount': vipCount,
      'vipPlusCount': vipPlusCount,
      'sevenSeasCount': sevenSeasCount,
      'aaCount': aaCount,
      'boutiquePoints': boutiquePoints,
    };
  }
}
