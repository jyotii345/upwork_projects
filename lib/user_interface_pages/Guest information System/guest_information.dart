import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
  void initState() {
    getTripDetails();
    checkPermissionStatus();
    super.initState();
  }

  getTripDetails() {
    var list = tripList;
    print(list);
  }

  Future<void> checkPermissionStatus() async {
    final permission = Permission.storage;
    if (await permission.isDenied) {
      await await permission.request();
    } else {
      await permission.status.isGranted;
    }
  }

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
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10),
          child: Text(
            "Welcome To Your Guest Information System (GIS) Portal.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff736f77)),
          ),
        ),
        SizedBox(height: 10),
        Divider(thickness: 1),
        SizedBox(
          height: 350,
          child: GridView.count(
            childAspectRatio:2,
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                // color: Colors.teal[100],
                child: const Text("Name"),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[200],
                child: const Text('Confirmation'),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[300],
                child: const Text('Yacht'),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[400],
                child: const Text('Departure'),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[500],
                child: const Text('Nights'),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
