import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/model/tripInsuranceModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/confirmation.dart';
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

class TripInsurance extends StatefulWidget {
  TripInsurance(
      {required this.charterID, required this.reservationID, this.user});
  final String charterID;
  final String reservationID;
  final User? user;

  @override
  State<TripInsurance> createState() => _TripInsuranceState();
}

List<MasterModel> TripInsuranceOptionList = [
  MasterModel(id: 0, title: " I have purchased Trip Insurance"),
  MasterModel(
      id: 1,
      title:
          " I hereby decline the opportunity to purchase Trip Insurance and personally accept financial responsibility for any incidents that may cause my trip to be cancelled or not completed in its entirety."),
];
List<MasterModel> insuranceCompanyList = [
  MasterModel(id: 0, title: "DAN", abbv: 'DAN'),
  MasterModel(id: 1, title: "Dive Assure", abbv: 'dive_assure'),
  MasterModel(id: 2, title: "Others", abbv: 'others'),
];
MasterModel? selectedInsuranceCompany;
MasterModel? selectedTripInsuranceOption = MasterModel(id: -1);
AggressorApi aggressorApi = AggressorApi();
DateTime? policyExpirationDate;

TextEditingController policyNumberController = TextEditingController();
TextEditingController othersController = TextEditingController();
TextEditingController policyExpirationDateController = TextEditingController();

bool isLoading = true;
bool isDataPosting = false;
bool isAbsorbing = form_status.insurance == "1" || form_status.insurance == "2";

Future<void> launchUrlSite({required String url}) async {
  final Uri urlParsed = Uri.parse(url);
  if (await canLaunchUrl(urlParsed)) {
    await launchUrl(urlParsed);
  } else {
    throw 'Could not launch $url';
  }
}

