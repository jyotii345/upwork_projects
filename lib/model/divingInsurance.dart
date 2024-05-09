class DivingInsuranceModel {
  String? certification_level;
  String? nitrox_agency;
  String? nitrox_number;
  String? certification_agency;
  String? nitrox_date;
  String? certification_number;
  String? dive_insurance;
  String? dive_insurance_co;
  String? dive_insurance_number;
  String? dive_insurance_other;
  String? dive_insurance_date;
  String? equipment_insurance;
  String? equipment_policy;
  DivingInsuranceModel(
      {this.certification_agency,
      this.certification_level,
      this.certification_number,
      this.dive_insurance,
      this.dive_insurance_co,
      this.dive_insurance_other,
      this.nitrox_agency,
      this.nitrox_date,
      this.nitrox_number,
      this.dive_insurance_date,
      this.equipment_insurance,
      this.equipment_policy,
      this.dive_insurance_number});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.certification_agency != null) {
      data['certification_agency'] = this.certification_agency;
    }

    if (this.certification_level != null) {
      data['certification_level'] = this.certification_level;
    }

    if (this.certification_number != null) {
      data['certification_number'] = this.certification_number;
    }

    if (this.dive_insurance != null) {
      data['dive_insurance'] = this.dive_insurance;
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
      data['nitrox_date'] = this.nitrox_date;
    }

    if (this.nitrox_number != null) {
      data['nitrox_number'] = this.nitrox_number;
    }
    if (this.dive_insurance_date != null) {
      data['dive_insurance_date'] = this.dive_insurance_date;
    }
    if (this.equipment_insurance != null) {
      data['equipment_insurance'] = this.equipment_insurance;
    }
    if (this.equipment_insurance != null) {
      data['equipment_policy'] = this.equipment_policy;
    }
    if (this.dive_insurance_number != null) {
      data['dive_insurance_number'] = this.dive_insurance_number;
    }
    return data;
  }
}
