import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:flutter/material.dart';

import '../../classes/aggressor_colors.dart';
import '../../classes/trip.dart';

class GuestInformation extends StatefulWidget {
  GuestInformation({required this.currentTrip, required this.reservationID});
  final String currentTrip;
  final String reservationID;
  @override
  State<GuestInformation> createState() => _GuestInformationState();
}

class _GuestInformationState extends State<GuestInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getGISAppDrawer(
          charterID: widget.currentTrip, reservationID: widget.reservationID),
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
      body: Column(),
    );
  }
}
