import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/classes/utils.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/model/formStatusModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/model/masterModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/emergency_contact.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/waiver.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/text_field.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/text_style.dart';
import 'package:aggressor_adventures/user_interface_pages/trips_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../classes/aggressor_colors.dart';
import '../../../model/basicInfoModel.dart';
import '../../../model/userModel.dart';
import '../../main_page.dart';
import '../model/genderModel.dart';
import '../widgets/aggressor_button.dart';
import '../widgets/dropDown.dart';
import 'package:intl/intl.dart';

import '../widgets/finalized_form.dart';

class GuestInformationPage extends StatefulWidget {
  GuestInformationPage({
    this.charID,
    this.currentTrip,
    this.reservationID,
  });
  final String? charID;
  final currentTrip;
  final String? reservationID;
  @override
  State<GuestInformationPage> createState() => _GuestInformationPageState();
}

List<MasterModel> titleList = [
  MasterModel(id: 0, title: "Mr."),
  MasterModel(id: 1, title: "Ms."),
];
List<MasterModel> genderList = [
  MasterModel(id: 0, title: "Male"),
  MasterModel(id: 1, title: "Female"),
];

String? currentCountry;
int selectedOption = 1;
bool isTravelPackageChecked = false;
bool isTCAgreed = false;
String? charID;
MasterModel? selectedCountry;
MasterModel? selectedCitizenship;
MasterModel? selectedTitle;
MasterModel? selectedGender;
MasterModel? selectedState;

UserModel saveData = UserModel();
List<MasterModel> listOfCountries = [];
List<MasterModel> listOfStates = [];
TextEditingController title = TextEditingController(text: basicInfoModel.title);
TextEditingController firstName =
    TextEditingController(text: basicInfoModel.firstName);
TextEditingController middleName =
    TextEditingController(text: basicInfoModel.middleName);
TextEditingController lastName =
    TextEditingController(text: basicInfoModel.lastName);
TextEditingController preferredName =
    TextEditingController(text: basicInfoModel.preferredName);
TextEditingController gender =
    TextEditingController(text: basicInfoModel.gender);
TextEditingController dob = TextEditingController();
TextEditingController streetAddress =
    TextEditingController(text: basicInfoModel.address1);
TextEditingController occupation =
    TextEditingController(text: basicInfoModel.occupation);
TextEditingController mobilePhone =
    TextEditingController(text: basicInfoModel.phone1);
TextEditingController homePhone =
    TextEditingController(text: basicInfoModel.phone2);
TextEditingController workPhone =
    TextEditingController(text: basicInfoModel.phone3);
TextEditingController email = TextEditingController(text: basicInfoModel.email);
TextEditingController apartment =
    TextEditingController(text: basicInfoModel.address2);
TextEditingController provience =
    TextEditingController(text: basicInfoModel.province);
TextEditingController city = TextEditingController(text: basicInfoModel.city);
TextEditingController country =
    TextEditingController(text: basicInfoModel.country.toString());
TextEditingController citizenship =
    TextEditingController(text: basicInfoModel.nationalityCountryID.toString());
TextEditingController passportNumber =
    TextEditingController(text: basicInfoModel.passportNumber);
TextEditingController passportExpiration = TextEditingController();

DateTime? selectedPassportDate;
DateTime? selectedDob;
MasterModel? selectedTitleValue;
bool isDataLoading = true;
bool isDataPosting = false;
bool isAbsorbing = false;
countryList() async {
  listOfCountries = await AggressorApi().getCountriesList();
  selectedCountry = listOfCountries.firstWhere(
    (country) => country.id == basicInfoModel.country,
    orElse: () => MasterModel(),
  );
}

statesList() async {
  listOfStates = await AggressorApi().getStatesList();
  if (basicInfoModel.state != null && basicInfoModel.state!.isNotEmpty) {
    selectedState =
        listOfStates.firstWhere((state) => state.abbv == basicInfoModel.state);
  }
}

