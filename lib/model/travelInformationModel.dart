import 'package:flutter/material.dart';

class TravelInformationModel {
  String? airport;
  String? airline;
  String? flightNum;
  String? flightType;
  int? flightId;
  DateTime? flightDate;
  late TextEditingController? airportController;
  late TextEditingController? airlineController;
  late TextEditingController? flightNumberController;
  late TextEditingController? flightTypeController;
  late TextEditingController? flightDateController;

  TravelInformationModel({
    this.airline,
    this.airport,
    this.flightDate,
    this.flightNum,
    this.flightType,
    this.flightId,
    this.airlineController,
    this.flightNumberController,
    this.flightDateController,
    this.flightTypeController,
    this.airportController,
  });

  TravelInformationModel.fromJson(Map<String, dynamic> json) {
    airportController = TextEditingController(text: json['airport']);
    airlineController = TextEditingController(text: json['airline']);
    flightNumberController = TextEditingController(text: json['flight_num']);
    flightTypeController = TextEditingController(text: json['flight_type']);
    flightDateController = TextEditingController(text: json['flight_time']);

    airport = json['airport'];
    airline = json['airline'];
    flightNum = json['flightNum'];
    flightType = json['flightType'];
    flightId = json['flightId'];
    flightDate =
        json['flightDate'] != null ? DateTime.parse(json['flightDate']) : null;
    ;
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
      data['flight_num'] = this.flightNum;
    }
    if (this.flightType != null) {
      data['flight_type'] = this.flightType;
    }
    if (this.flightDate != null) {
      data['flight_time'] = this.flightDate;
    }
    if (this.flightId != null) {
      data['flightId'] = this.flightId;
    }
    return data;
  }
}
