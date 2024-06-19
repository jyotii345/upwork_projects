class FormStatusModel {
  String? general;
  String? travel;
  String? emcontact;
  String? requests;
  String? rentals;
  String? activities;
  String? diving;
  String? insurance;
  String? waiver;
  String? policy;
  String? confirmation;
  String? options;
  FormStatusModel(
      {this.activities,
      this.confirmation,
      this.diving,
      this.emcontact,
      this.general,
      this.insurance,
      this.options,
      this.policy,
      this.rentals,
      this.requests,
      this.travel,
      this.waiver});

  FormStatusModel.fromJson(Map<String, dynamic> json) {
    general = json['general'];
    travel = json['travel'];
    emcontact = json['emcontact'];
    requests = json['requests'];
    rentals = json['rentals'];
    diving = json['diving'];
    insurance = json['insurance'];
    waiver = json['waiver'];
    policy = json['policy'];
    confirmation = json['confirmation'];
    options = json['options'];
    activities = json['activities'];
  }
}
