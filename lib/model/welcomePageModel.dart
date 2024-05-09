class WelcomePageModel {
  String? first;
  int? nights;
  String? destination;
  DateTime? startDate;

  WelcomePageModel({this.destination, this.first, this.nights, this.startDate});

  WelcomePageModel.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    nights = json['nights'];
    destination = json['destination'];
    startDate =
        json['startdate'] != null ? DateTime.parse(json['startdate']) : null;
  }
}
