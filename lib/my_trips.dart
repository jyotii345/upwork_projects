import 'dart:io';

import 'package:flutter/cupertino.dart';

class MyTrips extends StatefulWidget {
  MyTrips();


  @override
  State<StatefulWidget> createState() => new myTripsState();
}

class myTripsState extends State<MyTrips>
    with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

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
    super.build(context);

    return Container(child: Text("placeholder for the my trips page"),);
  }

  @override
  bool get wantKeepAlive => throw UnimplementedError();

/*
  self implemented
   */


}
