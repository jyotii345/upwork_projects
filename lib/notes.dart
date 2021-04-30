import 'package:flutter/cupertino.dart';

class Notes extends StatefulWidget {
  Notes();


  @override
  State<StatefulWidget> createState() => new NotesState();
}

class NotesState extends State<Notes>
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

    return Container(child: Text("placeholder for the notes page"),);
  }

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */


}
