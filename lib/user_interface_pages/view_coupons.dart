import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCouponsPage extends StatefulWidget {
  ViewCouponsPage(this.userId);

  final String userId;

  @override
  State<StatefulWidget> createState() => new ViewCouponsPageState();
}

class ViewCouponsPageState extends State<ViewCouponsPage> {
  /*
  instance vars
   */

  double textSize=0, textDisplayWidth=0;

  bool isLoading = false;
  String errorMessage = "";

  int points = 0;
  double worth = 0;
  int myPoints = 0;
  final formKey = new GlobalKey<FormState>();

  List<dynamic> countryList = [], stateList = [];

  TextEditingController pointController = TextEditingController();

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    popDistance = 2;
  }

  /*
  Build
   */
  @override
  Widget build(BuildContext context) {
    textSize = MediaQuery.of(context).size.width / 25;
    textDisplayWidth = MediaQuery.of(context).size.width / 2.6;

    return Scaffold(
      appBar: getAppBar(),
      body: PinchToZoom(
        OrientationBuilder(
          builder: (context, orientation) {
            portrait = orientation == Orientation.portrait;
            return Stack(
              children: [
                getPageForm(),
                getLoadingWheel(),
              ],
            );
          },
        ),
      ),
    );
  }

  /*
  Self implemented
   */

  Widget getPageForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            getPageTitle(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                height: 1,
                color: Colors.grey[400],
                width: double.infinity,
              ),
            ),
            getCoupons(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget getCoupons() {
    return FutureBuilder(
        future: AggressorApi().getCoupons(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data=[];
            try{
              data=snapshot.data as List;
            }
            catch(e){
              data=[];
            }
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length + 1,
                itemBuilder: (context, index) {
                  if (index == data.length) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                TextSpan(
                                    text:
                                        "Visit Aggressor Boutique to redeem your Boutique Points Coupon at "),
                                TextSpan(
                                    text: "https://aggressorboutique.com",
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch("https://aggressorboutique.com");
                                      })
                              ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Make your selection and follow steps to checkout",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Step 01 - Complete shipping information",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Step 02 - Review & Payments. Below the PAYMENT METHOD you will"
                            " see APPLY DISCOUNT CODE ^. Click the drop-down to reveal the \"Enter discount code\" "
                            "box. Enter code and click APPLY DISCOUNT",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Step 03 - Complete your purchase",
                          ),
                        )
                      ],
                    );
                  }
                  return ListTile(
                      tileColor: data[index]['codeUsed'] == true
                          ? Colors.red
                          : Colors.green,
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\$ " +
                                  (double.parse(data[index]
                                                  ["pointsUsed"]
                                              .toString()) *
                                          .05)
                                      .toStringAsFixed(2)),
                              Text(
                                data[index]['dateIssued'],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                data[index]['codeIssued'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(data[index]['codeUsed'] == true
                          ? "Redeemed"
                          : "Unused"));
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget showErrorMessage() {
    return errorMessage == ""
        ? Container()
        : Padding(
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 10.0),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget getPageTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Coupons",
          style: TextStyle(
              color: AggressorColors.secondaryColor,
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 40
                  : MediaQuery.of(context).size.width / 40,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getLoadingWheel() {
    return isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }
}
