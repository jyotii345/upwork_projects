class Countries {
  String? country;
  int? countryId;
  Countries({this.countryId, this.country});

  Countries.fromJson(Map<String,dynamic> json){
    country = json['country'];
    countryId = json['countryid'];
  }
}
