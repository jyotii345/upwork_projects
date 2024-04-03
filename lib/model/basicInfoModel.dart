class BasicInfoModel {
  String? status;
  String? title;
  String? contactID;
  String? firstName;
  String? middleName;
  String? lastName;
  String? preferredName;
  String? gender;
  String? dob;
  String? occupation;
  String? phone1;
  String? phone1Type;
  String? phone2;
  String? phone2Type;
  String? phone3;
  String? phone3Type;
  String? phone4;
  String? phone4Type;
  String? email;
  int? travelPackage;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? province;
  String? zip;
  int? country;
  int? nationalityCountryID;
  String? passportExpiration;
  String? passportNumber;
  String? emergencyFirst;
  String? emergencyLast;
  String? emergencyRelationship;
  String? emergencyPhHome;
  String? emergencyPhWork;
  String? emergencyPhMobile;
  String? emergencyEmail;
  String? emergencyAddress1;
  String? emergencyAddress2;
  String? emergencyCity;
  String? emergencyState;
  String? emergencyZip;
  int? emergencyCountryID;
  String? emergency2First;
  String? emergency2Last;
  String? emergency2Relationship;
  String? emergency2PhHome;
  String? emergency2PhWork;
  String? emergency2PhMobile;
  String? emergency2Email;
  String? emergency2Address1;
  String? emergency2Address2;
  String? emergency2City;
  String? emergency2State;
  String? emergency2Zip;
  int? emergency2CountryID;

  BasicInfoModel(
      {this.status,
      this.title,
      this.contactID,
      this.firstName,
      this.middleName,
      this.lastName,
      this.preferredName,
      this.gender,
      this.dob,
      this.occupation,
      this.phone1,
      this.phone1Type,
      this.phone2,
      this.phone2Type,
      this.phone3,
      this.phone3Type,
      this.phone4,
      this.phone4Type,
      this.email,
      this.travelPackage,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.province,
      this.zip,
      this.country,
      this.nationalityCountryID,
      this.passportExpiration,
      this.passportNumber,
      this.emergencyFirst,
      this.emergencyLast,
      this.emergencyRelationship,
      this.emergencyPhHome,
      this.emergencyPhWork,
      this.emergencyPhMobile,
      this.emergencyEmail,
      this.emergencyAddress1,
      this.emergencyAddress2,
      this.emergencyCity,
      this.emergencyState,
      this.emergencyZip,
      this.emergencyCountryID,
      this.emergency2First,
      this.emergency2Last,
      this.emergency2Relationship,
      this.emergency2PhHome,
      this.emergency2PhWork,
      this.emergency2PhMobile,
      this.emergency2Email,
      this.emergency2Address1,
      this.emergency2Address2,
      this.emergency2City,
      this.emergency2State,
      this.emergency2Zip,
      this.emergency2CountryID});

  BasicInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    title = json['title'];
    contactID = json['contactID'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    preferredName = json['preferred_name'];
    gender = json['gender'];
    dob = json['dob'];
    occupation = json['occupation'];
    phone1 = json['phone1'];
    phone1Type = json['phone1_type'];
    phone2 = json['phone2'];
    phone2Type = json['phone2_type'];
    phone3 = json['phone3'];
    phone3Type = json['phone3_type'];
    phone4 = json['phone4'];
    phone4Type = json['phone4_type'];
    email = json['email'];
    travelPackage = json['travel_package'] ?? false;
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    province = json['province'];
    zip = json['zip'];
    country = json['country'];
    nationalityCountryID = json['nationality_countryID'];
    passportExpiration = json['passport_expiration'];
    passportNumber = json['passport_number'];
    emergencyFirst = json['emergency_first'];
    emergencyLast = json['emergency_last'];
    emergencyRelationship = json['emergency_relationship'];
    emergencyPhHome = json['emergency_ph_home'];
    emergencyPhWork = json['emergency_ph_work'];
    emergencyPhMobile = json['emergency_ph_mobile'];
    emergencyEmail = json['emergency_email'];
    emergencyAddress1 = json['emergency_address1'];
    emergencyAddress2 = json['emergency_address2'];
    emergencyCity = json['emergency_city'];
    emergencyState = json['emergency_state'];
    emergencyZip = json['emergency_zip'];
    emergencyCountryID = json['emergency_countryID'];
    emergency2First = json['emergency2_first'];
    emergency2Last = json['emergency2_last'];
    emergency2Relationship = json['emergency2_relationship'];
    emergency2PhHome = json['emergency2_ph_home'];
    emergency2PhWork = json['emergency2_ph_work'];
    emergency2PhMobile = json['emergency2_ph_mobile'];
    emergency2Email = json['emergency2_email'];
    emergency2Address1 = json['emergency2_address1'];
    emergency2Address2 = json['emergency2_address2'];
    emergency2City = json['emergency2_city'];
    emergency2State = json['emergency2_state'];
    emergency2Zip = json['emergency2_zip'];
    emergency2CountryID = json['emergency2_countryID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['title'] = this.title;
    data['contactID'] = this.contactID;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    if (this.preferredName != null) {
      data['preferred_name'] = this.preferredName;
    }
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['occupation'] = this.occupation;
    data['phone1'] = this.phone1;
    data['phone1_type'] = this.phone1Type;
    data['phone2'] = this.phone2;
    data['phone2_type'] = this.phone2Type;
    data['phone3'] = this.phone3;
    data['phone3_type'] = this.phone3Type;
    data['phone4'] = this.phone4;
    data['phone4_type'] = this.phone4Type;
    data['email'] = this.email;
    data['travel_package'] = this.travelPackage;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['province'] = this.province;
    data['zip'] = this.zip;
    data['country'] = this.country;
    data['nationality_countryID'] = this.nationalityCountryID;
    data['passport_expiration'] = this.passportExpiration;
    data['passport_number'] = this.passportNumber;
    data['emergency_first'] = this.emergencyFirst;
    data['emergency_last'] = this.emergencyLast;
    data['emergency_relationship'] = this.emergencyRelationship;
    data['emergency_ph_home'] = this.emergencyPhHome;
    data['emergency_ph_work'] = this.emergencyPhWork;
    data['emergency_ph_mobile'] = this.emergencyPhMobile;
    data['emergency_email'] = this.emergencyEmail;
    data['emergency_address1'] = this.emergencyAddress1;
    data['emergency_address2'] = this.emergencyAddress2;
    data['emergency_city'] = this.emergencyCity;
    data['emergency_state'] = this.emergencyState;
    data['emergency_zip'] = this.emergencyZip;
    data['emergency_countryID'] = this.emergencyCountryID;
    data['emergency2_first'] = this.emergency2First;
    data['emergency2_last'] = this.emergency2Last;
    data['emergency2_relationship'] = this.emergency2Relationship;
    data['emergency2_ph_home'] = this.emergency2PhHome;
    data['emergency2_ph_work'] = this.emergency2PhWork;
    data['emergency2_ph_mobile'] = this.emergency2PhMobile;
    data['emergency2_email'] = this.emergency2Email;
    data['emergency2_address1'] = this.emergency2Address1;
    data['emergency2_address2'] = this.emergency2Address2;
    data['emergency2_city'] = this.emergency2City;
    data['emergency2_state'] = this.emergency2State;
    data['emergency2_zip'] = this.emergency2Zip;
    data['emergency2_countryID'] = this.emergency2CountryID;
    return data;
  }
}
