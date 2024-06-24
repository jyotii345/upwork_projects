import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/policy.dart';
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
import '../widgets/aggressor_button.dart';
import '../widgets/finalized_form.dart';

class Waiver extends StatefulWidget {
  Waiver({required this.charterID, required this.reservationID, this.user});
  final String charterID;
  final String reservationID;
  final User? user;
  @override
  State<Waiver> createState() => _WaiverState();
}

class _WaiverState extends State<Waiver> {
  WebViewController controller = WebViewController();
  AggressorApi aggressorApi = AggressorApi();
  bool isLoading = true;
  bool isWaiverPosting = false;
  bool isAbsorbing = form_status.waiver == "1" || form_status.waiver == "2";
  bool isWaiverAgreed = false;
  var tempList;
  var hostAddress;
  @override
  void initState() {
    getTripInfo();
    gettingIP();
    formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    isWaiverAgreed = isAbsorbing;
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            isLoading;
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
          Uri.parse("https://gis.aggressoradventures.com/templates/waiver"));
    super.initState();
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
  }

  gettingIP() async {
    final info = NetworkInfo();
    hostAddress = await info.getWifiIP();
    return hostAddress;
  }

  getTripInfo() async {
    tempList = await AggressorApi()
        .getReservationList(basicInfoModel.contactID!, () {});
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
      backgroundColor: Color(0xfff4f3ef),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 30),
            child: Text(
              "Online Application And Waiver Form - Waiver.",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.h, left: 25.w, right: 25.w),
            child: Text(
                'Online Application and Waiver Form - Release of Liability & Assumption of Risk',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xfff1926e))),
          ),
          // SizedBox(
          //   height: 15.h,
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left: 25.w, right: 25.w),
          //   child: Text(
          //       "Guest who fail to complete this form prior to departure *WILL BE* denied boarding",
          //       style: TextStyle(
          //           fontSize: 16.sp,
          //           fontWeight: FontWeight.w500,
          //           color: Color(0xfff1926e))),
          // ),
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              height: 350.h,
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  Visibility(
                      visible: isLoading,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
            child: isAbsorbing
                ? Padding(
                    padding:
                        EdgeInsets.only(top: 15.h, left: 25.w, right: 25.w),
                    child: getFinalizedFormContainer())
                : SizedBox(
                    height: 150.h,
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: ListTileTheme(
                        data: const ListTileThemeData(
                          titleAlignment: ListTileTitleAlignment.top,
                        ),
                        child: CheckboxListTile(
                          value: isWaiverAgreed,
                          enabled: !isAbsorbing,
                          contentPadding: EdgeInsets.only(left: 10.w),
                          controlAffinity: ListTileControlAffinity.leading,
                          visualDensity: VisualDensity(horizontal: -4),
                          onChanged: (value) {
                            setState(() {
                              isWaiverAgreed = value!;
                            });
                          },
                          title: Text(
                            'I affirm that I am the person named below on this page and that I am an adult with full legal authority to enter into this Release of Liability and Assumption of Risk agreement by myself. I agree that I have viewed and have had the opportunity to read all the terms and conditions as stated in the agreement and that I understand and accept all such terms and conditions. I agree that my checking the box presented and saving this form page will constitute my electronic signature binding me to this contract.',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0.h, left: 10.w, right: 10.w),
            child: isWaiverPosting
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AggressorButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonName: "CANCEL",
                          fontSize: 12.sp,
                          AggressorButtonColor: AggressorColors.chromeYellow,
                          AggressorTextColor: AggressorColors.white,
                        ),
                      ),
                      SizedBox(width: 25.w),
                      Expanded(
                        child: AggressorButton(
                            onPressed: isAbsorbing || !isWaiverAgreed
                                ? null
                                : () async {
                                    setState(() {
                                      isWaiverPosting = true;
                                    });
                                    bool isWaiverPosted = await AggressorApi()
                                        .postWaiverForm(
                                            contactId:
                                                basicInfoModel.contactID!,
                                            reservationID: widget.reservationID,
                                            charID: widget.charterID,
                                            ipAddress: hostAddress);
                                    // await AggressorApi().updatingStatus(
                                    //     charID: widget.charterID,
                                    //     contactID: basicInfoModel.contactID!,
                                    //     column: "waiver");
                                    setState(() {
                                      isWaiverPosting = false;
                                    });
                                    if (isWaiverPosted) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Policy(
                                                  charterID: widget.charterID,
                                                  reservationID:
                                                      widget.reservationID)));
                                    }
                                  },
                            buttonName: "SAVE AND CONTINUE",
                            fontSize: 12.sp,
                            AggressorButtonColor: AggressorColors.aero
                                .withOpacity(
                                    isAbsorbing || !isWaiverAgreed ? 0.7 : 1),
                            AggressorTextColor: AggressorColors.white),
                      ),
                      // AggressorButton(
                      //     onPressed: () async {
                      //       await AggressorApi().downloadWaiver(
                      //           contactId: basicInfoModel.contactID!,
                      //           charID: widget.charterID);
                      //     },
                      //     buttonName: "DOWNLOAD WAIVER",
                      //     fontSize: 12.sp,
                      //     width: 140.w,
                      //     AggressorButtonColor: AggressorColors.dimGrey,
                      //     AggressorTextColor: AggressorColors.white),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
