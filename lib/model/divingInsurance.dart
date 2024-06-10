import 'package:aggressor_adventures/classes/utils.dart';

class DivingInsuranceModel {
  String? certification_level;
  String? nitrox_agency;
  String? nitrox_number;
  DateTime? certificationDate;
  String? certification_agency;
  DateTime? nitrox_date;
  String? certification_number;
  bool? dive_insurance;
  String? dive_insurance_co;
  String? dive_insurance_number;
  String? dive_insurance_other;
  DateTime? dive_insurance_date;
  bool? equipment_insurance;
  String? equipment_policy;
  DivingInsuranceModel(
      {this.certification_agency,
      this.certification_level,
      this.certification_number,
      this.dive_insurance,
      this.certificationDate,
      this.dive_insurance_co,
      this.dive_insurance_other,
      this.nitrox_agency,
      this.nitrox_date,
      this.nitrox_number,
      this.dive_insurance_date,
      this.equipment_insurance,
      this.equipment_policy,
      this.dive_insurance_number});

  DivingInsuranceModel.fromJson(Map<String, dynamic> json) {
    certification_level = json['certificationLevel'];
    nitrox_agency = json['nitroxAgency'];
    certificationDate = DateTime.parse(json['certificationDate']);
    nitrox_number = json['nitroxNumber'];
    certification_agency = json['certificationAgency'];
    if (json['nitroxDate'] != null) {
      nitrox_date = DateTime.parse(json['nitroxDate']);
    }
    certification_number = json['certificationNumber'];
    dive_insurance = json['diveInsurance'];
    dive_insurance_co = json['diveInsuranceCo'];
    dive_insurance_other = json['diveInsuranceOther'];
    dive_insurance_number = json['diveInsuranceNumber'];
    if (json['diveInsuranceDate'] != null) {
      dive_insurance_date = DateTime.parse(json['diveInsuranceDate']);
    }
    equipment_insurance = json['equipmentInsurance'] == 'yes' ? true : false;
    equipment_policy = json['equipmentPolicy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.certification_agency != null) {
      data['certification_agency'] = this.certification_agency;
    }
    if (this.certificationDate != null) {
      data['certification_date'] =
          Utils.getFormattedDateForBackend(date: this.certificationDate!);
    }

    if (this.certification_level != null) {
      data['certification_level'] = this.certification_level;
    }

    if (this.certification_number != null) {
      data['certification_number'] = this.certification_number;
    }

    if (this.dive_insurance != null) {
      data['dive_insurance'] = this.dive_insurance.toString();
    }

    if (this.dive_insurance_co != null) {
      data['dive_insurance_co'] = this.dive_insurance_co;
    }

    if (this.dive_insurance_other != null) {
      data['dive_insurance_other'] = this.dive_insurance_other;
    }

    if (this.nitrox_agency != null) {
      data['nitrox_agency'] = this.nitrox_agency;
    }

    if (this.nitrox_date != null) {
      data['nitrox_date'] =
          Utils.getFormattedDateForBackend(date: this.nitrox_date!);
    }

    if (this.nitrox_number != null) {
      data['nitrox_number'] = this.nitrox_number;
    }
    if (this.dive_insurance_date != null) {
      data['dive_insurance_date'] =
          Utils.getFormattedDateForBackend(date: this.dive_insurance_date!);
    }
    if (this.equipment_insurance != null) {
      data['equipment_insurance'] = this.equipment_insurance! ? 'yes' : 'no';
    }
    if (this.equipment_policy != null) {
      data['equipment_policy'] = this.equipment_policy;
    }
    if (this.dive_insurance_number != null) {
      data['dive_insurance_number'] = this.dive_insurance_number;
    }
    return data;
  }
}
