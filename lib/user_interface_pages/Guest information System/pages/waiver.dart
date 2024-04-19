import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/pages/policy.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../classes/aggressor_colors.dart';
import '../../../classes/colors.dart';
import '../../../classes/globals_user_interface.dart';
import '../../../classes/trip.dart';
import '../../../classes/user.dart';
import '../widgets/aggressor_button.dart';

class Waiver extends StatefulWidget {
  Waiver({required this.charterID, required this.reservationID, this.user});
  String charterID;
  String reservationID;
  User? user;
  @override
  State<Waiver> createState() => _WaiverState();
}

class _WaiverState extends State<Waiver> {
  WebViewController controller = WebViewController();
  AggressorApi aggressorApi = AggressorApi();
  bool isLoading = true;
  Trip firstTrip = tripList[0];
  var tempList;
  var hostAddress;
  @override
  void initState() {
    getTripInfo();
    gettingIP();
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
          Uri.parse("https://gis.aggressoradventures.com/templates/waiver"));
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
    Trip firstTrip = tripList[0];
    print("Charter ID of first trip: ${firstTrip.charterId}");
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
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0, left: 25, right: 25),
            child: Text(
                'Online Application and Waiver Form - Release of Liability & Assumption of Risk',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xfff1926e))),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Text(
                "Guest who fail to complete this form prior to departure *WILL BE* denied boarding",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xfff1926e))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              height: 350,
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  Visibility(
                      visible: isLoading,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(0xfff1926e)),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 25, right: 25),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xfff1926e),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Text(
                "This form has been finalized. If you need to make changes, please call your reservationist.",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                AggressorButton(
                    onPressed: () async {
                      await AggressorApi().postWaiverForm(
                          contactId: basicInfoModel.contactID!,
                          reservationID: widget.reservationID,
                          charID: widget.charterID,
                          ipAddress: hostAddress);
                      await AggressorApi().updatingStatus(
                          charID: widget.charterID,
                          contactID: basicInfoModel.contactID!,
                          column: "waiver");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Policy(
                                  charterID: widget.charterID,
                                  reservationID: widget.reservationID)));
                    },
                    buttonName: "SAVE AND CONTINUE",
                    fontSize: 12,
                    width: 150,
                    AggressorButtonColor: Color(0xff57ddda),
                    AggressorTextColor: AggressorColors.white),
                AggressorButton(
                    onPressed: () async {
                      await AggressorApi().downloadWaiver(
                          contactId: basicInfoModel.contactID!,
                          charID: widget.charterID);
                    },
                    buttonName: "DOWNLOAD WAIVER",
                    fontSize: 12,
                    width: 140,
                    AggressorButtonColor: AggressorColors.dimGrey,
                    AggressorTextColor: AggressorColors.white),
              ],
            ),
          )
        ],
      ),
    );
  }
}
