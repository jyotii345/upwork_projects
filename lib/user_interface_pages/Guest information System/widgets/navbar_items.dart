import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/gis_welcome_page.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/model/AppBarModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/model/formStatusModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/divingInsurance.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/guest_information.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/waiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import '../../../classes/user.dart';
import '../../main_page.dart';
import '../../trips_page.dart';
import '../pages/confirmation.dart';
import '../pages/emergency_contact.dart';
import '../pages/policy.dart';
import '../pages/rental_and_courses.dart';
import '../pages/requests.dart';
import '../pages/travel_information.dart';
import '../pages/tripInsurance.dart';

class AppBarItems extends StatefulWidget {
  AppBarItems({
    Key? key,
    required this.charterID,
    required this.reservationID,
  }) : super(key: key);
  final String charterID;
  final String reservationID;
  @override
  State<AppBarItems> createState() => _AppBarItemsState();
}

AggressorApi aggressorApi = AggressorApi();

class _AppBarItemsState extends State<AppBarItems> {
  List<AppDrawerModel> drawersList = [];
  bool isLoading = true;
  getDrawersList() {
    drawersList.clear();
    drawersList.addAll([
      AppDrawerModel(
          title: 'Home',
          onTap: () {
            Scaffold.of(context).closeDrawer();
            Navigator.pushAndRemoveUntil(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (route) => false,
            );
          },
          id: 0),
      AppDrawerModel(
          title: 'Guest Informaition',
          taskStatus: form_status.general,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => GuestInformationPage(
                          charID: widget.charterID,
                          reservationID: widget.reservationID,
                          currentTrip: widget.charterID,
                        )));
          },
          id: 1),
      AppDrawerModel(
          title: 'Waiver',
          taskStatus: form_status.waiver,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => Waiver(
                          charterID: widget.charterID,
                          reservationID: widget.reservationID,
                        )));
          },
          id: 2),
      AppDrawerModel(
        title: 'Policies',
        taskStatus: form_status.policy,
        onTap: () {
          Scaffold.of(context).closeDrawer();
          Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) => Policy(
                      charterID: widget.charterID,
                      reservationID: widget.reservationID)));
        },
        id: 3,
      ),
      AppDrawerModel(
          title: 'Emergency Contact',
          taskStatus: form_status.emcontact,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => EmergencyContact(
                          charID: widget.charterID,
                          reservationID: widget.reservationID,
                          currentTrip: widget.charterID,
                        )));
          },
          id: 4),
      AppDrawerModel(
          title: 'Requests',
          taskStatus: form_status.requests,
          onTap: () {
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => Requests(
                          charID: widget.charterID,
                          reservationID: widget.reservationID,
                          currentTrip: widget.charterID,
                        )));
          },
          id: 5),
      AppDrawerModel(
          title: 'Rentals & Courses',
          taskStatus: form_status.rentals,
          onTap: () {
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => RentalAndCourses(
                          charterID: widget.charterID,
                          reservationID: widget.reservationID,
                        )));
          },
          id: 6),
      AppDrawerModel(
          title: 'Diving Insurance',
          taskStatus: form_status.diving,
          onTap: () {
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => DivingInsurance(
                          charterID: widget.charterID,
                          reservationID: widget.reservationID,
                        )));
          },
          id: 7),
      AppDrawerModel(
          title: 'Trip Insurance',
          taskStatus: form_status.insurance,
          onTap: () {
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => TripInsurance(
                          charterID: widget.charterID,
                          reservationID: widget.reservationID,
                        )));
          },
          id: 8),
      AppDrawerModel(
          title: 'Travel Inforamtion',
          taskStatus: form_status.travel,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => TravelInformation(
                          reservationID: widget.reservationID,
                        )));
          },
          id: 9),
      AppDrawerModel(
          title: 'Confirmation',
          taskStatus: form_status.confirmation,
          onTap: () {
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => Confirmation(
                          charterID: widget.charterID,
                          reservationID: widget.reservationID,
                        )));
          },
          id: 10),
      // AppDrawerModel(
      //     title: 'Home',
      //     onTap: () {
      //       // Scaffold.of(context).closeDrawer();

      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => MyHomePage()),
      //       );
      //     },
      //     id: 10),
    ]);
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  getInitialData() async {
    setState(() {
      isLoading = true;
    });
    await formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    getDrawersList();
    setState(() {
      isLoading = false;
    });
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Expanded(child: Center(child: CircularProgressIndicator()))
        : Expanded(
            child: ListView.builder(
              itemCount: drawersList.length,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemBuilder: (context, index) {
                return ItemBuilder(
                    index: index, status: drawersList[index].taskStatus);
              },
            ),
          );
  }

  ItemBuilder({required int index, required String? status}) {
    Color color2 = Colors.grey; // Second color
    Color color1 = Colors.red; // First color

    Color blendedColor = Color.alphaBlend(color1.withOpacity(0.1), color2);
    return GestureDetector(
      onTap: () {
        if (appDrawerselectedIndex == index) {
          Scaffold.of(context).closeDrawer();
        } else {
          if (index == 9 ||
              !(index == 1 || index == 0
                  ? false
                  : drawersList[index - 1].taskStatus == '0')) {
            setState(() {
              appDrawerselectedIndex = index;
            });
            drawersList[index].onTap!();
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: CircleAvatar(
                    backgroundColor: status == "1" || status == "2"
                        ? Colors.green
                        : index == 0
                            ? Colors.grey
                            : (appDrawerselectedIndex == index || index == 9) ||
                                    ((drawersList[index - 1].taskStatus ==
                                                '1' ||
                                            drawersList[index - 1].taskStatus ==
                                                '2') &&
                                        drawersList[index].taskStatus == '0')
                                ? Colors.red
                                : Colors.grey),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 25.w,
                ),
                child: Text(
                  drawersList[index].title!,
                  style: TextStyle(
                      fontSize: 14,
                      color: appDrawerselectedIndex == index
                          ? Colors.black
                          : blendedColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPicker extends picker.CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, picker.LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
