import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/guest_information_welcome_page.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/model/AppBarModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/divingInsurance.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/guest_information.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/waiver.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui.dart';

import '../../../classes/user.dart';
import '../pages/confirmation.dart';
import '../pages/emergency_contact.dart';
import '../pages/policy.dart';
import '../pages/rental_and_courses.dart';
import '../pages/requests.dart';
import '../pages/travel_information.dart';
import '../pages/tripInsurance.dart';

class AppBarItems extends StatefulWidget {
  AppBarItems(
      {Key? key,
      required this.charterID,
      required this.reservationID,
      this.user})
      : super(key: key);
  final String charterID;
  final String reservationID;
  User? user;
  @override
  State<AppBarItems> createState() => _AppBarItemsState();
}

AppDrawerModel model = AppDrawerModel();
int selectedIndex = -1;

class _AppBarItemsState extends State<AppBarItems> {
  List<AppDrawerModel> drawersList = [];

  getDrawersList() {
    drawersList.addAll([
      AppDrawerModel(
          title: 'Guest Informaition',
          isSaved: true,
          isSelected: false,
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
          id: 0),
      AppDrawerModel(
          title: 'Waiver',
          isSaved: false,
          isSelected: false,
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
          id: 1),
      AppDrawerModel(
        title: 'Policies',
        isSaved: false,
        isSelected: false,
        onTap: () {
          Scaffold.of(context).closeDrawer();
          Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) => Policy(
                      charterID: widget.charterID,
                      reservationID: widget.reservationID)));
        },
        id: 2,
      ),
      AppDrawerModel(
          title: 'Emergency Contact',
          isSaved: false,
          isSelected: false,
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
          id: 3),
      AppDrawerModel(
          title: 'Requests',
          isSaved: false,
          isSelected: false,
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
          id: 4),
      AppDrawerModel(
          title: 'Rentals & Courses',
          isSaved: false,
          isSelected: false,
          onTap: () {
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => RentalAndCourses(
                          charterID: widget.charterID,
                          reservationID: widget.reservationID,
                        )));
          },
          id: 5),
      AppDrawerModel(
          title: 'Diving Insurance',
          isSaved: false,
          isSelected: false,
          onTap: () {
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => DivingInsurance(
                          charterID: widget.charterID,
                          reservationID: widget.reservationID,
                        )));
          },
          id: 6),
      AppDrawerModel(
          title: 'Trip Insurance',
          isSaved: false,
          isSelected: false,
          onTap: () {
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => TripInsurance(
                          charterID: widget.charterID,
                          reservationID: widget.reservationID,
                        )));
          },
          id: 7),
      AppDrawerModel(
          title: 'Confirmation',
          isSaved: false,
          isSelected: false,
          onTap: () {
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => Confirmation(
                          charterID: widget.charterID,
                          reservationID: widget.reservationID,
                        )));
          },
          id: 8),
      AppDrawerModel(
          title: 'Travel Inforamtion',
          isSaved: false,
          isSelected: false,
          onTap: () {
            // Scaffold.of(context).closeDrawer();
            Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => TravelInformation(
                          charID: widget.charterID,
                          reservationID: widget.reservationID,
                          currentTrip: widget.charterID,
                        )));
          },
          id: 9),
      AppDrawerModel(
          title: 'Logout',
          isSaved: false,
          isSelected: false,
          onTap: () {},
          id: 10),
    ]);
  }

  @override
  void initState() {
    getDrawersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 670,
      child: ListView.builder(
        itemCount: drawersList.length,
        itemBuilder: (context, index) {
          return ItemBuilder(index: index);
        },
      ),
    );
  }

  ItemBuilder({required int index}) {
    Color color2 = Colors.grey; // Second color
    Color color1 = Colors.red; // First color

    Color blendedColor = Color.alphaBlend(color1.withOpacity(0.1), color2);
    return GestureDetector(
      onTap: () {
        if (selectedIndex == index) {
          Scaffold.of(context).closeDrawer();
        } else {
          setState(() {
            selectedIndex = index;
            drawersList[index].isSelected = !drawersList[index].isSelected!;
          });
          drawersList[index].onTap!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CircleAvatar(
                    backgroundColor:
                        selectedIndex == index ? Colors.green : blendedColor),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                ),
                child: Text(
                  drawersList[index].title!,
                  style: TextStyle(
                      fontSize: 14,
                      color:
                          selectedIndex == index ? Colors.black : blendedColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
