import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/contact.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/contact_database.dart';
import 'package:aggressor_adventures/user_interface_pages/view_coupons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RedeemPointsPage extends StatefulWidget {
  RedeemPointsPage(this.userId, this.user, this.userPoints);

  final String userId;
  final User user;
  final int userPoints;

  @override
  State<StatefulWidget> createState() => new RedeemPointsPageState();
}

class RedeemPointsPageState extends State<RedeemPointsPage> {
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
    myPoints = widget.userPoints;

    popDistance = 1;
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
      bottomNavigationBar: getCouponBottomNavigationBar(),
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
            getPointRedeem(),
            getBalance(),
            showErrorMessage(),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Container(
                height: 1,
                color: Colors.grey[400],
                width: double.infinity,
              ),
            ),
            getButtons(),
            getInformation(),
          ],
        ),
      ),
    );
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
          "Points (" + widget.user.nameF! + " " + widget.user.nameL! + ")",
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

  Widget getPointRedeem() {
    return Container(
      height: MediaQuery.of(context).size.height / 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: pointController,
                onChanged: (value) {
                  updateWorth();
                },
                decoration: InputDecoration(
                  hintText: '0',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "=",
                style:
                    TextStyle(fontSize: MediaQuery.of(context).size.width / 14),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300]),
                      child: Center(
                        child: Text(
                          "\$",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey,
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          child: Text(
                            worth.toStringAsFixed(2),
                            style: TextStyle(color: Colors.grey),
                          ),
                          alignment: Alignment.centerLeft),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getBalance() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(
        "Balance: " +
            myPoints.toString() +
            " = \$" +
            (myPoints * .05).toStringAsFixed(2),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width / 20),
      ),
    );
  }

  Widget getButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewCouponsPage(widget.userId)));
            },
            child: AutoSizeText(
              "View Past Coupons",
              maxLines: 1,
              minFontSize: 3,
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: AggressorColors.secondaryColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton(
              onPressed: () {
                pointController.clear();
                setState(() {
                  points = 0;
                  worth = 0;
                });
              },
              child: AutoSizeText(
                "Cancel",
                maxLines: 1,
                minFontSize: 3,
                style: TextStyle(color: Colors.black),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.amber),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 1,
          ),
        ),
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: redeemPoints,
            child: AutoSizeText(
              "Redeem Points",
              minFontSize: 3,
              maxLines: 1,
              style: TextStyle(color: Colors.black),
            ),
            style: TextButton.styleFrom(backgroundColor: Colors.green),
          ),
        ),
      ],
    );
  }

  void updateWorth() {
    setState(() {
      try {
        points = int.parse(pointController.text);
        worth = points * .05;
      } catch (e) {
        points = 0;
        worth = 0;
      }
    });
  }

  Widget getInformation() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ways To Earn Boutique Points:\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("•\tMake a reservation, deposit and receive 400 points.\n" +
                "•\tComplete a Guest Survey after your adventure and receive 100 points.\n" +
                "•\tHappy Birthday – receive 100 points on your special day.\n"),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 30,
            ),
            child: Text(
              "Points may be redeemed once you have a point balance and do not expire.\n",
            ),
          ),
          Text(
            "FAQ'S\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("•\tHow much are my points worth?\n"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text("Each point is equivalent to \$0.05 USD.\n"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "•\tDo Redeemed Points Expire?\n",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
                "Yes, redeemed points expire 2 years after receiving code if they are not used. Click “View Past Coupons” button to check unused coupon(s)."),
          ),
        ],
      ),
    );
  }

  void redeemPoints() async {
    setState(() {
      isLoading = true;
    });
    try {
      int redeeming = int.parse(pointController.text);
      if (redeeming <= widget.userPoints && redeeming > 0) {
        var response =
            await AggressorApi().redeemPoints(widget.userId, redeeming);
        if (response["status"] == "success") {
          int newPoints = myPoints - redeeming;
          updateContact();
          pointController.clear();
          setState(() {
            myPoints = newPoints;
            isLoading = false;
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ViewCouponsPage(widget.userId)));
        } else {
          setState(() {
            errorMessage =
                "You do not have that many points, please try again.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "You do not have that many points, please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Points to redeem must be a number greater than 0";
        isLoading = false;
      });
    }
  }

  void updateContact() async {
    var response = await AggressorApi().getContact(widget.user.contactId!);
    setState(() {
      contact = Contact(
          response["contactid"],
          response["first_name"],
          response["middle_name"],
          response["last_name"],
          response["email"],
          response["vipcount"],
          response["vippluscount"],
          response["sevenseascount"],
          response["aacount"],
          response["boutique_points"],
          response["vip"],
          response["vipPlus"],
          response["sevenSeas"],
          response["adventuresClub"],
          response["memberSince"]);
    });
    updateContactCache(response);
  }

  void updateContactCache(var response) async {
    //cleans and saves the contacts to the database
    ContactDatabaseHelper contactDatabaseHelper =
        ContactDatabaseHelper.instance;
    try {
      await contactDatabaseHelper.deleteContactTable();
    } catch (e) {
      print("no notes in the table");
    }

    await contactDatabaseHelper.insertContact(
        response["contactid"],
        response["first_name"],
        response["middle_name"],
        response["last_name"],
        response["email"],
        response["vipcount"],
        response["vippluscount"],
        response["sevenseascount"],
        response["aacount"],
        response["boutique_points"],
        response["vip"],
        response["vipPlus"],
        response["sevenSeas"],
        response["adventuresClub"],
        response["memberSince"]);
  }

  Widget getLoadingWheel() {
    return isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }
}
