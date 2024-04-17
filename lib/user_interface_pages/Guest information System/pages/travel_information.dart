import 'package:aggressor_adventures/model/emergencyContactModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/guest_information.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/aggressor_button.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/text_style.dart';
import 'package:aggressor_adventures/user_interface_pages/trips_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../classes/aggressor_api.dart';
import '../../../classes/aggressor_colors.dart';
import '../../../classes/globals.dart';
import '../../../classes/globals_user_interface.dart';
import '../../../classes/user.dart';
import '../../../classes/utils.dart';
import '../../widgets/info_banner_container.dart';
import '../model/masterModel.dart';
import '../widgets/dropDown.dart';
import '../widgets/text_field.dart';

class TravelInformation extends StatefulWidget {
  TravelInformation({
    super.key,
    required this.charID,
    required this.currentTrip,
    required this.reservationID,
  });
  final String charID;
  final String currentTrip;
  final String reservationID;

  @override
  State<TravelInformation> createState() => _TravelInformationState();
}

final AggressorApi aggressorApi = AggressorApi();

TextEditingController ArrivalAirportController = TextEditingController();
TextEditingController ArrivalFlightNumberController = TextEditingController();
TextEditingController ArrivalAirlineController = TextEditingController();
TextEditingController ArrivalDateAndTimeController = TextEditingController();

TextEditingController DepartureAirportController = TextEditingController();
TextEditingController DepartureFlightNumberController = TextEditingController();
TextEditingController DepartureAirlineController = TextEditingController();
TextEditingController DepartureDateAndTimeController = TextEditingController();
DateTime? arrivalDateAndTime;
DateTime? departureDateAndTime;
final primaryFormKey = GlobalKey<FormState>();
final secondaryFormKey = GlobalKey<FormState>();

class _TravelInformationState extends State<TravelInformation> {
  Future<void> _selectDepartureDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: departureDateAndTime,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != departureDateAndTime) {
      setState(() {
        departureDateAndTime = picked;
      });
    }
  }

  Future<void> _selectArrivalDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: arrivalDateAndTime,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != arrivalDateAndTime) {
      setState(() {
        arrivalDateAndTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getGISAppDrawer(
          charterID: widget.charID, reservationID: widget.reservationID),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(
              Icons.menu_outlined,
              color: Color(0xff418cc7),
              size: 22,
            ),
            color: AggressorColors.secondaryColor,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Image.asset(
            "assets/logo.png",
            height: AppBar().preferredSize.height,
            fit: BoxFit.fitHeight,
          ),
        ),
        actions: <Widget>[
          SizedBox(
            height: AppBar().preferredSize.height,
            child: IconButton(
              icon: Container(
                child: Image.asset("assets/callicon.png"),
              ),
              onPressed: makeCall,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xfff4f3ef),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            child: Column(
              children: [
                InfoBannerContainer(
                  bgColor: AggressorColors.aero,
                  infoText:
                      'Travel information does not have to be completed now to confirm your reservation, however, it will need to be completed prior to traveling. You may return to this page at any time by opening this same GIS link to complete your travel information. If transfers are not included in your yacht package, please contact your yacht specialist to confirm these arrangements.',
                ),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                    width: double.infinity,
                    height: 410.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.h, vertical: 10.h),
                              child: Text(
                                "ARRIVAL INFORMATION (before your trip)",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          AdventureFormField(
                              validator: (value) =>
                                  ArrivalAirportController.text.isNotEmpty
                                      ? null
                                      : " ",
                              labelText: "Arrival Airport",
                              controller: ArrivalAirportController),
                          AdventureFormField(
                              validator: (value) =>
                                  ArrivalFlightNumberController.text.isNotEmpty
                                      ? null
                                      : " ",
                              labelText: "Flight Number",
                              controller: ArrivalFlightNumberController),
                          AdventureFormField(
                              validator: (value) =>
                                  ArrivalAirlineController.text.isNotEmpty
                                      ? null
                                      : " ",
                              labelText: "Airline",
                              controller: ArrivalAirlineController),
                          AdventureFormField(
                              readOnly: true,
                              validator: (value) =>
                                  ArrivalDateAndTimeController.text.isNotEmpty
                                      ? null
                                      : " ",
                              labelText: arrivalDateAndTime != null
                                  ? Utils.getFormattedDate(
                                      date: arrivalDateAndTime!)
                                  : "Arrival date & time",
                              controller: ArrivalDateAndTimeController),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
                            child: AggressorButton(
                              onPressed: () async {},
                              buttonName: 'SAVE NEW FLIGHT',
                              AggressorButtonColor: AggressorColors.seaGreen,
                              AggressorTextColor: AggressorColors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 25.h),
                Container(
                    width: double.infinity,
                    height: 410.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.h, vertical: 10.h),
                              child: Text(
                                "DEPARTURE INFORMATION (after your trip)",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          AdventureFormField(
                              validator: (value) =>
                                  DepartureAirportController.text.isNotEmpty
                                      ? null
                                      : " ",
                              labelText: "Departure Airport:",
                              controller: DepartureFlightNumberController),
                          AdventureFormField(
                              validator: (value) =>
                                  DepartureFlightNumberController
                                          .text.isNotEmpty
                                      ? null
                                      : " ",
                              labelText: "Flight Number",
                              controller: DepartureFlightNumberController),
                          AdventureFormField(
                              validator: (value) =>
                                  DepartureAirlineController.text.isNotEmpty
                                      ? null
                                      : " ",
                              labelText: "Airline",
                              controller: DepartureAirlineController),
                          AdventureFormField(
                              onTap: () => _selectDepartureDate(
                                    context,
                                  ),
                              validator: (value) =>
                                  DepartureDateAndTimeController.text.isNotEmpty
                                      ? null
                                      : " ",
                              labelText: departureDateAndTime != null
                                  ? Utils.getFormattedDate(
                                      date: departureDateAndTime!)
                                  : "Arrival date & time",
                              controller: DepartureDateAndTimeController),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
                            child: AggressorButton(
                              onPressed: () async {},
                              buttonName: 'SAVE NEW FLIGHT',
                              AggressorButtonColor: AggressorColors.seaGreen,
                              AggressorTextColor: AggressorColors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: AggressorButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonName: 'Cancel',
                          AggressorButtonColor: AggressorColors.chromeYellow,
                          AggressorTextColor: AggressorColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: AggressorButton(
                          onPressed: () async {},
                          buttonName:
                              'I HAVE COMPLETED ALL OF MY TRAVEL PLANS.',
                          leftPadding: 10.w,
                          AggressorButtonColor: AggressorColors.aero,
                          AggressorTextColor: AggressorColors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
