import 'package:aggressor_adventures/model/emergencyContactModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/requests.dart';
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
import '../../widgets/info_banner_container.dart';
import '../model/masterModel.dart';
import '../widgets/dropDown.dart';
import '../widgets/text_field.dart';

class EmergencyContact extends StatefulWidget {
  EmergencyContact(
      {super.key,
      required this.charID,
      required this.currentTrip,
      required this.reservationID,
      this.user});
  final String charID;
  final String currentTrip;
  final String reservationID;
  final User? user;

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

final AggressorApi aggressorApi = AggressorApi();
List<MasterModel> listOfCountries = [];
List<MasterModel> listOfStates = [];
MasterModel? primarySelectedCountry;
MasterModel? secondarySelectedCountry;

MasterModel? primarySelectedState;
MasterModel? secondarySelectedState;

TextEditingController primaryFirstNameController = TextEditingController();
TextEditingController primaryLastNameController = TextEditingController();
TextEditingController primaryRelationshipController = TextEditingController();
TextEditingController primaryHomePhoneController = TextEditingController();
TextEditingController primaryWorkPhoneController = TextEditingController();
TextEditingController primaryMobilePhoneController = TextEditingController();
TextEditingController primaryEmailController = TextEditingController();
TextEditingController primaryAddressController = TextEditingController();
TextEditingController primaryAptController = TextEditingController();
TextEditingController primaryCityController = TextEditingController();
TextEditingController primaryZipController = TextEditingController();

TextEditingController secondaryFirstNameController = TextEditingController();
TextEditingController secondaryLastNameController = TextEditingController();
TextEditingController secondaryRelationshipController = TextEditingController();
TextEditingController secondaryHomePhoneController = TextEditingController();
TextEditingController secondaryWorkPhoneController = TextEditingController();
TextEditingController secondaryMobilePhoneController = TextEditingController();
TextEditingController secondaryEmailController = TextEditingController();
TextEditingController secondaryAddressController = TextEditingController();
TextEditingController secondaryAptController = TextEditingController();
TextEditingController secondaryCityController = TextEditingController();
TextEditingController secondaryZipController = TextEditingController();
bool isMasterDataLoading = true;
final primaryFormKey = GlobalKey<FormState>();
final secondaryFormKey = GlobalKey<FormState>();
bool isEmrDataPosting = false;
bool isAbsorbing = form_status.emcontact == "1" || form_status.emcontact == "2";

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    setState(() {
      isMasterDataLoading = true;
    });
    await emergencyContactDetails(contactId: basicInfoModel.contactID!);
    await getCountriesList();
    await getStatesList();
    await formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.currentTrip);
    initializeData();
    setState(() {
      isMasterDataLoading = false;
    });
  }

  getCountriesList() async {
    listOfCountries = await aggressorApi.getCountriesList();
  }

  getStatesList() async {
    listOfStates = await aggressorApi.getStatesList();
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  emergencyContactDetails({required String contactId}) async {
    await aggressorApi.getEmergencyContactDetails(contactId: contactId);
  }

  initializeData() {
    primaryFirstNameController =
        TextEditingController(text: emergencyContact.emergency_first);
    primaryLastNameController =
        TextEditingController(text: emergencyContact.emergency_last);
    primaryRelationshipController =
        TextEditingController(text: emergencyContact.emergency_relationship);
    primaryHomePhoneController =
        TextEditingController(text: emergencyContact.emergency_ph_home);
    primaryWorkPhoneController =
        TextEditingController(text: emergencyContact.emergency_ph_work);
    primaryMobilePhoneController =
        TextEditingController(text: emergencyContact.emergency_ph_mobile);
    primaryEmailController =
        TextEditingController(text: emergencyContact.emergency_email);
    primaryAddressController =
        TextEditingController(text: emergencyContact.emergency_address1);
    primaryAptController =
        TextEditingController(text: emergencyContact.emergency_address2);
    primarySelectedCountry = listOfCountries.firstWhere(
        (country) => country.id == emergencyContact.emergency_countryID,
        orElse: null);
    primaryCityController =
        TextEditingController(text: emergencyContact.emergency_city);
    primaryZipController =
        TextEditingController(text: emergencyContact.emergency_zip);

    secondaryFirstNameController =
        TextEditingController(text: emergencyContact.emergency2_first);
    secondaryLastNameController =
        TextEditingController(text: emergencyContact.emergency2_last);
    secondaryRelationshipController =
        TextEditingController(text: emergencyContact.emergency2_relationship);
    secondaryHomePhoneController =
        TextEditingController(text: emergencyContact.emergency2_ph_home);
    secondaryWorkPhoneController =
        TextEditingController(text: emergencyContact.emergency2_ph_work);
    secondaryMobilePhoneController =
        TextEditingController(text: emergencyContact.emergency2_ph_mobile);
    secondaryEmailController =
        TextEditingController(text: emergencyContact.emergency2_email);
    secondaryAddressController =
        TextEditingController(text: emergencyContact.emergency2_address1);
    secondaryAptController =
        TextEditingController(text: emergencyContact.emergency2_address2);
    secondarySelectedCountry = listOfCountries.firstWhere(
        (country) => country.id == emergencyContact.emergency2_countryID,
        orElse: null);
    secondaryCityController =
        TextEditingController(text: emergencyContact.emergency2_city);
    secondaryZipController =
        TextEditingController(text: emergencyContact.emergency2_zip);
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
        child: AbsorbPointer(
          absorbing: isAbsorbing,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            child: isMasterDataLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      InfoBannerContainer(
                        bgColor: AggressorColors.aero,
                        infoText:
                            'The following information is intended for use in the unlikely event of an emergency where the guest is unable to communicate with the crew or medical personnel.',
                      ),
                      Form(
                        key: primaryFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Text(
                                "Primary Emergency Contact Information",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            AdventureFormField(
                              validator: (value) =>
                                  primaryFirstNameController.text.isNotEmpty
                                      ? null
                                      : "Please provide first name",
                              labelText: "First Name",
                              // initialValue: emergencyContact.emergency_first,
                              isRequired: true,
                              controller: primaryFirstNameController,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  validator: (value) =>
                                      primaryLastNameController.text.isNotEmpty
                                          ? null
                                          : "Please provide last name",
                                  labelText: "Last Name",
                                  // initialValue: emergencyContact.emergency_last,
                                  isRequired: true,
                                  controller: primaryLastNameController),
                            ),
                            AdventureFormField(
                                validator: (value) =>
                                    primaryRelationshipController
                                            .text.isNotEmpty
                                        ? null
                                        : "Please provide relationship",
                                labelText: "Relationship",
                                // initialValue:
                                //     emergencyContact.emergency_relationship,
                                isRequired: true,
                                controller: primaryRelationshipController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  validator: (value) =>
                                      primaryHomePhoneController.text.isNotEmpty
                                          ? null
                                          : "Please provide home phone",
                                  labelText: "Home Phone",
                                  // initialValue:
                                  //     emergencyContact.emergency_ph_home,
                                  isRequired: true,
                                  controller: primaryHomePhoneController),
                            ),
                            AdventureFormField(
                                labelText: "Work Phone",
                                // initialValue:
                                //     emergencyContact.emergency_ph_work,
                                controller: primaryWorkPhoneController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  labelText: "Mobile Phone",
                                  // initialValue:
                                  //     emergencyContact.emergency_ph_mobile,
                                  controller: primaryMobilePhoneController),
                            ),
                            AdventureFormField(
                                labelText: "Email",
                                isRequired: true,
                                // initialValue: emergencyContact.emergency_email,
                                controller: primaryEmailController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  labelText: "Address",
                                  // initialValue:
                                  //     emergencyContact.emergency_address1,
                                  isRequired: true,
                                  controller: primaryAddressController),
                            ),
                            AdventureFormField(
                                labelText: "Apt/Unit",
                                // initialValue:
                                //     emergencyContact.emergency_address2,
                                controller: primaryAptController),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: AdventureDropDown(
                                hintText: 'Country',
                                selectedItem: primarySelectedCountry,
                                item: listOfCountries,
                                onChanged: (value) {
                                  setState(() {
                                    primarySelectedCountry = value;
                                  });
                                },
                              ),
                            ),
                            if (primarySelectedCountry?.id == 2)
                              Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: AdventureDropDown(
                                  hintText: 'State',
                                  selectedItem: primarySelectedState,
                                  item: listOfStates,
                                  onChanged: (value) {
                                    setState(() {
                                      primarySelectedState = value;
                                    });
                                  },
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  labelText: "City",
                                  isRequired: true,
                                  // initialValue:
                                  //     emergencyContact.emergency_city,
                                  controller: primaryCityController),
                            ),
                            AdventureFormField(
                                labelText: "Zip",
                                isRequired: true,
                                // initialValue: emergencyContact.emergency_zip,
                                controller: primaryZipController),
                          ],
                        ),
                      ),
                      Form(
                        key: secondaryFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                              child: Text(
                                "Secondary Emergency Contact Information",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            AdventureFormField(
                                validator: (value) =>
                                    secondaryFirstNameController.text.isNotEmpty
                                        ? null
                                        : "Please provide first name",
                                labelText: "First Name",
                                // initialValue: emergencyContact.emergency2_first,
                                isRequired: true,
                                controller: secondaryFirstNameController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  validator: (value) =>
                                      secondaryLastNameController
                                              .text.isNotEmpty
                                          ? null
                                          : "Please provide last name",
                                  labelText: "Last Name",
                                  // initialValue: emergencyContact.emergency2_last,
                                  isRequired: true,
                                  controller: secondaryLastNameController),
                            ),
                            AdventureFormField(
                                validator: (value) =>
                                    secondaryRelationshipController
                                            .text.isNotEmpty
                                        ? null
                                        : "Please provide relationship",
                                labelText: "Relationship",
                                // initialValue:
                                //     emergencyContact.emergency2_relationship,
                                isRequired: true,
                                controller: secondaryRelationshipController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  validator: (value) =>
                                      secondaryHomePhoneController
                                              .text.isNotEmpty
                                          ? null
                                          : "Please provide home phone",
                                  labelText: "Home Phone",
                                  // initialValue: emergencyContact.emergency2_ph_home,
                                  isRequired: true,
                                  controller: secondaryHomePhoneController),
                            ),
                            AdventureFormField(
                                labelText: "Work Phone",
                                // initialValue: emergencyContact.emergency2_ph_work,
                                controller: secondaryWorkPhoneController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  labelText: "Mobile Phone",
                                  // initialValue:
                                  //     emergencyContact.emergency2_ph_mobile,
                                  controller: secondaryMobilePhoneController),
                            ),
                            AdventureFormField(
                                labelText: "Email",
                                isRequired: true,
                                // initialValue: emergencyContact.emergency2_email,
                                controller: secondaryEmailController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  labelText: "Address",
                                  isRequired: true,
                                  // initialValue:
                                  //     emergencyContact.emergency2_address1,
                                  controller: secondaryAddressController),
                            ),
                            AdventureFormField(
                                labelText: "Apt/Unit",
                                // initialValue: emergencyContact.emergency2_address2,
                                controller: secondaryAptController),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: AdventureDropDown(
                                hintText: 'Country',
                                selectedItem: secondarySelectedCountry,
                                item: listOfCountries,
                                onChanged: (value) {
                                  setState(() {
                                    secondarySelectedCountry = value;
                                  });
                                },
                              ),
                            ),
                            if (secondarySelectedCountry?.id == 2)
                              Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: AdventureDropDown(
                                  hintText: 'State',
                                  selectedItem: secondarySelectedState,
                                  item: listOfStates,
                                  onChanged: (value) {
                                    setState(() {
                                      secondarySelectedState = value;
                                    });
                                  },
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  labelText: "City",
                                  isRequired: true,
                                  // initialValue: emergencyContact.emergency2_city,
                                  controller: secondaryCityController),
                            ),
                            AdventureFormField(
                                labelText: "Zip",
                                isRequired: true,
                                // initialValue: emergencyContact.emergency2_zip,
                                controller: secondaryZipController),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: isEmrDataPosting
                            ? CircularProgressIndicator()
                            : Row(
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
                                        setState(() {
                                          isEmrDataPosting = true;
                                        });
                                        if (primaryFormKey.currentState!
                                                .validate() &&
                                            secondaryFormKey.currentState!
                                                .validate()) {
                                          EmergencyContactModel saveData =
                                              EmergencyContactModel(
                                            emergency2_address1:
                                                primaryAddressController.text,
                                            emergency2_city:
                                                secondaryCityController.text,
                                            emergency2_countryID:
                                                secondarySelectedCountry!.id,
                                            emergency2_email:
                                                secondaryEmailController.text,
                                            emergency2_first:
                                                primaryFirstNameController.text,
                                            emergency2_last:
                                                secondaryLastNameController
                                                    .text,
                                            emergency2_ph_home:
                                                secondaryHomePhoneController
                                                    .text,
                                            emergency2_ph_mobile:
                                                secondaryMobilePhoneController
                                                    .text,
                                            emergency2_ph_work:
                                                secondaryWorkPhoneController
                                                    .text,
                                            emergency2_relationship:
                                                secondaryRelationshipController
                                                    .text,
                                            emergency2_state:
                                                secondarySelectedCountry?.id ==
                                                        2
                                                    ? secondarySelectedState!
                                                        .abbv
                                                    : null,
                                            emergency2_zip:
                                                secondaryZipController.text,
                                            emergency_address1:
                                                primaryAddressController.text,
                                            emergency_city:
                                                primaryCityController.text,
                                            emergency_countryID:
                                                primarySelectedCountry!.id,
                                            emergency_email:
                                                primaryEmailController.text,
                                            emergency_first:
                                                primaryFirstNameController.text,
                                            emergency_last:
                                                primaryLastNameController.text,
                                            emergency_ph_home:
                                                primaryHomePhoneController.text,
                                            emergency_ph_mobile:
                                                primaryMobilePhoneController
                                                    .text,
                                            emergency_ph_work:
                                                primaryWorkPhoneController.text,
                                            emergency_relationship:
                                                primaryRelationshipController
                                                    .text,
                                            emergency_state:
                                                primarySelectedCountry?.id == 2
                                                    ? primarySelectedState!.abbv
                                                    : null,
                                            emergency_zip:
                                                primaryZipController.text,
                                          );
                                          await AggressorApi()
                                              .postEmergencyContact(
                                                  contactId:
                                                      basicInfoModel.contactID!,
                                                  userInfo: saveData);
                                          await AggressorApi().updatingStatus(
                                              charID: widget.charID,
                                              contactID:
                                                  basicInfoModel.contactID!,
                                              column: "emcontact");
                                          setState(() {
                                            isEmrDataPosting = false;
                                          });
                                        }
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Requests(
                                                      charID: widget.charID,
                                                      reservationID:
                                                          widget.reservationID,
                                                    )));
                                      },
                                      buttonName: 'Save & Continue',
                                      AggressorButtonColor: AggressorColors.aero
                                          .withOpacity(isAbsorbing ? 0.7 : 1),
                                      AggressorTextColor: AggressorColors.white,
                                      fontSize: 16.sp,
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
