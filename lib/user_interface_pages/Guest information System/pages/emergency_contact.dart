import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/aggressor_button.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../classes/aggressor_api.dart';
import '../../../classes/aggressor_colors.dart';
import '../../../classes/globals_user_interface.dart';
import '../../widgets/info_banner_container.dart';
import '../model/masterModel.dart';
import '../widgets/dropDown.dart';
import '../widgets/text_field.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact(
      {super.key,
      required this.charID,
      required this.currentTrip,
      required this.reservationID});
  final String charID;
  final String currentTrip;
  final String reservationID;

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
bool isMasterDataLoading = false;
final primaryFormKey = GlobalKey<FormState>();
final secondaryFormKey = GlobalKey<FormState>();

getCountriesList() async {
  listOfCountries = await aggressorApi.getCountriesList();
}

getStatesList() async {
  listOfStates = await aggressorApi.getStatesList();
}

getMasterData() async {
  isMasterDataLoading = true;
  await getCountriesList();
  await getStatesList();
  isMasterDataLoading = false;
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  void initState() {
    getMasterData();
    super.initState();
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
                      'The following information is intended for use in the unlikely event of an emergency where the guest is unable to communicate with the crew or medical personnel.',
                ),
                isMasterDataLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AggressorColors.primaryColor,
                        ),
                      )
                    : Form(
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
                                isRequired: true,
                                controller: primaryFirstNameController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  validator: (value) =>
                                      primaryLastNameController.text.isNotEmpty
                                          ? null
                                          : "Please provide last name",
                                  labelText: "Last Name",
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
                                  isRequired: true,
                                  controller: primaryHomePhoneController),
                            ),
                            AdventureFormField(
                                labelText: "Work Phone",
                                controller: primaryWorkPhoneController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  labelText: "Mobile Phone",
                                  controller: primaryMobilePhoneController),
                            ),
                            AdventureFormField(
                                labelText: "Email",
                                isRequired: true,
                                controller: primaryEmailController),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: AdventureFormField(
                                  labelText: "Address",
                                  isRequired: true,
                                  controller: primaryAddressController),
                            ),
                            AdventureFormField(
                                labelText: "Apt/Unit",
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
                                  controller: primaryCityController),
                            ),
                            AdventureFormField(
                                labelText: "Zip",
                                isRequired: true,
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
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                      AdventureFormField(
                          validator: (value) =>
                              secondaryFirstNameController.text.isNotEmpty
                                  ? null
                                  : "Please provide first name",
                          labelText: "First Name",
                          isRequired: true,
                          controller: secondaryFirstNameController),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: AdventureFormField(
                            validator: (value) =>
                                secondaryLastNameController.text.isNotEmpty
                                    ? null
                                    : "Please provide last name",
                            labelText: "Last Name",
                            isRequired: true,
                            controller: secondaryLastNameController),
                      ),
                      AdventureFormField(
                          validator: (value) =>
                              secondaryRelationshipController.text.isNotEmpty
                                  ? null
                                  : "Please provide relationship",
                          labelText: "Relationship",
                          isRequired: true,
                          controller: secondaryRelationshipController),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: AdventureFormField(
                            validator: (value) =>
                                secondaryHomePhoneController.text.isNotEmpty
                                    ? null
                                    : "Please provide home phone",
                            labelText: "Home Phone",
                            isRequired: true,
                            controller: secondaryHomePhoneController),
                      ),
                      AdventureFormField(
                          labelText: "Work Phone",
                          controller: secondaryWorkPhoneController),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: AdventureFormField(
                            labelText: "Mobile Phone",
                            controller: secondaryMobilePhoneController),
                      ),
                      AdventureFormField(
                          labelText: "Email",
                          isRequired: true,
                          controller: secondaryEmailController),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: AdventureFormField(
                            labelText: "Address",
                            isRequired: true,
                            controller: secondaryAddressController),
                      ),
                      AdventureFormField(
                          labelText: "Apt/Unit",
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
                            controller: secondaryCityController),
                      ),
                      AdventureFormField(
                          labelText: "Zip",
                          isRequired: true,
                          controller: secondaryZipController),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: AggressorButton(
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
                          buttonName: 'Save & Continue',
                          AggressorButtonColor: AggressorColors.aero,
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
