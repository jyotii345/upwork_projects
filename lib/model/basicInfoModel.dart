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
    if (this.title != null) {
      data['title'] = this.title;
    }

    if (this.contactID != null) {
      data['contactID'] = this.contactID;
    }

    if (this.firstName != null) {
      data['first_name'] = this.firstName;
    }

    if (this.middleName != null) {
      data['middle_name'] = this.middleName;
    }

    if (this.lastName != null) {
      data['last_name'] = this.lastName;
    }

    if (this.preferredName != null) {
      data['preferred_name'] = this.preferredName;
    }

    if (this.gender != null) {
      data['gender'] = this.gender;
    }

    if (this.dob != null) {
      data['dob'] = this.dob;
    }

    if (this.occupation != null) {
      data['occupation'] = this.occupation;
    }

    if (this.phone1 != null) {
      data['phone1'] = this.phone1;
    }

    if (this.phone1Type != null) {
      data['phone1_type'] = this.phone1Type;
    }

    if (this.phone2 != null) {
      data['phone2'] = this.phone2;
    }

    if (this.phone2Type != null) {
      data['phone2_type'] = this.phone2Type;
    }

    if (this.phone3 != null) {
      data['phone3'] = this.phone3;
    }

    if (this.phone3Type != null) {
      data['phone3_type'] = this.phone3Type;
    }

    if (this.phone4 != null) {
      data['phone4'] = this.phone4;
    }

    if (this.phone4Type != null) {
      data['phone4_type'] = this.phone4Type;
    }

    if (this.email != null) {
      data['email'] = this.email;
    }

    if (this.travelPackage != null) {
      data['travel_package'] = this.travelPackage.toString();
    }

    if (this.address1 != null) {
      data['address1'] = this.address1;
    }

    if (this.address2 != null) {
      data['address2'] = this.address2;
    }

    if (this.city != null) {
      data['city'] = this.city;
    }

    if (this.state != null) {
      data['state'] = this.state;
    }

    if (this.province != null) {
      data['province'] = this.province;
    }

    if (this.zip != null) {
      data['zip'] = this.zip;
    }

    if (this.country != null) {
      data['country'] = this.country.toString();
    }

    if (this.nationalityCountryID != null) {
      data['nationality_countryID'] = this.nationalityCountryID.toString();
    }

    if (this.passportExpiration != null) {
      data['passport_expiration'] = this.passportExpiration;
    }

    if (this.passportNumber != null) {
      data['passport_number'] = this.passportNumber.toString();
    }

    if (this.emergencyFirst != null) {
      data['emergency_first'] = this.emergencyFirst;
    }

    if (this.emergencyLast != null) {
      data['emergency_last'] = this.emergencyLast;
    }

    if (this.emergencyRelationship != null) {
      data['emergency_relationship'] = this.emergencyRelationship;
    }

    if (this.emergencyPhHome != null) {
      data['emergency_ph_home'] = this.emergencyPhHome;
    }

    if (this.emergencyPhWork != null) {
      data['emergency_ph_work'] = this.emergencyPhWork;
    }

    if (this.emergencyPhMobile != null) {
      data['emergency_ph_mobile'] = this.emergencyPhMobile;
    }

    if (this.emergencyEmail != null) {
      data['emergency_email'] = this.emergencyEmail;
    }

    if (this.emergencyAddress1 != null) {
      data['emergency_address1'] = this.emergencyAddress1;
    }

    if (this.emergencyAddress2 != null) {
      data['emergency_address2'] = this.emergencyAddress2;
    }

    if (this.emergencyCity != null) {
      data['emergency_city'] = this.emergencyCity;
    }

    if (this.emergencyState != null) {
      data['emergency_state'] = this.emergencyState;
    }

    if (this.emergencyZip != null) {
      data['emergency_zip'] = this.emergencyZip;
    }

    if (this.emergencyCountryID != null) {
      data['emergency_countryID'] = this.emergencyCountryID.toString();
    }

    if (this.emergency2First != null) {
      data['emergency2_first'] = this.emergency2First;
    }

    if (this.emergency2Last != null) {
      data['emergency2_last'] = this.emergency2Last;
    }

    if (this.emergency2Relationship != null) {
      data['emergency2_relationship'] = this.emergency2Relationship;
    }

    if (this.emergency2PhHome != null) {
      data['emergency2_ph_home'] = this.emergency2PhHome;
    }

    if (this.emergency2PhWork != null) {
      data['emergency2_ph_work'] = this.emergency2PhWork;
    }

    if (this.emergency2PhMobile != null) {
      data['emergency2_ph_mobile'] = this.emergency2PhMobile;
    }

    if (this.emergency2Email != null) {
      data['emergency2_email'] = this.emergency2Email;
    }

    if (this.emergency2Address1 != null) {
      data['emergency2_address1'] = this.emergency2Address1;
    }

    if (this.emergency2Address2 != null) {
      data['emergency2_address2'] = this.emergency2Address2;
    }

    if (this.emergency2City != null) {
      data['emergency2_city'] = this.emergency2City;
    }

    if (this.emergency2State != null) {
      data['emergency2_state'] = this.emergency2State;
    }

    if (this.emergency2Zip != null) {
      data['emergency2_zip'] = this.emergency2Zip;
    }

    if (this.emergency2CountryID != null) {
      data['emergency2_countryID'] = this.emergency2CountryID.toString();
    }
    return data;
  }
}
