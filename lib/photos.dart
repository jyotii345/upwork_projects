import 'dart:io';

import 'package:flutter/cupertino.dart';

class Photos extends StatefulWidget {
  Photos();


  @override
  State<StatefulWidget> createState() => new PhotosState();
}

class PhotosState extends State<Photos>
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

    return Container(child: Text("placeholder for the photos page"),);
  }

  @override
  bool get wantKeepAlive => throw UnimplementedError();

/*
  self implemented
   */


}
