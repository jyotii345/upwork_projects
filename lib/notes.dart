import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'aggressor_colors.dart';

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

    return Stack(
      children: [
        getBackgroundImage(),
        getPageForm(),
        Container(
          height: MediaQuery.of(context).size.height / 6 + 4,
          width: double.infinity,
          color: AggressorColors.secondaryColor,
        ),
        getBannerImage(),
      ],
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
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
            ),
            getPageTitle(),
          ],
        ),
      ),
    );
  }

  Widget getBackgroundImage() {
    //this method return the blue background globe image that is lightly shown under the application, this also return the slightly tinted overview for it.
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ColorFiltered(
        colorFilter:
        ColorFilter.mode(Colors.white.withOpacity(0.25), BlendMode.dstATop),
        child: Image.asset(
          "assets/tempbkg.png", //TODO replace with final graphic
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget getBannerImage() {
    //returns banner image
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 6,
      child: Image.asset(
        "assets/bannerimage.png",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget getPageTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Trip Notes",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;



}
