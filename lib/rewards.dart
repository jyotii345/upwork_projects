import 'package:flutter/cupertino.dart';

class Rewards extends StatefulWidget {
  Rewards();


  @override
  State<StatefulWidget> createState() => new RewardsState();
}

class RewardsState extends State<Rewards>
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

    return Container(child: Text("placeholder for the rewards page"),);
  }

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */


}
