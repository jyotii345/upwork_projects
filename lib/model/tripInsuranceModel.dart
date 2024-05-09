class TripInsuranceModel {
  String? trip_insurance;
  String? trip_insurance_co;
  String? trip_insurance_other;
  String? trip_insurance_number;
  String? trip_insurance_date;
  TripInsuranceModel(
      {this.trip_insurance,
      this.trip_insurance_co,
      this.trip_insurance_number,
      this.trip_insurance_other,
      this.trip_insurance_date});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trip_insurance != null) {
      data['trip_insurance'] = this.trip_insurance;
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
      data['trip_insurance_date'] = this.trip_insurance_date;
    }
    return data;
  }
}