class _TripInsuranceState extends State<TripInsurance> {
  tripInsuranceSubOptions() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25),
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
              validator: (value) =>
                  policyNumberController.text.isNotEmpty ? null : " ",
              labelText: "Policy Number",
              controller: policyNumberController),
        ),
        if (selectedInsuranceCompany?.id == 2)
          Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h),
            child: AdventureFormField(
                validator: (value) =>
                    othersController.text.isNotEmpty ? null : " ",
                labelText: "Company Name",
                controller: othersController),
          ),
        Padding(
          padding: EdgeInsets.only(top: 15.h, right: 25.w, left: 25.w),
          child: AdventureFormField(
              onTap: () => _selectPolicyPurchaseDate(context),
              readOnly: true,
              validator: (value) =>
                  policyExpirationDateController.text.isNotEmpty ? null : " ",
              labelText: policyExpirationDate != null
                  ? Utils.getFormattedDate(date: policyExpirationDate!)
                  : "Policy Expiration Date",
              controller: policyExpirationDateController),
        ),
      ],
    );
  }

  Future<void> _selectPolicyPurchaseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: policyExpirationDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != policyExpirationDate) {
      setState(() {
        policyExpirationDate = picked;
        policyExpirationDateController.text =
            Utils.getFormattedDate(date: policyExpirationDate!);
      });
    }
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  getInitialData() async {
    setState(() {
      isLoading = true;
    });
    await getTripDetails();
    await formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    setState(() {
      isLoading = false;
    });
  }

  getTripDetails() async {
    TripInsuranceModel? tripInsuranceModel =
        await aggressorApi.getTripInsuranceDetails();
    if (tripInsuranceModel != null) {
      setState(() {
        selectedTripInsuranceOption = tripInsuranceModel.trip_insurance!
            ? TripInsuranceOptionList[0]
            : TripInsuranceOptionList[1];
        policyExpirationDate = tripInsuranceModel.trip_insurance_date;
        if (policyExpirationDate != null) {
          policyExpirationDateController.text =
              Utils.getFormattedDate(date: policyExpirationDate!);
        }
        if (tripInsuranceModel.trip_insurance_other != null) {
          othersController.text = tripInsuranceModel.trip_insurance_other!;
        }
        if (tripInsuranceModel.trip_insurance_number != null) {
          policyNumberController.text =
              tripInsuranceModel.trip_insurance_number!;
        }

        if (tripInsuranceModel.trip_insurance_co != null) {
          selectedInsuranceCompany = insuranceCompanyList.firstWhere(
              (element) =>
                  element.abbv == tripInsuranceModel.trip_insurance_co);
        }
      });
    }
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 13),
                      child: Text(
                        "Online Application And Waiver Form - Trip Insurance.",
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
                      padding:
                          EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                      child: Text(
                        "Aggressor Adventures strongly recommends that each guest purchase comprehensive dive, accident, medical, baggage, trip cancellation and interruption insurance (cancel for any reason policy).",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
                      child: Text(
                        "Please research and understand the details of the policies you purchase. It is important you understand the coverages your policy offers and any limitations that may exist on claims made.",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                          itemCount: TripInsuranceOptionList.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTileTheme(
                              data: ListTileThemeData(
                                  titleAlignment: ListTileTitleAlignment.top),
                              child: RadioListTile<MasterModel>(
                                title: Text(
                                  TripInsuranceOptionList[index].title!,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                value: TripInsuranceOptionList[index],
                                selected: selectedTripInsuranceOption!.title ==
                                    TripInsuranceOptionList[index].title,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTripInsuranceOption = value;
                                  });
                                },
                                groupValue: selectedTripInsuranceOption,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    selectedTripInsuranceOption!.id == 0
                        ? tripInsuranceSubOptions()
                        : SizedBox(),
                    Padding(
                      padding: EdgeInsets.only(top: 25.h),
                      child: GestureDetector(
                          onTap: () {
                            launchUrlSite(
                                url:
                                    "https://www.aggressor.com/pages/insurance");
                          },
                          child: Align(
                              child: Image.asset(
                                  'assets/AggressorDiveAssure.jpg'))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 25.h, left: 10.w, right: 10.w, bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: isDataPosting
                            ? [CircularProgressIndicator()]
                            : [
                                AggressorButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  buttonName: "CANCEL",
                                  fontSize: 12,
                                  width: 70.w,
                                  AggressorButtonColor:
                                      AggressorColors.chromeYellow,
                                  AggressorTextColor: AggressorColors.white,
                                ),
                                SizedBox(width: 25.w),
                                AggressorButton(
                                    onPressed: () async {
                                      setState(() {
                                        isDataPosting = true;
                                      });
                                      TripInsuranceModel tripData =
                                          TripInsuranceModel(
                                              trip_insurance:
                                                  selectedTripInsuranceOption!
                                                              .id ==
                                                          0
                                                      ? true
                                                      : false);

                                      if (selectedTripInsuranceOption!.id ==
                                          0) {
                                        tripData.trip_insurance_co =
                                            selectedInsuranceCompany!.abbv;
                                        tripData.trip_insurance_number =
                                            policyNumberController.text;
                                        tripData.trip_insurance_date =
                                            policyExpirationDate;
                                      }
                                      if (selectedInsuranceCompany?.id == 2 ||
                                          othersController.text.isNotEmpty) {
                                        tripData.trip_insurance_other =
                                            othersController.text;
                                      }
                                      bool isDataPosted = await AggressorApi()
                                          .postTripInsuranceDetails(
                                              insuranceData: tripData);
                                      setState(() {
                                        isDataPosting = false;
                                      });
                                      if (isDataPosted) {
                                        await AggressorApi().updatingStatus(
                                            charID: widget.charterID,
                                            contactID:
                                                basicInfoModel.contactID!,
                                            column: "insurance");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Confirmation(
                                                      charterID:
                                                          widget.charterID,
                                                      reservationID:
                                                          widget.reservationID,
                                                    )));
                                      }
                                    },
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
