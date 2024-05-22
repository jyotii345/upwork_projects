import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/model/divingInsurance.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/tripInsurance.dart';
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

class DivingInsurance extends StatefulWidget {
  DivingInsurance(
      {required this.charterID, required this.reservationID, this.user});
  String charterID;
  String reservationID;
  User? user;

  @override
  State<DivingInsurance> createState() => _DivingInsuranceState();
}

AggressorApi aggressorApi = AggressorApi();
final _formKey = GlobalKey<FormState>();
List<MasterModel> certificateList = [
  MasterModel(id: 0, title: "Open Water"),
  MasterModel(id: 1, title: "Advanced"),
  MasterModel(id: 2, title: "Rescue"),
];
List<MasterModel> selectedCertificateAgencyList = [
  MasterModel(id: 0, title: "SSI"),
  MasterModel(id: 1, title: "SNSI"),
  MasterModel(id: 2, title: "SDI"),
  MasterModel(id: 3, title: "RAID"),
];
List<MasterModel> insuranceCompanyList = [
  MasterModel(id: 0, title: "DAN"),
  MasterModel(id: 1, title: "Dive Insurance"),
  MasterModel(id: 2, title: "Others"),
];
List<MasterModel> selectedDiveInsuranceList = [
  MasterModel(id: 0, title: "I have purchased Dive Insurance"),
  MasterModel(id: 1, title: "I hereby decline to purchased Dive Insurance"),
];
List<MasterModel> selectedDiveEquipmentList = [
  MasterModel(id: 0, title: "I have purchased Equipment Insurance"),
  MasterModel(
      id: 1, title: "I hereby decline to purchased Equipment Insurance"),
];
MasterModel? selectedCertificateLevel;
MasterModel? selectedCertificateAgency;
MasterModel? selectedInsuranceCompany;
MasterModel? selectedDiveInsurance = MasterModel(id: -1);
MasterModel? selectedDiveEquipment = MasterModel(id: -1);
DateTime? certificationDate;
DateTime? nitroxDate;
DateTime? policyDate;
TextEditingController certificationDateController = TextEditingController();
TextEditingController certificationNumberController = TextEditingController();
TextEditingController nitroxAgencyController = TextEditingController();
TextEditingController nitroxNumberController = TextEditingController();
TextEditingController policyNumberController = TextEditingController();
TextEditingController driveEquipmentPolicyNumberController =
    TextEditingController();
TextEditingController nitroxDateController = TextEditingController();
TextEditingController othersController = TextEditingController();
TextEditingController policyExpirationDateController = TextEditingController();

Future<void> launchUrlSite({required String url}) async {
  final Uri urlParsed = Uri.parse(url);

  if (await canLaunchUrl(urlParsed)) {
    await launchUrl(urlParsed);
  } else {
    throw 'Could not launch $url';
  }
}

