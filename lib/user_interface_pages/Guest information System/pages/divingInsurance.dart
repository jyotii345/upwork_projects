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
  final String charterID;
  final String reservationID;
  final User? user;

  @override
  State<DivingInsurance> createState() => _DivingInsuranceState();
}

AggressorApi aggressorApi = AggressorApi();
final _formKey = GlobalKey<FormState>();
List<MasterModel> certificateList = [
  MasterModel(id: 0, title: "Open Water"),
  MasterModel(id: 1, title: "Advanced"),
  MasterModel(id: 2, title: "Rescue"),
  MasterModel(id: 3, title: "Divemaster"),
  MasterModel(id: 4, title: "Instructor"),
  MasterModel(id: 5, title: "Master Scuba Diver"),
  MasterModel(id: 6, title: "Non-Diver"),
  MasterModel(id: 7, title: "Master Instructor"),
  MasterModel(id: 8, title: "Staff Instructor"),
  MasterModel(id: 9, title: "Course Director"),
  MasterModel(id: 10, title: "Instructor Certifier"),
];
List<MasterModel> selectedCertificateAgencyList = [
  MasterModel(id: 0, title: "SSI"),
  MasterModel(id: 1, title: "SNSI"),
  MasterModel(id: 2, title: "SDI"),
  MasterModel(id: 3, title: "RAID"),
  MasterModel(id: 4, title: "PSS"),
  MasterModel(id: 5, title: "PSAI"),
  MasterModel(id: 6, title: "PDIC"),
  MasterModel(id: 7, title: "PADI"),
  MasterModel(id: 8, title: "NAUI"),
  MasterModel(id: 9, title: "NASE"),
  MasterModel(id: 10, title: "NADD"),
  MasterModel(id: 11, title: "IDEA"),
  MasterModel(id: 12, title: "IDA"),
  MasterModel(id: 13, title: "IANTD"),
  MasterModel(id: 14, title: "IAC"),
  MasterModel(id: 15, title: "CMAS"),
  MasterModel(id: 16, title: "BSAC"),
  MasterModel(id: 17, title: "ANDI"),
  MasterModel(id: 18, title: "ACUC"),
  MasterModel(id: 19, title: "NASDS"),
  MasterModel(id: 20, title: "TAC"),
  MasterModel(id: 21, title: "YMCA"),
  MasterModel(id: 22, title: "UTD"),
];
List<MasterModel> insuranceCompanyList = [
  MasterModel(id: 0, title: "DAN", abbv: 'DAN'),
  MasterModel(id: 1, title: "Dive Assure", abbv: 'dive_assure'),
  MasterModel(id: 2, title: "Other", abbv: 'other'),
];
List<MasterModel> selectedDiveInsuranceList = [
  MasterModel(id: 0, title: "I have purchased Dive Insurance"),
  MasterModel(id: 1, title: "I hereby decline to purchase Dive Insurance"),
];
List<MasterModel> selectedDiveEquipmentList = [
  MasterModel(id: 0, title: "I have purchased Equipment Insurance"),
  MasterModel(id: 1, title: "I hereby decline to purchase Equipment Insurance"),
];
MasterModel? selectedCertificateLevel;
MasterModel? selectedCertificateAgency;
MasterModel? selectedInsuranceCompany;
MasterModel? selectedDiveInsurance = MasterModel();
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
bool isDataLoading = true;
bool isDataPosting = false;
bool isAbsorbing = false;

