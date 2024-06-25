import 'package:aggressor_adventures/model/emergencyContactModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/guest_information.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/rental_and_courses.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/aggressor_button.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/text_style.dart';
import 'package:aggressor_adventures/user_interface_pages/trips_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../classes/aggressor_api.dart';
import '../../../classes/aggressor_colors.dart';
import '../../../classes/globals.dart';
import '../../../classes/globals_user_interface.dart';
import '../../../classes/user.dart';
import '../../../classes/utils.dart';
import '../../main_page.dart';
import '../../widgets/info_banner_container.dart';
import '../model/AppBarModel.dart';
import '../model/masterModel.dart';
import '../widgets/dropDown.dart';
import '../widgets/finalized_form.dart';
import '../widgets/text_field.dart';

class Requests extends StatefulWidget {
  Requests({super.key, this.currentTrip, this.charID, this.reservationID});
  final String? charID;
  final String? currentTrip;
  final String? reservationID;

  @override
  State<Requests> createState() => _RequestsState();
}

final AggressorApi aggressorApi = AggressorApi();

class _RequestsState extends State<Requests> {
  bool allergyCheckbox = false;
  List<AppDrawerModel> drawersList = [];
  TextEditingController dietaryController = TextEditingController();
  bool isDataUploading = false;
  bool isDataLoading = true;
  bool isAbsorbing = form_status.requests == "1" || form_status.requests == "2";
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    setState(() {
      isDataLoading = true;
    });
    await getDietaryRestrictions();
    await formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.currentTrip!);
    allergyCheckbox = isAbsorbing;
    setState(() {
      isDataLoading = false;
    });
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  getDietaryRestrictions() async {
    String? dietaryDetails = await AggressorApi()
        .getDietaryRestrictions(contactId: basicInfoModel.contactID!);
    if (dietaryDetails != null) {
      dietaryController.text = dietaryDetails;
    }
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
              child: Column(
                children: [
                  AbsorbPointer(
                    absorbing: isAbsorbing,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 15.h),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 15),
                              child: Text(
                                "Online Application And Waiver Form - Special Requests.",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "Dietary Restrictions",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            ListTileTheme(
                              data: ListTileThemeData(
                                  titleAlignment: ListTileTitleAlignment.top),
                              child: CheckboxListTile(
                                enabled: !isAbsorbing,
                                value: allergyCheckbox,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (newValue) {
                                  setState(() {
                                    allergyCheckbox = newValue!;
                                  });
                                },
                                title: Text(
                                  "If you have a food allergy or extremely strict dietary regimen please list it below, however, it may be necessary for you to bring them food items with you. Many of the destinations Aggressor Adventures are located are unable to accommodate special diets. I understand and agree that due to the unavailability of certain foods, special dietary restrictions or food allergies may not be able to be complied with. This area is NOT for personal preference such as brand name products or other non health threatening issues.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: dietaryController,
                                maxLines: 3,
                                readOnly: isAbsorbing,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(left: 15.w, top: 10.h)),
                              ),
                            ),
                            if (isAbsorbing)
                              Padding(
                                  padding: EdgeInsets.only(top: 15.h),
                                  child: getFinalizedFormContainer()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: isDataUploading
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    onPressed: (!isAbsorbing || allergyCheckbox)
                                        ? () async {
                                            setState(() {
                                              isDataUploading = true;
                                            });
                                            bool isDietaryInformationSaved =
                                                await AggressorApi()
                                                    .savingDietaryRestrictions(
                                                        contactId:
                                                            basicInfoModel
                                                                .contactID!,
                                                        information:
                                                            dietaryController
                                                                .text);
                                            if (isDietaryInformationSaved) {
                                              bool isStatusUpdated =
                                                  await AggressorApi()
                                                      .updatingStatus(
                                                          charID: widget.charID,
                                                          contactID:
                                                              basicInfoModel
                                                                  .contactID!,
                                                          column: "requests");
                                              if (isStatusUpdated) {
                                                appDrawerselectedIndex = 6;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RentalAndCourses(
                                                              charterID: widget
                                                                  .charID!,
                                                              reservationID: '',
                                                            )));
                                              }
                                            }
                                            setState(() {
                                              isDataUploading = true;
                                            });
                                          }
                                        : null,
                                    buttonName: "SAVE AND CONTINUE",
                                    fontSize: 12,
                                    AggressorButtonColor: AggressorColors.aero
                                        .withOpacity(
                                            isAbsorbing || !allergyCheckbox
                                                ? 0.7
                                                : 1),
                                    AggressorTextColor: AggressorColors.white),
                              ),
                            ],
                          ),
                  )
                ],
              ),
            ),
    );
  }
}
