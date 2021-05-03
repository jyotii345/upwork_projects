import 'dart:ui';

class Trip {
  String tripDate;
  String title;
  String latitude;
  String longitude;
  String destination;
  String reservationDate;
  String reservationId;

  Trip(
    String tripDate,
    String title,
    String latitude,
    String longitude,
    String destination,
    String reservationDate,
    String reservationId,
  ) {
    this.tripDate = tripDate;
    this.title = title;
    this.latitude = latitude;
    this.longitude = longitude;
    this.destination = destination;
    this.reservationDate = reservationDate;
    this.reservationId = reservationId;
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      json['tripDate'] as String,
      json['title'] as String,
      json['latitude'] as String,
      json['longitude'] as String,
      json['destination'] as String,
      json['reservationDate'] as String,
      json['reservationId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripDate': tripDate,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'destination': destination,
      'OFYContactId': reservationDate,
      'reservationId': reservationId,
    };
  }
}
