import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/utils.dart';
import 'package:aggressor_adventures/model/welcomePageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../classes/aggressor_colors.dart';
import '../../classes/user.dart';
import 'widgets/text_field.dart';

class GuestInformationWelcomePage extends StatefulWidget {
  GuestInformationWelcomePage(
      {required this.currentTrip,
      required this.reservationID,
      this.user,
      required this.contactId});
  final String currentTrip;
  final String reservationID;
  final String contactId;
  User? user;
  @override
  State<GuestInformationWelcomePage> createState() =>
      _GuestInformationWelcomePageState();
}

class _GuestInformationWelcomePageState
    extends State<GuestInformationWelcomePage> {
  AggressorApi aggressorApi = AggressorApi();
  List<String> paymentPoints = [
    "Payments may be made online by using Visa or MasterCard.",
    "You may enter the system as often as you like using your personalized URL (GIS link).",
    "All sections except 'Travel' must be completed to confirm your reservation. You may log back in another time to complete your travel details.",
    "Once you check a section as complete and save the page, it will change to a checked circle and will not allow you to return to that page.",
    "The above ‘Know Before You Go document’ contains the most up-to-date information regarding logistics for your upcoming adventure. A few days before departure be sure to download and check the document again so you are aware of any changes and updates."
  ];
  bool isLoading = true;
  @override
  void initState() {
    formStatus(contactId: widget.contactId, charterId: widget.currentTrip);
    getInfo(
        contactId: widget.contactId,
        charterId: widget.currentTrip,
        reservationId: widget.reservationID);
    super.initState();
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: widget.currentTrip, contactId: widget.contactId);
  }

  getInfo(
      {required String contactId,
      required String charterId,
      required String reservationId}) async {
    setState(() {
      isLoading = true;
    });
    await aggressorApi.getWelcomePageInfo(
        contactId: contactId,
        charterId: charterId,
        reservationId: reservationId);
    setState(() {
      isLoading = false;
    });
  }

  textBuilder({required int index}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("• "),
        Expanded(
          child: Text(paymentPoints[index]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f3ef),
      drawer: getGISAppDrawer(
          user: widget.user!,
          charterID: widget.currentTrip,
          reservationID: widget.reservationID),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xfff4f3ef),
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
      body: !isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                    child: Text(
                      "Welcome To Your Guest Information System (GIS) Portal.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25, top: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(welcomePageDetails.first!)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Row(
                                children: [
                                  Text(
                                    "Yacht",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(welcomePageDetails.destination!)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Row(
                                children: [
                                  Text(
                                    "Departure",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(Utils.getFormattedDate(
                                      date: welcomePageDetails.startDate!))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Row(
                                children: [
                                  Text(
                                    "Nights",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(welcomePageDetails.nights.toString())
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Text(
                                  "Please complete each of the sections above to be cleared for boarding or check-in starting with the Guest Information tab.",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SizedBox(
                              height: 450.h,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: paymentPoints.length,
                                itemBuilder: (context, index) {
                                  return textBuilder(index: index);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text("Thank you for choosing to travel with us.",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 10.w),
                        child: Text(
                            "For questions regarding the GIS or about a specific yacht, please email info@aggressor.com.",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
