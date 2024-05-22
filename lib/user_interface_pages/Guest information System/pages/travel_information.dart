import 'package:aggressor_adventures/model/emergencyContactModel.dart';
import 'package:aggressor_adventures/model/travelInformationModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/guest_information.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/aggressor_button.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/text_style.dart';
import 'package:aggressor_adventures/user_interface_pages/trips_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

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

DateTime? departureDateAndTime;
final primaryFormKey = GlobalKey<FormState>();
final secondaryFormKey = GlobalKey<FormState>();
bool isSaved = false;
final arrivalFormKey = GlobalKey<FormState>();
final departureFormKey = GlobalKey<FormState>();
TravelInformationModel arrivalInformationModel = TravelInformationModel(
  airlineController: TextEditingController(),
  flightNumberController: TextEditingController(),
  flightDateController: TextEditingController(),
  flightTypeController: TextEditingController(),
  airportController: TextEditingController(),
  formKey: arrivalFormKey,
);
TravelInformationModel departureInformationModel = TravelInformationModel(
    airlineController: TextEditingController(),
    flightNumberController: TextEditingController(),
    flightDateController: TextEditingController(),
    flightTypeController: TextEditingController(),
    airportController: TextEditingController(),
    formKey: departureFormKey);

List<TravelInformationModel> inboundFlightsList = [];
List<TravelInformationModel> outboundFlightsList = [];
List<TravelInformationModel> travelInformationList = [];
bool isLoading = true;
DateTime? arrivalDate;
DateTime? departureDate;

