import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/confirmation.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/divingInsurance.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/emergency_contact.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/travel_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../classes/aggressor_colors.dart';
import '../../../classes/colors.dart';
import '../../../classes/globals_user_interface.dart';
import '../../../classes/trip.dart';
import '../../../classes/user.dart';
import '../../../model/rentalModel.dart';
import '../../widgets/info_banner_container.dart';
import '../model/masterModel.dart';
import '../widgets/aggressor_button.dart';

class RentalAndCourses extends StatefulWidget {
  RentalAndCourses(
      {required this.charterID, required this.reservationID, this.user});
  final String charterID;
  final String reservationID;
  final User? user;
  @override
  State<RentalAndCourses> createState() => _RentalAndCoursesState();
}

class _RentalAndCoursesState extends State<RentalAndCourses> {
  AggressorApi aggressorApi = AggressorApi();
  List<dynamic> courses = [];
  List<dynamic> rentals = [];
  String? selectedBcSize;
  List<MasterModel> coursesModel = [];
  List<MasterModel> rentalsModel = [];
  List<MasterModel> bcSizeModel = [];
  TextEditingController otherRentalsController = TextEditingController();
  bool isDataLoading = true;
  bool isDataPosting = false;
  bool isAbsorbing = form_status.rentals == "1" || form_status.rentals == "2";

  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  getInitialData() async {
    setState(() {
      isDataLoading = true;
    });
    await formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    await getRentalAndCoursesDetails();
    setState(() {
      isDataLoading = false;
    });
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  getRentalAndCoursesDetails() async {
    RentalModel rentalModelFromAPI =
        await AggressorApi().getRentalAndCoursesDetails();
    setState(() {
      coursesModel = rentalModelFromAPI.coursesList!;
      rentalsModel = rentalModelFromAPI.rentalsList!;
      otherRentalsController.text = rentalModelFromAPI.others!;
    });
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
      body: isDataLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: AbsorbPointer(
                absorbing: isAbsorbing,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 30),
                      child: Text(
                        "Online Application And Waiver Form - Rental Requests.",
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
                          const EdgeInsets.only(top: 15.0, left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            "Courses",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff51cbd5)),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {},
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
                          EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                      child: InfoBannerContainer(
                          bgColor: AggressorColors.aero,
                          infoText:
                              'Want to take a course onboard? Sign up now by checking below boxes.Courses are SSI or PADI based on Instructor Membership.'),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: coursesModel[0].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    coursesModel[0].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "Nitrox",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: coursesModel[1].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    coursesModel[1].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "PADI Advanced Open Water Diver Course",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: coursesModel[2].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    coursesModel[2].isChecked = value!;
                                    ;
                                  });
                                },
                        ),
                        Text(
                          "SSI Advanced Adventurer Course",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: coursesModel[3].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    coursesModel[3].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "Open Water Check-Out Dives",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15.0, left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            "Rentals",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff51cbd5)),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {},
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
                          EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                      child: InfoBannerContainer(
                          bgColor: AggressorColors.aero,
                          infoText:
                              'Want to rent dive equipment onboard? Check below boxes to reserve.'),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: rentalsModel[0].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    rentalsModel[0].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "Dive Computer",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: rentalsModel[1].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    rentalsModel[1].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "BC",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    if (rentalsModel[1].isChecked)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.h, left: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BC Size",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff51cbd5)),
                                ),
                                SizedBox(
                                  height: 100.h,
                                  width: double.infinity,
                                  child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 20.w,
                                              crossAxisSpacing: 20.h,
                                              mainAxisExtent: 90.w),
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CheckboxListTile(
                                          visualDensity:
                                              VisualDensity(horizontal: -4),
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(rentalsModel[1]
                                              .subCategories![index]
                                              .title!),
                                          value: rentalsModel[1]
                                              .subCategories![index]
                                              .isChecked,
                                          onChanged: isAbsorbing
                                              ? null
                                              : (value) {
                                                  MasterModel selectedValue =
                                                      rentalsModel[1]
                                                              .subCategories![
                                                          index];

                                                  setState(() {
                                                    selectedValue.isChecked =
                                                        value!;
                                                    for (var item
                                                        in rentalsModel[1]
                                                            .subCategories!) {
                                                      if (item.id !=
                                                          selectedValue.id) {
                                                        item.isChecked = false;
                                                      }
                                                    }
                                                  });
                                                },
                                        );
                                      },
                                      itemCount: rentalsModel[1]
                                          .subCategories!
                                          .length),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Checkbox(
                          value: rentalsModel[2].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    rentalsModel[2].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "Regulator",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: rentalsModel[3].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    rentalsModel[3].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "Nitrox (Unlimited)",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: rentalsModel[4].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    rentalsModel[4].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "Mask",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: rentalsModel[5].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    rentalsModel[5].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "Fins",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: rentalsModel[6].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    rentalsModel[6].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "Snorkel",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: rentalsModel[7].isChecked,
                          onChanged: isAbsorbing
                              ? null
                              : (value) {
                                  setState(() {
                                    rentalsModel[7].isChecked = value!;
                                  });
                                },
                        ),
                        Text(
                          "Dive Light",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, left: 20.w),
                      child: Text(
                        "Other",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff51cbd5)),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: otherRentalsController,
                          maxLines: 5,
                          readOnly: isAbsorbing,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15.w, top: 15.h)),
                        ),
                      ),
                    ),
                    isDataPosting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 20.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: AggressorButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    buttonName: "CANCEL",
                                    fontSize: 12,
                                    width: 70,
                                    AggressorButtonColor:
                                        AggressorColors.chromeYellow,
                                    AggressorTextColor: AggressorColors.white,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: AggressorButton(
                                      onPressed: () async {
                                        setState(() {
                                          isDataPosting = true;
                                        });
                                        rentals.clear();
                                        courses.clear();

                                        for (MasterModel courseModel
                                            in coursesModel) {
                                          if (courseModel.isChecked == true) {
                                            courses.add(courseModel.abbv!);
                                          }
                                        }
                                        for (MasterModel rentalModel
                                            in rentalsModel) {
                                          if (rentalModel.isChecked == true) {
                                            rentals.add(rentalModel.abbv!);
                                          }
                                        }

                                        if (rentalsModel[1].isChecked) {
                                          for (MasterModel bcSize
                                              in rentalsModel[1]
                                                  .subCategories!) {
                                            if (bcSize.isChecked == true) {
                                              rentals.add(bcSize.abbv!);
                                            }
                                          }
                                        }
                                        aggressorApi
                                            .postRentalAndCoursesDetails(
                                          inventoryId:
                                              inventoryDetails.inventoryId,
                                          courses: courses.join(","),
                                          rentals: rentals.join(","),
                                          otherText:
                                              otherRentalsController.text,
                                        );
                                        await AggressorApi().updatingStatus(
                                            charID: widget.charterID,
                                            contactID:
                                                basicInfoModel.contactID!,
                                            column: "rentals");
                                        setState(() {
                                          isDataPosting = false;
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DivingInsurance(
                                                      charterID:
                                                          widget.charterID,
                                                      reservationID: '',
                                                    )));
                                      },
                                      buttonName: "SAVE AND CONTINUE",
                                      fontSize: 12,
                                      width: 150,
                                      AggressorButtonColor: Color(0xff57ddda),
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
