import 'package:flutter/material.dart';

class TravelInformationModel {
  String? airport;
  String? airline;
  String? flightNum;
  String? flightType;
  String? flightDate;
  late TextEditingController airportController;
  late TextEditingController airlineController;
  late TextEditingController flightNumberController;
  late TextEditingController flightTypeController;
  late TextEditingController flightDateController;

//   TextEditingController DepartureAirportController = TextEditingController();
// TextEditingController DepartureFlightNumberController = TextEditingController();
// TextEditingController DepartureAirlineController = TextEditingController();
// TextEditingController DepartureDateAndTimeController = TextEditingController();

  TravelInformationModel({
    this.airline,
    this.airport,
    this.flightDate,
    this.flightNum,
    this.flightType,
    required this.airlineController,
    required this.flightNumberController,
    required this.flightDateController,
    required this.flightTypeController,
    required this.airportController,
  });

  TravelInformationModel.fromJson(Map<String, dynamic> json) {
    airportController = TextEditingController(text: json['airport']);
    airlineController = TextEditingController(text: json['airline']);
    flightNumberController = TextEditingController(text: json['flightNum']);
    flightTypeController = TextEditingController(text: json['flightType']);
    flightDateController = TextEditingController(text: json['flightDate']);

    airport = json['airport'];
    airline = json['airline'];
    flightNum = json['flightNum'];
    flightType = json['flightType'];
    flightDate = json['flightDate'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.airport != null) {
      data['airport'] = this.airport;
    }
    if (this.airline != null) {
      data['airline'] = this.airline;
    }
    if (this.flightNum != null) {
      data['flightNum'] = this.flightNum;
    }
    if (this.flightType != null) {
      data['flightType'] = this.flightType;
    }
    if (this.flightDate != null) {
      data['flightDate'] = this.flightDate;
    }
    return data;
  }
}
