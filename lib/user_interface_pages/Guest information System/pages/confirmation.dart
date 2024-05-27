import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/model/basicInfoModel.dart';
import 'package:aggressor_adventures/model/tripInsuranceModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/travel_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String charterID;
  String reservationID;
  User? user;

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

List<MasterModel> TripInsuranceOptionList = [
  MasterModel(id: 0, title: " I have purchased Trip Insurance"),
  MasterModel(
      id: 1,
      title:
          " I hereby decline the opportunity to purchase Trip Insurance and personally accept financial responsibility for any incidents that may cause my trip to be cancelled or not completed in its entirety."),
];
List<MasterModel> insuranceCompanyList = [
  MasterModel(id: 0, title: "DAN"),
  MasterModel(id: 1, title: "Dive Insurance"),
  MasterModel(id: 2, title: "Others"),
];
MasterModel? selectedInsuranceCompany;
MasterModel? selectedTripInsuranceOption = MasterModel(id: -1);
AggressorApi aggressorApi = AggressorApi();
DateTime? policyExpirationDate;
DateTime? policyDate;
RentalAndCourses? rentalList;

TextEditingController policyNumberController = TextEditingController();
TextEditingController driveEquipmentPolicyNumberController =
    TextEditingController();
TextEditingController nitroxDateController = TextEditingController();
TextEditingController othersController = TextEditingController();
TextEditingController policyExpirationDateController = TextEditingController();

List<MasterModel> listOfUserBasicInfo = [];
Future<void> launchUrlSite({required String url}) async {
  final Uri urlParsed = Uri.parse(url);

  if (await canLaunchUrl(urlParsed)) {
    await launchUrl(urlParsed);
  } else {
    throw 'Could not launch $url';
  }
}

infoContainer({required String title, required String data}) {
  return Padding(
    padding: EdgeInsets.only(top: 10.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Container(
            width: 100.w,
            child: Text(
              "$title",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(
          width: 30.w,
        ),
        Text(
          "$data",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class _ConfirmationState extends State<Confirmation> {
  @override
  void initState() {
    formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    super.initState();
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getGISAppDrawer(
          charterID: widget.charterID, reservationID: widget.reservationID!),
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
      body: SingleChildScrollView(
        child: AbsorbPointer(
          absorbing:
              form_status.confirmation == "1" || form_status.confirmation == "2"
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
              Padding(
                padding: EdgeInsets.only(top: 20.h, right: 12.w),
                child: Container(
                  height: 650.h,
                  width: 350.w,
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
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                        child: Text(
                          "General Contact Inforamtion.",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                      infoContainer(
                          title: "Title", data: basicInfoModel.title!),
                      infoContainer(
                          title: "First Name", data: basicInfoModel.firstName!),
                      infoContainer(
                          title: "Middle Name",
                          data: basicInfoModel.middleName!),
                      infoContainer(
                          title: "Last Name", data: basicInfoModel.lastName!),
                      infoContainer(
                          title: "Date of Birth",
                          data: Utils.getFormattedDate(
                              date: basicInfoModel.dob!)),
                      infoContainer(
                          title: "Address", data: basicInfoModel.address1!),
                      infoContainer(
                          title: "Apt/Building",
                          data: basicInfoModel.address2!),
                      infoContainer(
                          title: "Country",
                          data: basicInfoModel.country!.toString()),
                      infoContainer(
                          title: "Occupation",
                          data: basicInfoModel.occupation!),
                      infoContainer(
                          title: "Home Phone", data: basicInfoModel.phone1!),
                      infoContainer(
                          title: "Work Phone", data: basicInfoModel.phone2!),
                      infoContainer(
                          title: "Email", data: basicInfoModel.phone3!),
                      infoContainer(
                          title: "Gender", data: basicInfoModel.email!),
                      infoContainer(title: "City", data: basicInfoModel.city!),
                      infoContainer(
                          title: "Province", data: basicInfoModel.province!),
                      infoContainer(title: "Zip", data: basicInfoModel.zip!),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h, right: 12.w),
                child: Container(
                  height: 200.h,
                  width: 350.w,
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
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                        child: Text(
                          "Passport / Visa Information",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                      infoContainer(
                          title: "Citizenship:",
                          data: basicInfoModel.country!.toString()),
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
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h, right: 12.w),
                child: Container(
                  height: 200.h,
                  width: 350.w,
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
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                        child: Text(
                          "Rentals",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                      // infoContainer(
                      //     title: "Citizenship:",
                      //     data:rentalList.),
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
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 25.h, left: 10.w, right: 10.w, bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AggressorButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      buttonName: "CANCEL",
                      fontSize: 12,
                      width: 70.w,
                      AggressorButtonColor: AggressorColors.chromeYellow,
                      AggressorTextColor: AggressorColors.white,
                    ),
                    SizedBox(width: 25.w),
                    AggressorButton(
                        onPressed: () async {},
                        buttonName: "SAVE AND CONTINUE",
                        fontSize: 12,
                        width: 150,
                        AggressorButtonColor: Color(0xff57ddda),
                        AggressorTextColor: AggressorColors.white),
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
