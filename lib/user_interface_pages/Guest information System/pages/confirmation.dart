import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/model/basicInfoModel.dart';
import 'package:aggressor_adventures/model/rentalModel.dart';
import 'package:aggressor_adventures/model/tripInsuranceModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/travel_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../classes/aggressor_colors.dart';
import '../../../classes/globals.dart';
import '../../../classes/globals_user_interface.dart';
import '../../../classes/user.dart';
import '../../../classes/utils.dart';
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
  RentalModel rentalModel = await aggressorApi.getRentalAndCoursesDetails();
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
                absorbing: form_status.confirmation == "1" ||
                        form_status.confirmation == "2"
                    ? true
                    : false,
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
                      child: Row(
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
                                      physics: NeverScrollableScrollPhysics(),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
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
                                      itemCount: rentalsList.length)
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
                                      physics: NeverScrollableScrollPhysics(),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
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
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       top: 25.h, left: 10.w, right: 10.w, bottom: 10.h),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       AggressorButton(
                    //         onPressed: () {
                    //           Navigator.pop(context);
                    //         },
                    //         buttonName: "CANCEL",
                    //         fontSize: 12,
                    //         width: 70.w,
                    //         AggressorButtonColor: AggressorColors.chromeYellow,
                    //         AggressorTextColor: AggressorColors.white,
                    //       ),
                    //       SizedBox(width: 25.w),
                    //       AggressorButton(
                    //           onPressed: () async {},
                    //           buttonName: "SAVE AND CONTINUE",
                    //           fontSize: 12,
                    //           width: 150,
                    //           AggressorButtonColor: Color(0xff57ddda),
                    //           AggressorTextColor: AggressorColors.white),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
    );
  }
}
