/*
creates a contact class to hold the contents of a contact class
 */
class Contact {
  String? contactId;
  String? nameF;
  String? nameM;
  String? nameL;
  String? email;
  String? vipCount;
  String? vipPlusCount;
  String? sevenSeasCount;
  String? aaCount;
  String? boutiquePoints;
  String? vip;
  String? vipPlus;
  String? sevenSeas;
  String? adventuresClub;
  String? memberSince;

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
    String vip,
    String vipPlus,
    String sevenSeas,
    String adventuresClub,
    String memberSince,
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
    this.vip = vip;
    this.vipPlus = vipPlus;
    this.sevenSeas = sevenSeas;
    this.adventuresClub = adventuresClub;
    this.memberSince = memberSince;
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
      'vip': vip,
      'vipPlus': vipPlus,
      'sevenSeas': sevenSeas,
      'adventuresClub': adventuresClub,
      'memberSince': memberSince,
    };
  }
}
