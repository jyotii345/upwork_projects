import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyFiles extends StatefulWidget {
  MyFiles();

  @override
  State<StatefulWidget> createState() => new MyFilesState();
}

class MyFilesState extends State<MyFiles> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  String fileName = "";

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
          height: MediaQuery.of(context).size.height / 7 + 4,
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
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
            ),
            getPageTitle(),
            getUploadFile(),
          ],
        ),
      ),
    );
  }

  Widget getUploadFile() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "UPLOAD FILE",
            style: TextStyle(
                color: AggressorColors.secondaryColor,
                fontSize: MediaQuery.of(context).size.height / 35,
                fontWeight: FontWeight.bold),
          ),
          getFilePrompt(),
          getFileInformation(),
          getUploadFileButton(),
        ],
      ),
    );
  }

  Widget getFileInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "File Name:",
              style:
              TextStyle(fontSize: MediaQuery.of(context).size.height / 45),
            ),
          ),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.height / 35,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Text(
                  fileName,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 40 - 4),
                  textAlign: TextAlign.center,
                )),
          ),
        ],
      ),
    );
  }

  Widget getUploadFileButton() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height / 4,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Upload File",
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
              backgroundColor: AggressorColors.secondaryColor),
        ),
      ],
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

  Widget getBannerImage() {
    //returns banner image
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 7,
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
          "My Files",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getFilePrompt()
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Files must be uploaded as: PDF, TXT, DOC, JPG, PNG",
          style: TextStyle(
              color: Colors.grey[400],
              fontSize: MediaQuery.of(context).size.height / 55,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */

}
