import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/emergency_contact.dart';
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

class Policy extends StatefulWidget {
  Policy({required this.charterID, required this.reservationID, this.user});
  String charterID;
  String reservationID;
  User? user;
  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  WebViewController controller = WebViewController();
  bool isLoading = true;
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
    return AbsorbPointer(
      absorbing:
          form_status.policy == "1" || form_status.policy == "2" ? true : false,
      child: Scaffold(
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
                ),
                height: 450.h,
                child: Stack(
                  children: [
                    WebViewWidget(controller: controller),
                    Visibility(
                        visible: isLoading,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Color(0xfff1926e)),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 25.w, right: 25.w),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xfff1926e),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(
                  "This form has been finalized. If you need to make changes, please call your reservationist.",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w200),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AggressorButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    buttonName: "CANCEL",
                    fontSize: 12.sp,
                    width: 70.w,
                    AggressorButtonColor: AggressorColors.chromeYellow,
                    AggressorTextColor: AggressorColors.white,
                  ),
                  SizedBox(width: 25.w),
                  AggressorButton(
                      onPressed: () async {
                        await AggressorApi().updatingStatus(
                            charID: widget.charterID,
                            contactID: basicInfoModel.contactID!,
                            column: "policy");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmergencyContact(
                                    charID: widget.charterID,
                                    currentTrip: widget.charterID,
                                    reservationID: widget.reservationID)));
                      },
                      buttonName: "SAVE AND CONTINUE",
                      fontSize: 12.sp,
                      width: 150.w,
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
