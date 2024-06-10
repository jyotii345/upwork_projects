import 'package:aggressor_adventures/classes/utils.dart';
import 'package:flutter/material.dart';

class TripInsuranceModel {
  bool? trip_insurance;
  String? trip_insurance_co;
  String? trip_insurance_other;
  String? trip_insurance_number;
  DateTime? trip_insurance_date;
  TripInsuranceModel(
      {this.trip_insurance,
      this.trip_insurance_co,
      this.trip_insurance_number,
      this.trip_insurance_other,
      this.trip_insurance_date});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trip_insurance != null) {
      data['trip_insurance'] = this.trip_insurance! ? 1 : 0;
    }
    if (this.trip_insurance_co != null) {
      data['trip_insurance_co'] = this.trip_insurance_co;
    }
    if (this.trip_insurance_other != null) {
      data['trip_insurance_other'] = this.trip_insurance_other;
    }
    if (this.trip_insurance_number != null) {
      data['trip_insurance_number'] = this.trip_insurance_number;
    }
    if (this.trip_insurance_date != null) {
      data['trip_insurance_date'] =
          Utils.getFormattedDateForBackend(date: this.trip_insurance_date!);
    }
    return data;
  }

  TripInsuranceModel.fromJson(Map<String, dynamic> json) {
    trip_insurance = json['tripInsurance'];
    trip_insurance_co = json['tripInsuranceCo'];
    trip_insurance_other = json['tripInsuranceOther'];
    trip_insurance_number = json['tripInsuranceNumber'];
    if (json['tripInsuranceDate'] != null) {
      trip_insurance_date = DateTime.parse(json['tripInsuranceDate']);
    }
  }
}
