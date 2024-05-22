import '../user_interface_pages/Guest information System/pages/emergency_contact.dart';

class EmergencyContactModel {
  String? emergency_first;
  String? emergency_last;
  String? emergency_relationship;
  String? emergency_ph_home;
  String? emergency_ph_work;
  String? emergency_ph_mobile;
  String? emergency_email;
  String? emergency_address1;
  String? emergency_address2;
  String? emergency_city;
  String? emergency_state;
  String? emergency_zip;
  int? emergency_countryID;
  String? emergency2_first;
  String? emergency2_last;
  String? emergency2_relationship;
  String? emergency2_ph_home;
  String? emergency2_ph_work;
  String? emergency2_ph_mobile;
  String? emergency2_email;
  String? emergency2_address1;
  String? emergency2_address2;
  String? emergency2_city;
  String? emergency2_state;
  String? emergency2_zip;
  int? emergency2_countryID;

  EmergencyContactModel({
    this.emergency2_address1,
    this.emergency2_address2,
    this.emergency2_city,
    this.emergency2_countryID,
    this.emergency2_email,
    this.emergency2_first,
    this.emergency2_last,
    this.emergency2_ph_home,
    this.emergency2_ph_mobile,
    this.emergency2_ph_work,
    this.emergency2_relationship,
    this.emergency2_state,
    this.emergency2_zip,
    this.emergency_address1,
    this.emergency_address2,
    this.emergency_city,
    this.emergency_countryID,
    this.emergency_email,
    this.emergency_first,
    this.emergency_last,
    this.emergency_ph_home,
    this.emergency_ph_mobile,
    this.emergency_ph_work,
    this.emergency_relationship,
    this.emergency_state,
    this.emergency_zip,
  });

  EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    emergency_first = json['emergency_first'];
    emergency_last = json['emergency_last'];
    emergency_address1 = json['emergency_address1'];
    emergency_address2 = json['emergency_address2'];
    emergency_city = json['emergency_city'];
    emergency_countryID = json['emergency_countryID'];
    emergency_email = json['emergency_email'];
    // emergency_first = json['emergency_first'];
    // emergency_last = json['emergency_last'];
    emergency_ph_home = json['emergency_ph_home'];
    emergency_ph_mobile = json['emergency_ph_mobile'];
    emergency_ph_work = json['emergency_ph_work'];
    emergency_relationship = json['emergency_relationship'];
    emergency_state = json['emergency_state'];
    emergency_zip = json['emergency_zip'];
    emergency2_first = json['emergency2_first'];
    emergency2_last = json['emergency2_last'];
    emergency2_address1 = json['emergency2_address1'];
    emergency2_address2 = json['emergency2_address2'];
    emergency2_city = json['emergency2_city'];
    emergency2_countryID = json['emergency2_countryID'];
    emergency2_email = json['emergency2_email'];
    emergency2_ph_home = json['emergency2_ph_home'];
    emergency2_ph_mobile = json['emergency2_ph_mobile'];
    emergency2_ph_work = json['emergency2_ph_work'];
    emergency2_relationship = json['emergency2_relationship'];
    emergency2_state = json['emergency2_state'];
    emergency2_zip = json['emergency2_zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.emergency_first != null) {
      data['emergency_first'] = this.emergency_first;
    }
    if (this.emergency_last != null) {
      data['emergency_last'] = this.emergency_last;
    }
    if (this.emergency_address1 != null) {
      data['emergency_address1'] = this.emergency_address1;
    }
    if (this.emergency_address2 != null) {
      data['emergency_address2'] = this.emergency_address2;
    }
    if (this.emergency_city != null) {
      data['emergency_city'] = this.emergency_city;
    }
    if (this.emergency_countryID != null) {
      data['emergency_countryID'] = this.emergency_countryID;
    }
    if (this.emergency_email != null) {
      data['emergency_email'] = this.emergency_email;
    }
    if (this.emergency_ph_home != null) {
      data['emergency_ph_home'] = this.emergency_ph_home;
    }
    if (this.emergency_ph_mobile != null) {
      data['emergency_ph_mobile'] = this.emergency_ph_mobile;
    }
    if (this.emergency_ph_work != null) {
      data['emergency_ph_work'] = this.emergency_ph_work;
    }
    if (this.emergency_relationship != null) {
      data['emergency_relationship'] = this.emergency_relationship;
    }
    if (this.emergency_state != null) {
      data['emergency_state'] = this.emergency_state;
    }
    if (this.emergency_zip != null) {
      data['emergency_zip'] = this.emergency_zip;
    }
    if (this.emergency2_first != null) {
      data['emergency2_first'] = this.emergency2_first;
    }
    if (this.emergency2_last != null) {
      data['emergency2_last'] = this.emergency2_last;
    }
    if (this.emergency2_address1 != null) {
      data['emergency2_address1'] = this.emergency2_address1;
    }
    if (this.emergency2_address2 != null) {
      data['emergency2_address2'] = this.emergency2_address2;
    }
    if (this.emergency2_city != null) {
      data['emergency2_city'] = this.emergency2_city;
    }
    if (this.emergency2_countryID != null) {
      data['emergency2_countryID'] = this.emergency2_countryID;
    }
    if (this.emergency2_email != null) {
      data['emergency2_email'] = this.emergency2_email;
    }
    if (this.emergency2_ph_home != null) {
      data['emergency2_ph_home'] = this.emergency2_ph_home;
    }
    if (this.emergency2_ph_mobile != null) {
      data['emergency2_ph_mobile'] = this.emergency2_ph_mobile;
    }
    if (this.emergency2_ph_work != null) {
      data['emergency2_ph_work'] = this.emergency2_ph_work;
    }
    if (this.emergency2_relationship != null) {
      data['emergency2_relationship'] = this.emergency2_relationship;
    }
    if (this.emergency2_state != null) {
      data['emergency2_state'] = this.emergency2_state;
    }
    if (this.emergency2_zip != null) {
      data['emergency2_zip'] = this.emergency2_zip;
    }
    return data;
  }
}
