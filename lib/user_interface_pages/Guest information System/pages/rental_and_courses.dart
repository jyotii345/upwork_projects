import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/divingInsurance.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/emergency_contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../classes/aggressor_colors.dart';
import '../../../classes/colors.dart';
import '../../../classes/globals_user_interface.dart';
import '../../../classes/trip.dart';
import '../../../classes/user.dart';
import '../../widgets/info_banner_container.dart';
import '../model/masterModel.dart';
import '../widgets/aggressor_button.dart';

class RentalAndCourses extends StatefulWidget {
  RentalAndCourses(
      {required this.charterID, required this.reservationID, this.user});
  String charterID;
  String reservationID;
  User? user;
  @override
  State<RentalAndCourses> createState() => _RentalAndCoursesState();
}

class _RentalAndCoursesState extends State<RentalAndCourses> {
  AggressorApi aggressorApi = AggressorApi();
  TextEditingController textController = TextEditingController();
  List<dynamic> courses = [];
  List<dynamic> rentals = [];
  String? selectedBcSize;
  List<MasterModel> coursesModel = [
    MasterModel(id: 0, title: "Nitrox", abbv: "Nitrox", isChecked: false),
    MasterModel(
        id: 1,
        title: "PADI Advanced Open Water Diver Course",
        abbv: "Advanced Open Water",
        isChecked: false),
    MasterModel(
        id: 2,
        title: "SSI Advanced Adventurer Course",
        abbv: "Deep Diver",
        isChecked: false),
    MasterModel(
        id: 3,
        title: "Open Water Check-Out Dives",
        abbv: "O/W Check-out",
        isChecked: false),
  ];
  List<MasterModel> rentalsModel = [
    MasterModel(
        id: 0, title: "Dive Computer", abbv: "Dive Computer", isChecked: false),
    MasterModel(id: 1, title: "BC", abbv: "BC", isChecked: false),
    MasterModel(id: 2, title: "Regulator", abbv: "Regulator", isChecked: false),
    MasterModel(
        id: 3,
        title: "Nitrox(Unlimited)",
        abbv: "Nitrox(Unlimited)",
        isChecked: false),
    MasterModel(id: 4, title: "Mask", abbv: "Mask", isChecked: false),
    MasterModel(id: 5, title: "Fins", abbv: "Fins", isChecked: false),
    MasterModel(id: 6, title: "Snorkel", abbv: "Snorkel", isChecked: false),
    MasterModel(
        id: 7, title: "Dive Light", abbv: "Dive Light", isChecked: false),
    MasterModel(id: 8, title: "XS", abbv: "BC(xs)", isChecked: false),
    MasterModel(id: 9, title: "XL", abbv: "BC(xl)", isChecked: false),
    MasterModel(id: 10, title: "S", abbv: "BC(s)", isChecked: false),
    MasterModel(id: 11, title: "M", abbv: "BC(l)", isChecked: false),
    MasterModel(id: 12, title: "2XL", abbv: "BC(xl)", isChecked: false),
  ];
  List<MasterModel> bcSizeModel = [];