class _GuestInformationPageState extends State<GuestInformationPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  getInitialData() async {
    setState(() {
      isDataLoading = true;
    });
    await formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.currentTrip!);
    await statesList();
    await getUserData();
    setState(() {
      isDataLoading = false;
    });
  }

  getUserData() async {
    await AggressorApi().getBasicDetails();
    await countryList();
    setState(() {
      if (basicInfoModel.gender != null && basicInfoModel.gender!.isNotEmpty) {
        selectedGender = genderList.firstWhere((gender) =>
            gender.title?.toLowerCase() ==
            basicInfoModel.gender?.toLowerCase());
      }
      // if (basicInfoModel.state != null && basicInfoModel.state!.isNotEmpty) {
      //   selectedState = listOfStates.firstWhere(
      //       (states) => states.title! == basicInfoModel.state?.toLowerCase());
      // }
      if (basicInfoModel.title != null && basicInfoModel.title!.isNotEmpty) {
        selectedTitle = titleList.firstWhere((title) =>
            title.title?.toLowerCase() == basicInfoModel.title?.toLowerCase());
      }
      if (basicInfoModel.nationalityCountryID != null) {
        selectedCitizenship = listOfCountries.firstWhere(
            (selectedNationality) =>
                selectedNationality.id! == basicInfoModel.nationalityCountryID);
      }
      if (basicInfoModel.passportExpiration != null) {
        selectedPassportDate = basicInfoModel.passportExpiration;
        passportExpiration.text =
            Utils.getFormattedDate(date: basicInfoModel.passportExpiration!);
      }
      if (basicInfoModel.dob != null) {
        selectedDob = basicInfoModel.dob;
        dob.text = Utils.getFormattedDate(date: basicInfoModel.dob!);
      }
      if (basicInfoModel.travelPackage != null) {
        isTravelPackageChecked = basicInfoModel.travelPackage!;
      }
    });
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);

    if (form_status.general == "1" || form_status.general == "2") {
      isAbsorbing = true;
    }
  }

  Future<DateTime?> _selectDate(
      {required BuildContext context, bool isForPassport = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: isForPassport ? DateTime.now() : DateTime(1950),
      lastDate: isForPassport ? DateTime(2100) : DateTime.now(),
    );
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getGISAppDrawer(
          charterID: widget.charID!, reservationID: widget.reservationID!),
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
      body: isDataLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AbsorbPointer(
                        absorbing: isAbsorbing,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 30),
                              child: Text(
                                "Online Application And Waiver Form - Guest Information.",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: Text(
                                  "General Contact Information",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0),
                              child: AdventureDropDown(
                                hintText: 'title',
                                selectedItem: selectedTitle,
                                item: titleList,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTitle = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) => firstName.text.isNotEmpty
                                    ? null
                                    : "Please provide First Name",
                                isRequired: true,
                                labelText: "First Name",
                                controller: firstName,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) => middleName.text.isNotEmpty
                                    ? null
                                    : "Please provide Middle Name",
                                isRequired: true,
                                labelText: "Middle Name",
                                controller: middleName,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) => lastName.text.isNotEmpty
                                    ? null
                                    : "Please provide Last Name",
                                labelText: "Last Name",
                                controller: lastName,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                labelText: "Preferred Name",
                                controller: preferredName,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureDropDown(
                                hintText: 'Gender',
                                selectedItem: selectedGender,
                                item: genderList,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                labelText: selectedDob != null
                                    ? Utils.getFormattedDate(date: selectedDob!)
                                    : "Date of Birth",
                                readOnly: true,
                                controller: dob,
                                onTap: () async {
                                  DateTime? selectedDate =
                                      await _selectDate(context: context);
                                  if (selectedDate != null) {
                                    setState(() {
                                      selectedDob = selectedDate;
                                      dob.text = Utils.getFormattedDate(
                                          date: selectedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                  validator: (value) =>
                                      streetAddress.text.isNotEmpty
                                          ? null
                                          : "Please provide Street Address",
                                  labelText: "Street Address",
                                  controller: streetAddress),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) => apartment.text.isNotEmpty
                                    ? null
                                    : "Please provide apartment address",
                                labelText: "Apartment/Building :",
                                controller: apartment,
                              ),
                            ),
                            if (selectedCountry?.id != 2)
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25, top: 15),
                                  child: AdventureFormField(
                                      validator: (value) =>
                                          provience.text.isNotEmpty
                                              ? null
                                              : "Please provide provience",
                                      labelText:
                                          "Province / Territory / State : ",
                                      controller: provience)),
                            if (selectedCountry?.id == 2)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 15),
                                child: AdventureDropDown(
                                  hintText: 'State',
                                  selectedItem: selectedState,
                                  item: listOfStates,
                                  validator: (value) {
                                    return selectedCountry?.id == 2
                                        ? value == null
                                            ? 'Please select a state'
                                            : null
                                        : null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      selectedState = value;
                                    });
                                  },
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) => occupation.text.isNotEmpty
                                    ? null
                                    : "Please provide occupation",
                                labelText: "Occupation :",
                                controller: occupation,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                  validator: (value) =>
                                      mobilePhone.text.isNotEmpty
                                          ? null
                                          : "Please provide mobile number",
                                  labelText: "Mobile Phone :",
                                  controller: mobilePhone
                                  // TextEditingController(text: basicInfoModel.mobilePhone),
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) => homePhone.text.isNotEmpty
                                    ? null
                                    : "Please provide home phone number",
                                labelText: "Home Phone :",
                                controller: homePhone,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) => workPhone.text.isNotEmpty
                                    ? null
                                    : "Please provide work phone number",
                                labelText: "Work Phone :",
                                controller: workPhone,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) => email.text.isNotEmpty
                                    ? null
                                    : "Please provide email address",
                                labelText: "Email : ",
                                controller: email,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) => city.text.isNotEmpty
                                    ? null
                                    : "Please provide city",
                                labelText: "City :",
                                controller: city,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 15),
                              child: AdventureDropDown(
                                hintText: 'Country',
                                selectedItem: selectedCountry,
                                item: listOfCountries,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 25.0),
                                    child: Text(
                                      "Travel Package :(duties/fees may apply)",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50.h,
                                    child: CheckboxListTile(
                                      enabled: !isAbsorbing,
                                      title: Text(
                                        "Check if you WOULD like to receive a travel gift package.",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: isTravelPackageChecked,
                                      onChanged: (newValue) {
                                        setState(() {
                                          isTravelPackageChecked = newValue!;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: Text(
                                  "Passport Information",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 15),
                              child: AdventureDropDown(
                                hintText: 'Countries',
                                selectedItem: selectedCitizenship,
                                item: listOfCountries,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCitizenship = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                validator: (value) =>
                                    passportNumber.text.isNotEmpty
                                        ? null
                                        : "Please provide passport number",
                                labelText: "Passport #:",
                                controller: passportNumber,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: AdventureFormField(
                                labelText: selectedPassportDate != null
                                    ? Utils.getFormattedDate(
                                        date: selectedPassportDate!)
                                    : "Passport Expiration",
                                readOnly: true,
                                controller: passportExpiration,
                                onTap: () async {
                                  DateTime? pickedDate = await _selectDate(
                                      context: context, isForPassport: true);
                                  if (pickedDate != null) {
                                    setState(() {
                                      selectedPassportDate = pickedDate;
                                      passportExpiration.text =
                                          Utils.getFormattedDate(
                                              date: pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            ListTileTheme(
                              data: const ListTileThemeData(
                                titleAlignment: ListTileTitleAlignment.top,
                              ),
                              child: CheckboxListTile(
                                enabled: !isAbsorbing,
                                title: Text(
                                  "I Agree. I understand my passport must be valid for at least 6 months beyond the period of my stay. It is my responsibility to ensure I have the proper passport and visa to travel into each country on my itinerary as well as the return. I understand I should check with a consulate in my country of citizenship to ensure proper passport and visa requirements are met.",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                value: isTCAgreed,
                                onChanged: (newValue) {
                                  setState(() {
                                    isTCAgreed = newValue!;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            if (isAbsorbing)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: getFinalizedFormContainer(),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 20.w),
                        child: isDataPosting
                            ? CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: AggressorButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyHomePage(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      buttonName: "CANCEL",
                                      fontSize: 12,
                                      AggressorButtonColor:
                                          AggressorColors.chromeYellow,
                                      AggressorTextColor: AggressorColors.white,
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: AggressorButton(
                                        onPressed: !isTCAgreed ||
                                                selectedDob == null ||
                                                selectedPassportDate == null ||
                                                selectedTitle == null ||
                                                selectedGender == null ||
                                                isAbsorbing
                                            ? null
                                            : () async {
                                                setState(() {
                                                  isDataPosting = true;
                                                });
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  BasicInfoModel saveData = BasicInfoModel(
                                                      title: selectedTitle!
                                                          .title!
                                                          .toLowerCase(),
                                                      firstName: firstName.text,
                                                      middleName: middleName
                                                          .text,
                                                      lastName: lastName.text,
                                                      occupation: occupation
                                                          .text,
                                                      phone1: mobilePhone.text,
                                                      phone2: homePhone.text,
                                                      phone3: workPhone.text,
                                                      state:
                                                          selectedCountry
                                                                      ?.id ==
                                                                  2
                                                              ? selectedState!
                                                                  .title
                                                              : null,
                                                      province:
                                                          selectedCountry
                                                                      ?.id !=
                                                                  2
                                                              ? provience.text
                                                              : null,
                                                      preferredName: preferredName
                                                          .text,
                                                      gender: selectedGender!
                                                          .title,
                                                      email: email.text,
                                                      dob: selectedDob,
                                                      address1:
                                                          streetAddress.text,
                                                      address2: apartment.text,
                                                      travelPackage:
                                                          isTravelPackageChecked,
                                                      city: city.text,
                                                      country:
                                                          selectedCountry!.id,
                                                      nationalityCountryID:
                                                          selectedCitizenship!
                                                              .id,
                                                      passportExpiration:
                                                          selectedPassportDate,
                                                      passportNumber:
                                                          passportNumber.text);
                                                  bool isUserDataUpdated =
                                                      await AggressorApi()
                                                          .postGuestInformation(
                                                              contactId:
                                                                  basicInfoModel
                                                                      .contactID!,
                                                              userInfo:
                                                                  saveData);

                                                  if (isUserDataUpdated) {
                                                    bool isStatusUpdated =
                                                        await AggressorApi()
                                                            .updatingStatus(
                                                                charID: widget
                                                                    .charID,
                                                                contactID:
                                                                    basicInfoModel
                                                                        .contactID!,
                                                                column:
                                                                    "general");
                                                    if (isStatusUpdated) {
                                                      appDrawerselectedIndex =
                                                          2;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Waiver(
                                                                        charterID:
                                                                            widget.charID!,
                                                                        reservationID:
                                                                            '',
                                                                      )));
                                                    }
                                                  }
                                                  setState(() {
                                                    isDataPosting = false;
                                                  });
                                                }
                                              },
                                        buttonName: "SAVE AND CONTINUE",
                                        fontSize: 12,
                                        AggressorButtonColor: AggressorColors
                                            .aero
                                            .withOpacity(!isTCAgreed ||
                                                    selectedDob == null ||
                                                    selectedPassportDate ==
                                                        null ||
                                                    selectedTitle == null ||
                                                    selectedGender == null ||
                                                    isAbsorbing
                                                ? 0.7
                                                : 1),
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
            ),
    );
  }
}
