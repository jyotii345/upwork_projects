import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/model/masterModel.dart';

class RentalModel {
  List<MasterModel>? coursesList;
  List<MasterModel>? rentalsList;
  String? others;
  RentalModel({this.coursesList, this.rentalsList, this.others});

  RentalModel.fromJson(Map<String, dynamic> decodedJson) {
    Map<String, dynamic>? json = decodedJson['0'];
    others = json?['otherRental'] ?? '';
    coursesList = [
      MasterModel(
        id: 0,
        title: "Nitrox",
        abbv: "Nitrox",
        isChecked: false,
      ),
      MasterModel(
          id: 1,
          title: "PADI Advanced Open Water Diver Course",
          abbv: "Advanced Open Water",
          isChecked: false),
      MasterModel(
          id: 2,
          title: "SSI Advanced Adventurer Course",
          abbv: "Deep Diver",
          isChecked: false),
      MasterModel(
          id: 3,
          title: "Open Water Check-Out Dives",
          abbv: "O/W Check-out",
          isChecked: false),
    ];
    rentalsList = [
      MasterModel(
          id: 0,
          title: "Dive Computer",
          abbv: "Dive Computer",
          isChecked: false),
      MasterModel(
          id: 1,
          title: "BC",
          abbv: "BC",
          isChecked: false,
          subCategories: [
            MasterModel(id: 1, title: "XS", abbv: "BC (xs)", isChecked: false),
            MasterModel(id: 3, title: "S", abbv: "BC (s)", isChecked: false),
            MasterModel(id: 4, title: "M", abbv: "BC (m)", isChecked: false),
            MasterModel(id: 2, title: "L", abbv: "BC (l)", isChecked: false),
            MasterModel(id: 2, title: "XL", abbv: "BC (xl)", isChecked: false),
            MasterModel(
                id: 5, title: "2XL", abbv: "BC (2xl)", isChecked: false),
          ]),
      MasterModel(
          id: 2, title: "Regulator", abbv: "Regulator", isChecked: false),
      MasterModel(
          id: 3,
          title: "Nitrox(Unlimited)",
          abbv: "Nitrox(Unlimited)",
          isChecked: false),
      MasterModel(id: 4, title: "Mask", abbv: "Mask", isChecked: false),
      MasterModel(id: 5, title: "Fins", abbv: "Fins", isChecked: false),
      MasterModel(id: 6, title: "Snorkel", abbv: "Snorkel", isChecked: false),
      MasterModel(
          id: 7, title: "Dive Light", abbv: "Dive Light", isChecked: false),
    ];

    if (json?['rentalEquipment'] != null &&
        json?['rentalEquipment']?.isNotEmpty) {
      List<String> listOfRentals = json?['rentalEquipment']!.split(',');
      for (var rental in listOfRentals) {
        if (rental.isNotEmpty) {
          MasterModel currentRental = rentalsList!.firstWhere(
              (element) => element.abbv == rental,
              orElse: () => MasterModel());
          if (currentRental.id != null) {
            currentRental.isChecked = true;
          }
        }
      }
    }
    if (json?['course'] != null && json?['course']?.isNotEmpty) {
      List<String> listOfCourses = json?['course']!.split(',');
      for (var course in listOfCourses) {
        if (course.isNotEmpty) {
          MasterModel currentCourse =
              coursesList!.firstWhere((element) => element.abbv == course);
          currentCourse.isChecked = true;
        }
      }
    }
    if (json?['rentalEquipment'] != null &&
        json?['rentalEquipment']!.isNotEmpty) {
      List<String> listOfRentalsForBcSize =
          json?['rentalEquipment']!.split(',');
      for (var bcSize in rentalsList![1].subCategories!) {
        listOfRentalsForBcSize.contains(bcSize.abbv)
            ? bcSize.isChecked = true
            : null;
      }
    }
  }
}