Future<void> launchUrlSite({required String url}) async {
  final Uri urlParsed = Uri.parse(url);

  if (await canLaunchUrl(urlParsed)) {
    await launchUrl(urlParsed, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

class _DivingInsuranceState extends State<DivingInsurance> {
  Future<void> _selectCertificationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: certificationDate ?? DateTime.now(),
      firstDate: DateTime(1990, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != certificationDate) {
      setState(() {
        certificationDate = picked;
        certificationDateController.text = Utils.getFormattedDate(date: picked);
      });
    }
  }

  Future<void> _selectPolicyExpirationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: policyDate ?? DateTime.now(),
      firstDate: DateTime(1990, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != policyDate) {
      setState(() {
        policyDate = picked;
        policyExpirationDateController.text =
            Utils.getFormattedDate(date: picked);
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
        nitroxDateController.text = Utils.getFormattedDate(date: picked);
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
        if (selectedInsuranceCompany?.id == 2)
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
          // validator: (value) => selectedDiveEquipment!.id == 0
          //     ? driveEquipmentPolicyNumberController.text.isNotEmpty
          //         ? null
          //         : "Please enter policy number"
          //     : null,
          labelText: "Policy Number",
          controller: driveEquipmentPolicyNumberController),
    );
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  getInitialData() async {
    setState(() {
      isDataLoading = true;
    });
    await divingInsuranceDetails();
    await formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    setState(() {
      isDataLoading = false;
    });
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  divingInsuranceDetails() async {
    DivingInsuranceModel? divingInsuranceModel =
        await aggressorApi.getDivingInsuranceDetails();
    if (divingInsuranceModel != null) {
      setState(() {
        certificationDate = divingInsuranceModel.certificationDate;
        nitroxDate = divingInsuranceModel.nitrox_date;
        policyExpirationDate = divingInsuranceModel.dive_insurance_date;
        isAbsorbing = form_status.diving == "1" || form_status.diving == "2";
        if (certificationDate != null) {
          certificationDateController.text =
              Utils.getFormattedDate(date: certificationDate!);
        }
        if (nitroxDate != null) {
          nitroxDateController.text = Utils.getFormattedDate(date: nitroxDate!);
        }
        if (policyExpirationDate != null) {
          policyExpirationDateController.text =
              Utils.getFormattedDate(date: policyExpirationDate!);
        }

        if (divingInsuranceModel.dive_insurance != null) {
          selectedDiveInsurance = divingInsuranceModel.dive_insurance!
              ? selectedDiveInsuranceList[0]
              : selectedDiveInsuranceList[1];
        }
        if (divingInsuranceModel.equipment_insurance != null) {
          selectedDiveEquipment = divingInsuranceModel.equipment_insurance!
              ? selectedDiveEquipmentList[0]
              : selectedDiveEquipmentList[1];
        }

        selectedCertificateLevel = certificateList.firstWhere(
          (element) =>
              element.title == divingInsuranceModel.certification_level,
          orElse: () => MasterModel(),
        );
        selectedCertificateAgency = selectedCertificateAgencyList.firstWhere(
          (element) =>
              element.title == divingInsuranceModel.certification_agency,
          orElse: () => MasterModel(),
        );
        selectedInsuranceCompany = insuranceCompanyList.firstWhere(
          (element) => element.title == divingInsuranceModel.dive_insurance_co,
          orElse: () => MasterModel(),
        );

        if (divingInsuranceModel.certification_number != null) {
          certificationNumberController.text =
              divingInsuranceModel.certification_number!;
        }
        if (divingInsuranceModel.nitrox_agency != null) {
          nitroxAgencyController.text = divingInsuranceModel.nitrox_agency!;
        }
        if (divingInsuranceModel.nitrox_number != null) {
          nitroxNumberController.text = divingInsuranceModel.nitrox_number!;
        }
        if (divingInsuranceModel.dive_insurance_number != null) {
          policyNumberController.text =
              divingInsuranceModel.dive_insurance_number!;
        }
        if (divingInsuranceModel.equipment_policy != null) {
          driveEquipmentPolicyNumberController.text =
              divingInsuranceModel.equipment_policy!;
        }
        if (divingInsuranceModel.dive_insurance_other != null) {
          othersController.text = divingInsuranceModel.dive_insurance_other!;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: isDataLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: AbsorbPointer(
                absorbing: isAbsorbing,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 13.w),
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
                                    url:
                                        "https://www.aggressor.com/pages/insurance");
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
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, top: 15),
                        child: AdventureDropDown(
                          hintText: 'Certification Level',
                          selectedItem: selectedCertificateLevel,
                          item: certificateList,
                          validator: (selectedvalue) {
                            return selectedCertificateLevel != null
                                ? null
                                : 'Please select a certification level.';
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedCertificateLevel = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 15.h, right: 25.w, left: 25.w),
                        child: AdventureFormField(
                            onTap: () => _selectCertificationDate(context),
                            readOnly: true,
                            isRequired: true,
                            validator: (value) {
                              return certificationDateController.text.isNotEmpty
                                  ? null
                                  : 'Please select a certification date.';
                            },
                            labelText: certificationDate != null
                                ? Utils.getFormattedDate(
                                    date: certificationDate!)
                                : "Certification Date",
                            controller: certificationDateController),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
                        child: AdventureDropDown(
                          hintText: 'Certification Agency',
                          selectedItem: selectedCertificateAgency,
                          item: selectedCertificateAgencyList,
                          validator: (selectedvalue) {
                            return selectedCertificateAgency != null
                                ? null
                                : 'Please select a certification agency.';
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedCertificateAgency = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
                        child: AdventureFormField(
                            validator: (value) {
                              return certificationNumberController
                                      .text.isNotEmpty
                                  ? null
                                  : "Please enter certificate number";
                            },
                            labelText: "Certification Number",
                            isRequired: true,
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
                        padding:
                            EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
                        child: AdventureFormField(
                            // validator: (value) => nitroxAgencyController.text.isNotEmpty
                            //     ? null
                            //     : "Please enter nitrox agency",
                            labelText: "Nitrox Agency",
                            controller: nitroxAgencyController),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
                        child: AdventureFormField(
                            // validator: (value) => nitroxHashController.text.isNotEmpty
                            //     ? null
                            //     : "Please enter nitrox value",
                            labelText: "Nitrox #",
                            controller: nitroxNumberController),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
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
                        padding:
                            EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                        child: Text(
                          "Dive Insurance provides financial protection for divers in the event of a diving related accident. In the event of a dive accident, this insurance typically provides medical coverage, chamber treatment, and air evacuations. Some policies are primary, while others are secondary. Please research and understand the details of the policies you purchase.",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 120.h,
                        child: ListView.builder(
                          itemCount: selectedDiveInsuranceList.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return RadioListTile<MasterModel>(
                              title: Text(
                                selectedDiveInsuranceList[index].title!,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
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
                        padding:
                            EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                        child: Text(
                          "Various insurance policies are available to cover loss or damage to your dive equipment, photography equipment (including flooding) and personal items including electronics (laptops, tablets, phones, etc). While our crew make every effort to assists guests with equipment, accidents do happen. Whether it be the natural rocking and rolling of the yacht causing equipment to shift or the slippery nature of wet equipment causing a drop, or countless other scenarios, accidents do happen where equipment is damaged regardless of the best intentions of guests and staff. Equipment insurance protects guests from financial disappointment when these unfortunate incidents do happen.",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 120.h,
                        child: ListView.builder(
                          itemCount: selectedDiveEquipmentList.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return RadioListTile<MasterModel>(
                              title: Text(
                                selectedDiveEquipmentList[index].title!,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
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
                                url:
                                    "https://www.aggressor.com/pages/insurance");
                          },
                          child: Align(
                              child: Image.asset(
                                  'assets/AggressorDiveAssure.jpg'))),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 25.h, left: 10.w, right: 10.w, bottom: 25.h),
                        child: isDataPosting
                            ? Center(child: CircularProgressIndicator())
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: AggressorButton(
                                      onPressed: () {
                                        Navigator.pop(context);
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
                                        onPressed:
                                            // (certificationDate != null &&
                                            //         selectedCertificateLevel !=
                                            //             null &&
                                            //         selectedCertificateAgency !=
                                            //             null &&
                                            //         certificationNumberController
                                            //             .text.isNotEmpty)
                                            // ?
                                            () async {
                                          setState(() {
                                            isDataPosting = true;
                                          });
                                          if (_formKey.currentState!
                                              .validate()) {
                                            DivingInsuranceModel divingData =
                                                DivingInsuranceModel(
                                              certification_agency:
                                                  selectedCertificateAgency!
                                                      .title,
                                              certification_level:
                                                  selectedCertificateLevel!
                                                      .title,
                                              certification_number:
                                                  certificationNumberController
                                                      .text
                                                      .trim(),
                                              certificationDate:
                                                  certificationDate,
                                              nitrox_agency:
                                                  nitroxAgencyController.text
                                                      .trim(),
                                              nitrox_date: nitroxDate,
                                              nitrox_number:
                                                  nitroxNumberController.text
                                                      .trim(),
                                            );

                                            if (selectedDiveEquipment!.id ==
                                                0) {
                                              divingData.equipment_insurance =
                                                  true;
                                              if (driveEquipmentPolicyNumberController
                                                  .text.isNotEmpty) {
                                                divingData.equipment_policy =
                                                    driveEquipmentPolicyNumberController
                                                        .text
                                                        .trim();
                                              }
                                            }
                                            if (selectedDiveInsurance?.id ==
                                                0) {
                                              divingData.dive_insurance = true;
                                              divingData.dive_insurance_co =
                                                  selectedInsuranceCompany!
                                                      .abbv;
                                              divingData.dive_insurance_date =
                                                  policyDate;
                                              divingData.dive_insurance_number =
                                                  policyNumberController.text
                                                      .trim();
                                            }
                                            if (selectedInsuranceCompany?.id ==
                                                    2 &&
                                                othersController
                                                    .text.isNotEmpty) {
                                              divingData.dive_insurance_other =
                                                  othersController.text.trim();
                                            }

                                            bool isDataUpdated =
                                                await AggressorApi()
                                                    .postDivingInsuranceDetails(
                                                        divingInfo: divingData);
                                            setState(() {
                                              isDataPosting = false;
                                            });
                                            await AggressorApi().updatingStatus(
                                                charID: widget.charterID,
                                                contactID:
                                                    basicInfoModel.contactID!,
                                                column: "diving");
                                            if (isDataUpdated) {
                                              appDrawerselectedIndex = 7;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TripInsurance(
                                                            charterID: widget
                                                                .charterID,
                                                            reservationID: widget
                                                                .reservationID,
                                                          )));
                                            }
                                          }
                                        },
                                        // : null,
                                        buttonName: "SAVE AND CONTINUE",
                                        fontSize: 12,
                                        AggressorButtonColor: AggressorColors
                                            .aero
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
            ),
    );
  }
}
