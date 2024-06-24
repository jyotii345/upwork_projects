import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/model/basicInfoModel.dart';
import 'package:aggressor_adventures/model/rentalModel.dart';
import 'package:aggressor_adventures/model/tripInsuranceModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../classes/aggressor_colors.dart';
import '../../../classes/globals.dart';
import '../../../classes/globals_user_interface.dart';
import '../../../classes/user.dart';
import '../../../classes/utils.dart';
import '../../../model/divingInsurance.dart';
import '../../../model/travelInformationModel.dart';
import '../../main_page.dart';
import '../model/masterModel.dart';
import '../widgets/aggressor_button.dart';
import '../widgets/dropDown.dart';
import '../widgets/text_field.dart';
import 'rental_and_courses.dart';

class Confirmation extends StatefulWidget {
  Confirmation(
      {required this.charterID, required this.reservationID, this.user});
  final String charterID;
  final String reservationID;
  final User? user;

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

String? userCountry;
String? UserCitizenship;
String? userState;
AggressorApi aggressorApi = AggressorApi();
List<String> rentalsList = [];
List<String> coursesList = [];
bool isLoading = true;
bool isUpdatingStatus = false;
DivingInsuranceModel? divingInsuranceModel;
TripInsuranceModel? tripInsuranceModel;
List<TravelInformationModel> inboundFlightsList = [];
List<TravelInformationModel> outboundFlightsList = [];
RentalModel rentalModel = RentalModel();
bool isAbsorbing =
    form_status.confirmation == "1" || form_status.confirmation == "2";
Future<void> launchUrlSite({required String url}) async {
  final Uri urlParsed = Uri.parse(url);

  if (await canLaunchUrl(urlParsed)) {
    await launchUrl(urlParsed);
  } else {
    throw 'Could not launch $url';
  }
}

getUserAddress() {
  if (basicInfoModel.country != null) {
    MasterModel selectedCountry = listOfCountries
        .firstWhere((element) => element.id == basicInfoModel.country);
    userCountry = selectedCountry.title;
  }
  if (basicInfoModel.state != null && basicInfoModel.state!.isNotEmpty) {
    MasterModel selectedState = listOfStates
        .firstWhere((element) => element.abbv == basicInfoModel.state);
    userState = selectedState.title;
  }
  if (basicInfoModel.nationalityCountryID != null) {
    MasterModel selectedCountry = listOfCountries.firstWhere(
        (element) => element.id == basicInfoModel.nationalityCountryID);
    UserCitizenship = selectedCountry.title;
  }
}

addCheckedRentals(
    {required List<MasterModel> rentalsList,
    required List<String> listOfString}) {
  for (var rental in rentalsList) {
    if (rental.isChecked) {
      listOfString.add(rental.title!);
      if (rental.subCategories != null) {
        for (var subRental in rental.subCategories!) {
          if (subRental.isChecked) {
            listOfString.add(subRental.title!);
          }
        }
      }
    }
  }
}

getRentalsInfo() async {
  rentalModel = await aggressorApi.getRentalAndCoursesDetails();
  rentalsList.clear();
  coursesList.clear();
  if (rentalModel.coursesList != null) {
    addCheckedRentals(
        rentalsList: rentalModel.coursesList!, listOfString: coursesList);
  }
  if (rentalModel.rentalsList != null) {
    addCheckedRentals(
        rentalsList: rentalModel.rentalsList!, listOfString: rentalsList);
  }
}

getDivingInsuranceDetails() async {
  divingInsuranceModel = await aggressorApi.getDivingInsuranceDetails();
}

getTripInsuranceDetails() async {
  tripInsuranceModel = await aggressorApi.getTripInsuranceDetails();
}

getTravelInformation() async {
  List<TravelInformationModel> travelInformationList =
      await aggressorApi.getTravelInformation();

  inboundFlightsList.clear();
  outboundFlightsList.clear();

  for (var travelInfo in travelInformationList) {
    if (travelInfo.flightType == 'INBOUND') {
      inboundFlightsList.add(travelInfo);
    } else {
      outboundFlightsList.add(travelInfo);
    }
  }
}

formStatus({required String contactId, required String charterId}) async {
  await aggressorApi.getFormStatus(charterId: charterId, contactId: contactId);
}

class _ConfirmationState extends State<Confirmation> {
  getInitialData() async {
    setState(() {
      isLoading = true;
    });
    await getUserAddress();
    await formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    await getRentalsInfo();
    await getDivingInsuranceDetails();
    await getTripInsuranceDetails();
    await getTravelInformation();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    infoContainer({required String title, String? data}) {
      return data != null
          ? Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox();
    }

    return Scaffold(
      drawer: getGISAppDrawer(
          charterID: widget.charterID, reservationID: widget.reservationID),
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
          padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: AbsorbPointer(
                absorbing: isAbsorbing,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 13),
                      child: Text(
                        "Online Application And Waiver Form - Confirmation.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 1.0,
                                color: Colors.grey)
                          ],
                          borderRadius: BorderRadius.circular(12.r)),
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "General Contact Inforamtion.",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          infoContainer(
                              title: "Title", data: basicInfoModel.title),
                          infoContainer(
                              title: "First Name",
                              data: basicInfoModel.firstName),
                          infoContainer(
                              title: "Middle Name",
                              data: basicInfoModel.middleName),
                          infoContainer(
                              title: "Last Name",
                              data: basicInfoModel.lastName),
                          if (basicInfoModel.dob != null)
                            infoContainer(
                                title: "Date of Birth",
                                data: Utils.getFormattedDate(
                                    date: basicInfoModel.dob!)),
                          infoContainer(
                              title: "Address", data: basicInfoModel.address1),
                          infoContainer(
                              title: "Apt/Building",
                              data: basicInfoModel.address2),
                          infoContainer(title: "Country", data: userCountry),
                          infoContainer(
                              title: "Occupation",
                              data: basicInfoModel.occupation),
                          infoContainer(
                              title: "Mobile Phone",
                              data: basicInfoModel.phone1),
                          infoContainer(
                              title: "Home Phone", data: basicInfoModel.phone2),
                          infoContainer(
                              title: "Work Phone", data: basicInfoModel.phone3),
                          infoContainer(
                              title: "Email", data: basicInfoModel.email),
                          infoContainer(
                              title: "Gender", data: basicInfoModel.gender),
                          infoContainer(
                              title: "City", data: basicInfoModel.city),
                          infoContainer(
                              title: "Province", data: basicInfoModel.province),
                          infoContainer(title: "Zip", data: basicInfoModel.zip),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 1.0,
                                color: Colors.grey)
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Passport / Visa Information",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          infoContainer(
                              title: "Citizenship:", data: UserCitizenship),
                          infoContainer(
                              title: "Passport #:",
                              data: basicInfoModel.passportNumber!),
                          infoContainer(
                              title: "Expiration Date:",
                              data: Utils.getFormattedDate(
                                  date: basicInfoModel.passportExpiration!)),
                          // Padding(
                          //   padding: EdgeInsets.only(top: 10.h),
                          //   child: GestureDetector(
                          //     onTap: () async {
                          //       await launchUrl(
                          //           Uri.parse(
                          //               'https://www.aggressor.com/passport/passport.php?l=${welcomePageDetails.destination}&y=${welcomePageDetails.startDate!.year}&m=${welcomePageDetails.startDate!.month}${DateFormat('MMM').format(DateTime(0, welcomePageDetails.startDate!.month))}&d=${welcomePageDetails.startDate!.day}&p=${basicInfoModel.contactID}&n=${basicInfoModel.firstName}_${basicInfoModel.lastName}'),
                          //           mode: LaunchMode.externalApplication);
                          //     },
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Icon(
                          //           Icons.drive_folder_upload_outlined,
                          //           size: 30.h,
                          //         ),
                          //         SizedBox(width: 12.w),
                          //         Expanded(
                          //           child: Text(
                          //               'Your destination requires an image of your passport, please tap here to upload.'),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 1.0,
                                color: Colors.grey)
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rentals",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    if (rentalsList.isNotEmpty)
                                      ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h),
                                          itemBuilder: (context, index) {
                                            return Utils.getBulletPointText(
                                              text: rentalsList[index],
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 10.h);
                                          },
                                          itemCount: rentalsList.length),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Courses",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    if (coursesList.isNotEmpty)
                                      ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h),
                                          itemBuilder: (context, index) {
                                            return Utils.getBulletPointText(
                                              text: coursesList[index],
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 10.h);
                                          },
                                          itemCount: coursesList.length)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (rentalModel.others != null)
                            Padding(
                              padding: EdgeInsets.only(top: 12.h),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Others",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      rentalModel.others!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (divingInsuranceModel != null)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 15.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 15.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 1.0,
                                  color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Diving Certificate Information",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                infoContainer(
                                    title: "Certification Level",
                                    data: divingInsuranceModel!
                                        .certification_level),
                                if (divingInsuranceModel!.certificationDate !=
                                    null)
                                  infoContainer(
                                      title: "Certification Date",
                                      data: Utils.getFormattedDate(
                                          date: divingInsuranceModel!
                                              .certificationDate!)),
                                infoContainer(
                                    title: "Certification Agency",
                                    data: divingInsuranceModel!
                                        .certification_agency),
                                infoContainer(
                                    title: "Certification Number",
                                    data: divingInsuranceModel!
                                        .certification_number),
                              ],
                            ),
                            if (tripInsuranceModel != null)
                              Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nitrox Certificate Information",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    infoContainer(
                                        title: "Certification Agency",
                                        data: divingInsuranceModel!
                                            .nitrox_agency),
                                    infoContainer(
                                        title: "Certification Number",
                                        data: divingInsuranceModel!
                                            .nitrox_number),
                                    if (divingInsuranceModel!.nitrox_date !=
                                        null)
                                      infoContainer(
                                          title: "Certification Date",
                                          data: Utils.getFormattedDate(
                                              date: divingInsuranceModel!
                                                  .nitrox_date!)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 1.0,
                                color: Colors.grey)
                          ],
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (divingInsuranceModel!.dive_insurance!)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dive Insurance Information",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                infoContainer(
                                    title: "Insurance Co",
                                    data:
                                        divingInsuranceModel!
                                                    .dive_insurance_co ==
                                                'other'
                                            ? divingInsuranceModel!
                                                .dive_insurance_other
                                            : divingInsuranceModel!
                                                .dive_insurance_co),
                                infoContainer(
                                    title: "Policy Number",
                                    data: divingInsuranceModel!
                                        .dive_insurance_number),
                                if (divingInsuranceModel!.dive_insurance_date !=
                                    null)
                                  infoContainer(
                                      title: "Valid Until",
                                      data: Utils.getFormattedDate(
                                          date: divingInsuranceModel!
                                              .dive_insurance_date!)),
                              ],
                            ),
                          if (tripInsuranceModel != null)
                            Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Trip Insurance Information",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  infoContainer(
                                      title: "Insurance Company",
                                      data:
                                          tripInsuranceModel!
                                                      .trip_insurance_co ==
                                                  'other'
                                              ? tripInsuranceModel!
                                                  .trip_insurance_other
                                              : tripInsuranceModel!
                                                  .trip_insurance_co),
                                  infoContainer(
                                      title: "Policy Number",
                                      data: tripInsuranceModel!
                                          .trip_insurance_number),
                                  if (tripInsuranceModel!.trip_insurance_date !=
                                      null)
                                    infoContainer(
                                        title: "Date Issued",
                                        data: Utils.getFormattedDate(
                                            date: tripInsuranceModel!
                                                .trip_insurance_date!)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (inboundFlightsList.isNotEmpty ||
                        outboundFlightsList.isNotEmpty)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 15.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 15.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 1.0,
                                  color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (inboundFlightsList.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: Text(
                                      "Arrival Information",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(bottom: 20.h),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 1.0,
                                                  color: Colors.grey)
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              infoContainer(
                                                  title: "Airport",
                                                  data:
                                                      inboundFlightsList[index]
                                                          .airport),
                                              infoContainer(
                                                  title: "Airline",
                                                  data:
                                                      inboundFlightsList[index]
                                                          .airline),
                                              infoContainer(
                                                  title: "Flight",
                                                  data:
                                                      inboundFlightsList[index]
                                                          .flightNum),
                                              if (inboundFlightsList[index]
                                                      .flightDate !=
                                                  null)
                                                infoContainer(
                                                    title: "Arrival Date",
                                                    data: Utils
                                                        .getFormattedDateWithTime(
                                                            date: inboundFlightsList[
                                                                    index]
                                                                .flightDate!)),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 10.h);
                                      },
                                      itemCount: inboundFlightsList.length),
                                ],
                              ),
                            if (outboundFlightsList.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Departure Information",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1.0,
                                                  color: Colors.grey)
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              infoContainer(
                                                  title: "Airport",
                                                  data:
                                                      outboundFlightsList[index]
                                                          .airport),
                                              infoContainer(
                                                  title: "Airline",
                                                  data:
                                                      outboundFlightsList[index]
                                                          .airline),
                                              infoContainer(
                                                  title: "Flight",
                                                  data:
                                                      outboundFlightsList[index]
                                                          .flightNum),
                                              if (outboundFlightsList[index]
                                                      .flightDate !=
                                                  null)
                                                infoContainer(
                                                    title: "Departure Date",
                                                    data: Utils
                                                        .getFormattedDateWithTime(
                                                            date: outboundFlightsList[
                                                                    index]
                                                                .flightDate!)),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 10.h);
                                      },
                                      itemCount: outboundFlightsList.length),
                                ],
                              ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 25.h, left: 10.w, right: 10.w, bottom: 25.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: isUpdatingStatus
                            ? [CircularProgressIndicator()]
                            : [
                                Expanded(
                                  child: AggressorButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    buttonName: "CANCEL",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    AggressorButtonColor:
                                        AggressorColors.chromeYellow,
                                    AggressorTextColor: AggressorColors.white,
                                  ),
                                ),
                                SizedBox(width: 25.w),
                                Expanded(
                                  child: AggressorButton(
                                      onPressed: isAbsorbing
                                          ? null
                                          : () async {
                                              setState(() {
                                                isUpdatingStatus = true;
                                              });
                                              bool isStatusUpdated =
                                                  await AggressorApi()
                                                      .updatingStatus(
                                                          charID:
                                                              widget.charterID,
                                                          contactID:
                                                              basicInfoModel
                                                                  .contactID!,
                                                          column:
                                                              "confirmation");
                                              setState(() {
                                                isUpdatingStatus = false;
                                              });

                                              if (isStatusUpdated) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyHomePage()),
                                                );
                                              }
                                            },
                                      buttonName: "SAVE AND CONTINUE",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      AggressorButtonColor: AggressorColors.aero
                                          .withOpacity(isAbsorbing ? 0.7 : 1),
                                      AggressorTextColor:
                                          AggressorColors.white),
                                ),
                              ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
