import 'dart:typed_data';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/aggressor_colors.dart';

class Rewards extends StatefulWidget {
  Rewards();

  @override
  State<StatefulWidget> createState() => new RewardsState();
}

class RewardsState extends State<Rewards> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */
  List<dynamic> sliderImages = [];
  int sliderIndex = 0;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    updateSliderImages();
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
        getSliderImages(),
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
        child: ListView(
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
          "assets/pagebackground.png",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget getSliderImages() {
    //returns banner image
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          child: Image.memory(
            sliderImages[sliderIndex],
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                if (sliderIndex < 2) {
                  setState(() {
                    sliderIndex++;
                  });
                }
              },
              child: Icon(
                Icons.chevron_right,
                color: Colors.white70,
                size: MediaQuery.of(context).size.width / 7.5,
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                if (sliderIndex > 0) {
                  setState(() {
                    sliderIndex--;
                  });
                }
              },
              child: Icon(
                Icons.chevron_left,
                color: Colors.white70,
                size: MediaQuery.of(context).size.width / 7.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getPageTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "My Rewards",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void updateSliderImages() async {
    //TODO store these files somewhere
    List<String> fileNames = await AggressorApi().getRewardsSliderList();
    print(fileNames.toString());
    for (var file in fileNames) {
      var fileResponse = await AggressorApi()
          .getRewardsSliderImage(file.substring(file.indexOf("/") + 1));
      Uint8List bytes = await readByteStream(fileResponse.stream);
      print(bytes);
      sliderImages.add(bytes);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
