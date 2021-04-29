import 'dart:io';

import 'package:flutter/cupertino.dart';

class MyFiles extends StatefulWidget {
  MyFiles();


  @override
  State<StatefulWidget> createState() => new myFilesState();
}

class myFilesState extends State<MyFiles>
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

    return Container(child: Text("placeholder for the my files page"),);
  }

  @override
  bool get wantKeepAlive => throw UnimplementedError();

  /*
  self implemented
   */


}