  @override
  void initState() {
    formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    getInventoryDetails();
    getRentalAndCoursesDetails();
    super.initState();
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  getInventoryDetails() async {
    await aggressorApi.getInventoryDetail(reservationId: widget.reservationID);
  }

  getRentalAndCoursesDetails() async {
    await AggressorApi()
        .getRentalAndCoursesDetails(inventoryId: inventoryDetails.inventoryId);
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
              padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
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
              padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
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
                  onChanged: (value) {
                    setState(() {
                      coursesModel[0].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Nitrox",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: coursesModel[1].isChecked,
                  onChanged: (value) {
                    setState(() {
                      coursesModel[1].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "PADI Advanced Open Water Diver Course",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: coursesModel[2].isChecked,
                  onChanged: (value) {
                    setState(() {
                      coursesModel[2].isChecked = value!;
                      ;
                    });
                  },
                ),
                Text(
                  "SSI Advanced Adventurer Course",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: coursesModel[3].isChecked,
                  onChanged: (value) {
                    setState(() {
                      coursesModel[3].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Open Water Check-Out Dives",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
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
              padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              child: InfoBannerContainer(
                  bgColor: AggressorColors.aero,
                  infoText:
                      'Want to rent dive equipment onboard? Check below boxes to reserve.'),
            ),
            Row(
              children: [
                Checkbox(
                  value: rentalsModel[0].isChecked,
                  onChanged: (value) {
                    setState(() {
                      rentalsModel[0].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Dive Computer",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: rentalsModel[1].isChecked,
                  onChanged: (value) {
                    setState(() {
                      rentalsModel[1].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "BC",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: rentalsModel[2].isChecked,
                  onChanged: (value) {
                    setState(() {
                      rentalsModel[2].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Regulator",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: rentalsModel[3].isChecked,
                  onChanged: (value) {
                    setState(() {
                      rentalsModel[3].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Nitrox (Unlimited)",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: rentalsModel[4].isChecked,
                  onChanged: (value) {
                    setState(() {
                      rentalsModel[4].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Mask",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: rentalsModel[5].isChecked,
                  onChanged: (value) {
                    setState(() {
                      rentalsModel[5].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Fins",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: rentalsModel[6].isChecked,
                  onChanged: (value) {
                    setState(() {
                      rentalsModel[6].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Snorkel",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: rentalsModel[7].isChecked,
                  onChanged: (value) {
                    setState(() {
                      rentalsModel[7].isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Dive Light",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            rentalsModel[1].isChecked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 20.w),
                        child: Text(
                          "BC Size",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff51cbd5)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 20.w),
                        child: Row(
                          children: [
                            Text(
                              "XS",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff51cbd5)),
                            ),
                            Checkbox(
                              value: rentalsModel[8].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  rentalsModel[8].isChecked = value!;
                                });
                              },
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "XL",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff51cbd5)),
                            ),
                            Checkbox(
                              value: rentalsModel[9].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  rentalsModel[9].isChecked = value!;
                                });
                              },
                            ),
                            Checkbox(
                              value: rentalsModel[10].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  rentalsModel[10].isChecked = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Row(
                          children: [
                            Text(
                              "S",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff51cbd5)),
                            ),
                            SizedBox(width: 40.w),
                            Checkbox(
                              value: rentalsModel[11].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  rentalsModel[11].isChecked = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Row(
                          children: [
                            Text(
                              "M",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff51cbd5)),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "2XL",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff51cbd5)),
                            ),
                            Checkbox(
                              value: rentalsModel[12].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  rentalsModel[12].isChecked = value!;
                                });
                              },
                            ),
                            Checkbox(
                              value: rentalsModel[13].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  rentalsModel[13].isChecked = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
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
              padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: textController,
                  maxLines: 5,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
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
                      onPressed: () async {
                        rentals.clear();
                        courses.clear();
                        for (MasterModel courseModel in coursesModel) {
                          if (courseModel.isChecked == true) {
                            courses.add(courseModel.abbv!);
                          }
                        }
                        for (MasterModel rentalModel in rentalsModel) {
                          if (rentalModel.isChecked == true) {
                            rentals.add(rentalModel.abbv!);
                          }
                        }
                        aggressorApi.postRentalAndCoursesDetails(
                            inventoryId: inventoryDetails.inventoryId,
                            courses: courses.join(","),
                            rentals: rentals.join(","),
                            otherText: othersController.text);
                        await AggressorApi().updatingStatus(
                            charID: widget.charterID,
                            contactID: basicInfoModel.contactID!,
                            column: "rentals");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DivingInsurance(
                                      charterID: widget.charterID!,
                                      reservationID: '',
                                    )));
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
    );
  }
}