class _TravelInformationState extends State<TravelInformation> {
  @override
  void initState() {
    getUserTravelInformation(
        contactId: basicInfoModel.contactID!, charterId: widget.currentTrip);
    formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.currentTrip);
    super.initState();
  }

  getUserTravelInformation(
      {required String contactId, required String charterId}) async {
    setState(() {
      isLoading = true;
    });
    List<TravelInformationModel> travelInformationList = await aggressorApi
        .getTravelInformation(charterId: charterId, contactId: contactId);

    inboundFlightsList.clear();
    outboundFlightsList.clear();

    for (var travelInfo in travelInformationList) {
      if (travelInfo.flightType == 'INBOUND') {
        inboundFlightsList.add(travelInfo);
      } else {
        outboundFlightsList.add(travelInfo);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  newFlightWidget({
    bool isArrivalFlight = true,
    bool isNewFlight = false,
    required TravelInformationModel travelInformation,
  }) {
    return Container(
        width: double.infinity,
        height: isNewFlight ? 430.h : 500.h,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
                  child: Text(
                    isArrivalFlight
                        ? "ARRIVAL INFORMATION (Before your trip)"
                        : "DEPARTURE INFORMATION (After your trip)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Form(
                key: travelInformation.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: AdventureFormField(
                          validator: (value) => isNewFlight
                              ? travelInformation
                                      .airportController!.text.isNotEmpty
                                  ? null
                                  : "Please enter arrival airport"
                              : null,
                          labelText: "Arrival Airport",
                          controller: travelInformation.airportController),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: AdventureFormField(
                          validator: (value) => isNewFlight
                              ? travelInformation
                                      .flightNumberController!.text.isNotEmpty
                                  ? null
                                  : "Please enter flight number"
                              : null,
                          labelText: "Flight Number",
                          controller: travelInformation.flightNumberController),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: AdventureFormField(
                          validator: (value) => isNewFlight
                              ? travelInformation
                                      .airlineController!.text.isNotEmpty
                                  ? null
                                  : "Please enter airline number"
                              : null,
                          labelText: "Airline",
                          controller: travelInformation.airlineController),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: AdventureFormField(
                          onTap: () async {
                            DateTime? pickedDate =
                                await showArrivalDateTimePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(3000, 6, 7, 05, 09));

                            if (pickedDate != null) {
                              setState(() {
                                travelInformation.flightDate = pickedDate;
                                travelInformation.flightDateController!.text =
                                    Utils.getFormattedDateWithTime(
                                        date: pickedDate);
                              });

                              print(Utils.getFormattedDateWithTime(
                                  date: pickedDate));
                            }
                          },
                          readOnly: true,
                          validator: (value) =>
                              travelInformation.flightDate != null
                                  ? null
                                  : 'Please select a date & time.',
                          hintText: isArrivalFlight
                              ? "Arrival date & time"
                              : "Departure date & time",
                          controller: travelInformation.flightDateController),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
                child: Column(
                  children: [
                    AggressorButton(
                      onPressed: () async {
                        if (travelInformation.formKey!.currentState!
                            .validate()) {
                          if (isNewFlight) {
                            TravelInformationModel saveFlightData =
                                TravelInformationModel(
                                    airline: travelInformation
                                        .airlineController!.text,
                                    flightNum: travelInformation
                                        .flightNumberController!.text,
                                    airport: travelInformation
                                        .airportController!.text,
                                    flightDate: arrivalDate,
                                    flightType: isArrivalFlight == false
                                        ? "OUTBOUND"
                                        : "INBOUND");

                            await aggressorApi.postTravelInformation(
                              contactId: basicInfoModel.contactID!,
                              charterId: widget.currentTrip,
                              travelInfo: saveFlightData,
                            );
                            getUserTravelInformation(
                                contactId: basicInfoModel.contactID!,
                                charterId: widget.currentTrip);
                          } else {
                            TravelInformationModel updateFlightData =
                                TravelInformationModel(
                                    airline: travelInformation
                                        .airlineController!.text,
                                    flightNum: travelInformation
                                        .flightNumberController!.text,
                                    airport: travelInformation
                                        .airportController!.text,
                                    flightDate: travelInformation.flightDate,
                                    flightType: isArrivalFlight == false
                                        ? "OUTBOUND"
                                        : "INBOUND");
                            await aggressorApi.updateTravelInformation(
                              contactId: basicInfoModel.contactID!,
                              travelInfo: updateFlightData,
                            );
                            getUserTravelInformation(
                                contactId: basicInfoModel.contactID!,
                                charterId: widget.currentTrip);
                          }
                        }
                      },
                      buttonName:
                          isNewFlight ? 'SAVE NEW FLIGHT' : 'UPDATE FLIGHT',
                      AggressorButtonColor: AggressorColors.seaGreen,
                      AggressorTextColor: AggressorColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    isNewFlight == false
                        ? Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: AggressorButton(
                              onPressed: () async {
                                await aggressorApi.deleteTravelInformation(
                                    contactId: basicInfoModel.contactID!,
                                    flightId: travelInformation.flightId!);
                                getUserTravelInformation(
                                    contactId: basicInfoModel.contactID!,
                                    charterId: widget.currentTrip);
                              },
                              buttonName: 'DELETE FLIGHT',
                              AggressorButtonColor: AggressorColors.red,
                              AggressorTextColor: AggressorColors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isClosed) {
        //todo what you need for left drawer
      },
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
        child: AbsorbPointer(
          absorbing: form_status.travel == "1" || form_status.travel == "2"
              ? true
              : false,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: !isLoading
                  ? Column(
                      children: [
                        InfoBannerContainer(
                          bgColor: AggressorColors.aero,
                          infoText:
                              'Travel information does not have to be completed now to confirm your reservation, however, it will need to be completed prior to traveling. You may return to this page at any time by opening this same GIS link to complete your travel information. If transfers are not included in your yacht package, please contact your yacht specialist to confirm these arrangements.',
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        newFlightWidget(
                          isArrivalFlight: true,
                          isNewFlight: true,
                          travelInformation: arrivalInformationModel,
                        ),
                        SizedBox(
                          height: inboundFlightsList.isNotEmpty ? 450.h : 0.h,
                          child: ListView.builder(
                            itemCount: inboundFlightsList.length,
                            itemBuilder: (context, index) {
                              return newFlightWidget(
                                  isArrivalFlight: true,
                                  isNewFlight: false,
                                  travelInformation: inboundFlightsList[index]);
                            },
                          ),
                        ),
                        SizedBox(height: 25.h),
                        newFlightWidget(
                            isArrivalFlight: false,
                            isNewFlight: true,
                            travelInformation: departureInformationModel),
                        SizedBox(
                          height: 30.h,
                        ),
                        SizedBox(
                          height: outboundFlightsList.isNotEmpty ? 450.h : 10.h,
                          child: ListView.builder(
                            itemCount: outboundFlightsList.length,
                            itemBuilder: (context, index) {
                              return newFlightWidget(
                                  isArrivalFlight: false,
                                  isNewFlight: false,
                                  travelInformation:
                                      outboundFlightsList[index]);
                            },
                          ),
                        ),
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
                                  AggressorButtonColor:
                                      AggressorColors.chromeYellow,
                                  AggressorTextColor: AggressorColors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: AggressorButton(
                                  onPressed: () async {
                                    await AggressorApi().updatingStatus(
                                        charID: widget.charID,
                                        contactID: basicInfoModel.contactID!,
                                        column: "travel");
                                  },
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
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 380.h),
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<DateTime?> showArrivalDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  arrivalDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (arrivalDate == null) return null;

  if (!context.mounted) return arrivalDate;

  TimeOfDay? arrivalTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  return arrivalTime == null
      ? arrivalDate
      : DateTime(
          arrivalDate!.year,
          arrivalDate!.month,
          arrivalDate!.day,
          arrivalTime.hour,
          arrivalTime.minute,
        );
}

Future<DateTime?> showDepartureDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  departureDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (departureDate == null) return null;

  if (!context.mounted) return departureDate;

  TimeOfDay? departureTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  return departureTime == null
      ? departureDate
      : DateTime(
          departureDate!.year,
          departureDate!.month,
          departureDate!.day,
          departureTime.hour,
          departureTime.minute,
        );
}
