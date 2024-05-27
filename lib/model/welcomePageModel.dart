class WelcomePageModel {
  String? first;
  int? nights;
  String? destination;
  DateTime? startDate;
  String? last;
  int? reservationid;
  int? charterid;
  int? resellerid;
  String? startdate;
  String? inventoryid;
  String? abbreviation;
  String? itinerary;
  String? reservationistemail;

  WelcomePageModel(
      {this.destination,
      this.first,
      this.nights,
      this.startDate,
      this.last,
      this.reservationid,
      this.charterid,
      this.resellerid,
      this.startdate,
      this.inventoryid,
      this.abbreviation,
      this.itinerary,
      this.reservationistemail});

  WelcomePageModel.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    nights = json['nights'];
    destination = json['destination'];
    startDate =
        json['startdate'] != null ? DateTime.parse(json['startdate']) : null;
    first = json['first'];
    last = json['last'];
    reservationid = json['reservationid'];
    charterid = json['charterid'];
    resellerid = json['resellerid'];
    inventoryid = json['inventoryid'];
    abbreviation = json['abbreviation'];
    itinerary = json['itinerary'];
    reservationistemail = json['reservationistemail'];
  }
}
