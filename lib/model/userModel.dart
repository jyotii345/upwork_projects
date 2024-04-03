class UserModel {
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? province;
  String? zip;
  String? homePhone;
  String? workPhone;
  String? mobilePhone;
  String? accountType;
  UserModel(
      {this.address1,
      this.address2,
      this.city,
      this.email,
      this.firstName,
      this.homePhone,
      this.lastName,
      this.mobilePhone,
      this.province,
      this.state,
      this.userName,
      this.workPhone,
      this.zip,
      this.accountType});

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first'];
    lastName = json['last'];
    userName = json['username'];
    email = json['email'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    province = json['province'];
    zip = json['zip'];
    homePhone = json['home_phone'];
    workPhone = json['work_phone'];
    mobilePhone = json['mobile_phone'];
    accountType = json['account_type'];
  }
}