class _DivingInsuranceState extends State<DivingInsurance> {
  Future<void> _selectCertificationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: certificationDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != certificationDate) {
      setState(() {
        certificationDate = picked;
      });
    }
  }

  Future<void> _selectPolicyExpirationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: policyDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != policyDate) {
      setState(() {
        policyDate = picked;
      });
    }
  }

  Future<void> _selectNitroxDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: nitroxDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != nitroxDate) {
      setState(() {
        nitroxDate = picked;
      });
    }
  }

  driveInsuranceSubOptions() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25, top: 15),
          child: AdventureDropDown(
            hintText: 'Insurance Company',
            selectedItem: selectedInsuranceCompany,
            item: insuranceCompanyList,
            onChanged: (value) {
              setState(() {
                selectedInsuranceCompany = value;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
          child: AdventureFormField(
              validator: (value) => policyNumberController.text.isNotEmpty
                  ? null
                  : "Please Enter Policy Number",
              labelText: "Policy Number",
              controller: policyNumberController),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
          child: AdventureFormField(
              validator: (value) => othersController.text.isNotEmpty
                  ? null
                  : "Please enter company name ",
              labelText: "Company Name",
              controller: othersController),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.h, right: 25.w, left: 25.w),
          child: AdventureFormField(
              onTap: () => _selectPolicyExpirationDate(context),
              readOnly: true,
              validator: (value) =>
                  policyExpirationDateController.text.isNotEmpty
                      ? null
                      : "Please select policy expiration date",
              labelText: policyDate != null
                  ? Utils.getFormattedDate(date: policyDate!)
                  : "Policy Expiration Date",
              controller: policyExpirationDateController),
        ),
      ],
    );
  }

  driveEquipmentSubOptions() {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h),
      child: AdventureFormField(
          validator: (value) =>
              driveEquipmentPolicyNumberController.text.isNotEmpty
                  ? null
                  : "Please enter policy number",
          labelText: "Policy Number",
          controller: driveEquipmentPolicyNumberController),
    );
  }

  @override
  void initState() {
    getInventoryDetails();
    formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    super.initState();
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  getInventoryDetails() async {
    await aggressorApi.getInventoryDetail(reservationId: widget.reservationID);
  }

  divingInsuranceDetails() async {
    await aggressorApi.getDivingInsuranceDetails(
        inventoryId: inventoryDetails.inventoryId!);
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
      body: SingleChildScrollView(
        child: AbsorbPointer(
          absorbing: form_status.diving == "1" || form_status.diving == "2"
              ? true
              : false,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 13),
                  child: Text(
                    "Online Application And Waiver Form - Diving Insurance.",
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
                  padding: EdgeInsets.only(left: 10.w),
                  child: Row(
                    children: [
                      Text(
                        "Diving Certification Information",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          launchUrlSite(
                              url: "https://www.aggressor.com/pages/insurance");
                        },
                        child: Text(
                          "See more",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff51cbd5)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25, top: 15),
                  child: AdventureDropDown(
                    hintText: 'Certification Level',
                    selectedItem: selectedCertificateLevel,
                    item: certificateList,
                    onChanged: (value) {
                      setState(() {
                        selectedCertificateLevel = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.h, right: 25.w, left: 25.w),
                  child: AdventureFormField(
                      onTap: () => _selectCertificationDate(context),
                      readOnly: true,
                      labelText: certificationDate != null
                          ? Utils.getFormattedDate(date: certificationDate!)
                          : "Certification date & time",
                      controller: certificationDateController),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
                  child: AdventureDropDown(
                    hintText: 'Certification Agency',
                    selectedItem: selectedCertificateAgency,
                    item: selectedCertificateAgencyList,
                    onChanged: (value) {
                      setState(() {
                        selectedCertificateAgency = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
                  child: AdventureFormField(
                      validator: (value) {
                        return certificationNumberController.text.isNotEmpty
                            ? null
                            : "Please enter certificate number";
                      },
                      labelText: "Certification Number",
                      controller: certificationNumberController),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 20.h),
                  child: Row(
                    children: [
                      Text(
                        "Nitrox Certification Information",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
                  child: AdventureFormField(
                      // validator: (value) => nitroxAgencyController.text.isNotEmpty
                      //     ? null
                      //     : "Please enter nitrox agency",
                      labelText: "Nitrox Agency",
                      controller: nitroxAgencyController),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
                  child: AdventureFormField(
                      // validator: (value) => nitroxHashController.text.isNotEmpty
                      //     ? null
                      //     : "Please enter nitrox value",
                      labelText: "Nitrox #",
                      controller: nitroxNumberController),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
                  child: AdventureFormField(
                      onTap: () => _selectNitroxDate(context),
                      readOnly: true,
                      // validator: (value) => nitroxDateController.text.isNotEmpty
                      //     ? null
                      //     : "Please select nitrox date",
                      labelText: nitroxDate != null
                          ? Utils.getFormattedDate(date: nitroxDate!)
                          : "Nitrox Date",
                      controller: nitroxDateController),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 10),
                  child: Text(
                    "Dive Insurance Information",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                  child: Text(
                    "Dive Insurance provides financial protection for divers in the event of a diving related accident. In the event of a dive accident, this insurance typically provides medical coverage, chamber treatment, and air evacuations. Some policies are primary, while others are secondary. Please research and understand the details of the policies you purchase.",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 120.h,
                  child: ListView.builder(
                    itemCount: selectedDiveInsuranceList.length,
                    itemBuilder: (context, index) {
                      return RadioListTile<MasterModel>(
                        title: Text(
                          selectedDiveInsuranceList[index].title!,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        value: selectedDiveInsuranceList[index],
                        selected: selectedDiveInsurance!.id ==
                            selectedDiveInsuranceList[index].id,
                        onChanged: (value) {
                          setState(() {
                            if (selectedDiveInsurance!.id == 0) {
                              selectedDiveInsurance!.abbv = "true";
                            } else {
                              selectedDiveInsurance!.abbv = "false";
                            }
                            selectedDiveInsurance = value;
                          });
                          print(selectedDiveInsurance!.id);
                          print(selectedDiveInsurance!.isChecked);
                        },
                        groupValue: selectedDiveInsurance,
                      );
                    },
                  ),
                ),
                selectedDiveInsurance!.id == 0
                    ? driveInsuranceSubOptions()
                    : SizedBox(),
                SizedBox(
                  height: 10.h,
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 10),
                  child: Text(
                    "Dive Equipment / Camera Insurance",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                  child: Text(
                    "Various insurance policies are available to cover loss or damage to your dive equipment, photography equipment (including flooding) and personal items including electronics (laptops, tablets, phones, etc). While our crew make every effort to assists guests with equipment, accidents do happen. Whether it be the natural rocking and rolling of the yacht causing equipment to shift or the slippery nature of wet equipment causing a drop, or countless other scenarios, accidents do happen where equipment is damaged regardless of the best intentions of guests and staff. Equipment insurance protects guests from financial disappointment when these unfortunate incidents do happen.",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 120.h,
                  child: ListView.builder(
                    itemCount: selectedDiveEquipmentList.length,
                    itemBuilder: (context, index) {
                      return RadioListTile<MasterModel>(
                        title: Text(
                          selectedDiveEquipmentList[index].title!,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        value: selectedDiveEquipmentList[index],
                        selected: selectedDiveEquipment!.id ==
                            selectedDiveEquipmentList[index].id,
                        onChanged: (value) {
                          setState(() {
                            selectedDiveEquipment = value;
                          });
                        },
                        groupValue: selectedDiveEquipment,
                      );
                    },
                  ),
                ),
                selectedDiveEquipment!.id == 0
                    ? driveEquipmentSubOptions()
                    : SizedBox(),
                SizedBox(height: 30.h),
                GestureDetector(
                    onTap: () {
                      launchUrlSite(
                          url: "https://www.aggressor.com/pages/insurance");
                    },
                    child: Align(
                        child: Image.asset('assets/AggressorDiveAssure.jpg'))),
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
                        width: 70,
                        AggressorButtonColor: AggressorColors.chromeYellow,
                        AggressorTextColor: AggressorColors.white,
                      ),
                      SizedBox(width: 25),
                      AggressorButton(
                          onPressed: (certificationDate != null &&
                                  selectedCertificateLevel != null &&
                                  selectedCertificateAgency != null)
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    DivingInsuranceModel divingData =
                                        DivingInsuranceModel(
                                            certification_agency:
                                                selectedCertificateAgency!
                                                    .title,
                                            certification_level:
                                                selectedCertificateLevel!.title,
                                            certification_number:
                                                certificationNumberController
                                                    .text,
                                            dive_insurance:
                                                selectedDiveInsurance!.abbv,
                                            dive_insurance_co:
                                                selectedInsuranceCompany!.title,
                                            dive_insurance_other:
                                                othersController.text,
                                            dive_insurance_number:
                                                policyNumberController.text,
                                            nitrox_agency:
                                                nitroxAgencyController.text,
                                            nitrox_date:
                                                Utils.getFormattedDateForBackend(
                                                    date: nitroxDate!),
                                            nitrox_number:
                                                nitroxNumberController.text,
                                            equipment_insurance:
                                                selectedDiveEquipment!.id == 0
                                                    ? "Yes"
                                                    : "No",
                                            equipment_policy:
                                                selectedDiveEquipment!.title);
                                    await AggressorApi()
                                        .postDivingInsuranceDetails(
                                            inventoryId:
                                                inventoryDetails.inventoryId,
                                            divingInfo: divingData);
                                    await AggressorApi()
                                        .getDivingInsuranceDetails(
                                            inventoryId:
                                                inventoryDetails.inventoryId!);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TripInsurance(
                                                  charterID: widget.charterID!,
                                                  reservationID: '',
                                                )));
                                  }
                                }
                              : null,
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
      ),
    );
  }
}
