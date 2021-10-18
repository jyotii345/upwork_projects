import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  double textSize, textDisplayWidth;

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
          print(snapshot.data);
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: snapshot.data[index]['codeUsed'] == true
                  ? Colors.red
                      : Colors.green,
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\$ " +
                                  (double.parse(snapshot.data[index]
                                                  ["pointsUsed"]
                                              .toString()) *
                                          .05)
                                      .toStringAsFixed(2)),
                              Text(
                                snapshot.data[index]['dateIssued'],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                snapshot.data[index]['codeIssued'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(snapshot.data[index]['codeUsed'] == true
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
