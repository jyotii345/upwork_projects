class ReservationModel {
  String? tripDate;
  String? title;
  String? latitude;
  String? longitude;
  String? destination;
  String? reservationDate;
  int? reservationid;
  String? charterid;
  int? boatid;
  String? loginKey;
  int? passengerid;

  ReservationModel(
      {this.tripDate,
      this.title,
      this.latitude,
      this.longitude,
      this.destination,
      this.reservationDate,
      this.reservationid,
      this.charterid,
      this.boatid,
      this.loginKey,
      this.passengerid});

  ReservationModel.fromJson(Map<String, dynamic> json) {
    tripDate = json['tripDate'];
    title = json['title'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    destination = json['destination'];
    reservationDate = json['reservationDate'];
    reservationid = json['reservationid'];
    charterid = json['charterid'];
    boatid = json['boatid'];
    loginKey = json['loginKey'];
    passengerid = json['passengerid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tripDate'] = this.tripDate;
    data['title'] = this.title;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['destination'] = this.destination;
    data['reservationDate'] = this.reservationDate;
    data['reservationid'] = this.reservationid;
    data['charterid'] = this.charterid;
    data['boatid'] = this.boatid;
    data['loginKey'] = this.loginKey;
    data['passengerid'] = this.passengerid;
    return data;
  }
}
