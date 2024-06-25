import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/emergency_contact.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/widgets/finalized_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../classes/aggressor_colors.dart';
import '../../../classes/colors.dart';
import '../../../classes/globals_user_interface.dart';
import '../../../classes/trip.dart';
import '../../../classes/user.dart';
import '../../main_page.dart';
import '../widgets/aggressor_button.dart';

class Policy extends StatefulWidget {
  Policy({required this.charterID, required this.reservationID, this.user});
  final String charterID;
  final String reservationID;
  final User? user;
  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  WebViewController controller = WebViewController();
  bool isLoading = true;
  bool isPolicyStatusUpdating = false;
  bool isAbsorbing = form_status.policy == "1" || form_status.policy == "2";
  var hostAddress;
  @override
  void initState() {
    formStatus(
        contactId: basicInfoModel.contactID!, charterId: widget.charterID);
    super.initState();
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
          Uri.parse("https://gis.aggressoradventures.com/templates/policy"));
  }

  gettingIP() async {
    final info = NetworkInfo();
    hostAddress = await info.getWifiIP();
    return hostAddress;
  }

  formStatus({required String contactId, required String charterId}) async {
    await aggressorApi.getFormStatus(
        charterId: charterId, contactId: contactId);
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 30.w),
            child: Text(
              "Online Application And Waiver Form - Payment & Cancellation Policy.",
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
            padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.white),
              height: 450.h,
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
          if (isAbsorbing)
            Padding(
                padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
                child: getFinalizedFormContainer()),
          Padding(
            padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
            child: isPolicyStatusUpdating
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          fontSize: 12.sp,
                          width: 70.w,
                          AggressorButtonColor: AggressorColors.chromeYellow,
                          AggressorTextColor: AggressorColors.white,
                        ),
                      ),
                      SizedBox(width: 25.w),
                      Expanded(
                        child: AggressorButton(
                            onPressed: isAbsorbing
                                ? null
                                : () async {
                                    setState(() {
                                      isPolicyStatusUpdating = true;
                                    });
                                    bool isStatusUpdated = await AggressorApi()
                                        .updatingStatus(
                                            charID: widget.charterID,
                                            contactID:
                                                basicInfoModel.contactID!,
                                            column: "policy");
                                    setState(() {
                                      isPolicyStatusUpdating = false;
                                    });
                                    if (isStatusUpdated) {
                                      appDrawerselectedIndex = 4;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EmergencyContact(
                                                      charID: widget.charterID,
                                                      currentTrip:
                                                          widget.charterID,
                                                      reservationID: widget
                                                          .reservationID)));
                                    }
                                  },
                            buttonName: "SAVE AND CONTINUE",
                            fontSize: 12.sp,
                            width: 150.w,
                            AggressorButtonColor: AggressorColors.aero
                                .withOpacity(isAbsorbing ? 0.7 : 1),
                            AggressorTextColor: AggressorColors.white),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
