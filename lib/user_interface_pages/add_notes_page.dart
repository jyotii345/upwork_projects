import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNotes extends StatefulWidget {
  AddNotes(
    this.user,
    this.noteTrip,
    this.boat,
  );

  final User user;
  final Trip noteTrip;
  final Map<String, dynamic> boat;

  @override
  State<StatefulWidget> createState() => new AddNotesState();
}

class AddNotesState extends State<AddNotes> with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  int pageIndex = 1;
  String departureDate = "";
  String returnDate = "";
  Trip dropDownValue;

  HtmlEditorController preNotesController = HtmlEditorController();
  HtmlEditorController postNotesController = HtmlEditorController();
  HtmlEditorController miscNotesController = HtmlEditorController();

  bool loading = false;

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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: AppBar().preferredSize.height,
          child: IconButton(
            icon: Container(
              child: Image.asset("assets/callicon.png"),
            ),
            onPressed: makeCall,
          ),
        ),
        title: Image.asset(
          "assets/logo.png",
          height: AppBar().preferredSize.height,
          fit: BoxFit.fitHeight,
        ),
      ),
      bottomNavigationBar: getBottomNavigation(),
      body: Stack(
        children: [
          getBackgroundImage(),
          getPageForm(),
          Container(
            height: MediaQuery.of(context).size.height / 7 + 4,
            width: double.infinity,
            color: AggressorColors.secondaryColor,
          ),
          getBannerImage(),
          getLoading(),
        ],
      ),
    );
  }

  /*
  Self implemented
   */

  Widget getBottomNavigation() {
    /*
    returns a bottom navigation bar widget containing the pages desired and their icon types. This is only for the look of the bottom navigation bar
     */

    double iconSize = MediaQuery.of(context).size.width / 8;
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (int) {
        handleBottomNavigation(int);
      },
      backgroundColor: AggressorColors.primaryColor,
      // new
      currentIndex: pageIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      items: [
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/tripsactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/tripspassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/notesactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/notespassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/photosactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/photospassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/rewardsactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/rewardspassive.png"),
          ),
          label: '',
        ),
        new BottomNavigationBarItem(
          activeIcon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              "assets/filesactive.png",
            ),
          ),
          icon: Container(
            width: iconSize,
            height: iconSize,
            child: Image.asset("assets/filespassive.png"),
          ),
          label: '',
        ),
      ],
    );
  } //TODO change bottom nav icon size

  makeCall() async {
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  void handleBottomNavigation(int index) {
    currentIndex = index - 1;
    Navigator.pop(context);
  }

  Widget getPageForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 7,
              ),
              getPageTitle(),
              getYachtInformation(),
              getDepartureDate(),
              getReturnDate(),
              getPreTripNotes(),
              getPostTripNotes(),
              getMiscNotes(),
              getSaveNotesButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSaveNotesButton() {
    return TextButton(
      onPressed: () {
        uploadNote();
      },
      child: Text(
        "Create this Note",
        style: TextStyle(color: Colors.white),
      ),
      style:
          TextButton.styleFrom(backgroundColor: AggressorColors.secondaryColor),
    );
  }

  Widget getPreTripNotes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Pre-Trip Notes:",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 45 - 4),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: HtmlEditor(
                controller: preNotesController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void uploadNote() async {
    setState(() {
      loading = true;
    });

    String startDate = formatDate(
        DateTime.parse(widget.noteTrip.charter.startDate),
        [yyyy, '-', mm, '-', dd]);

    String endDate = formatDate(
        DateTime.parse(widget.noteTrip.charter.startDate)
            .add(Duration(days: int.parse(widget.noteTrip.charter.nights))),
        [yyyy, '-', mm, '-', dd]);

    print(await preNotesController.getText());

    setState(() {
      loading = false;
      notesLoaded = false;
    });
    //Navigator.pop(context);
  }

  Widget getPostTripNotes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Post-Trip Notes:",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 45 - 4),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              //       child: FlutterSummernote(
              //         key: postNotesEditor,
              //         hasAttachment: false,
              //         customToolbar: """
              //     [
              //     ]
              // """,
              //         showBottomToolbar: false,
              //       ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMiscNotes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Post-Trip Notes:",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 45 - 4),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              //       child: FlutterSummernote(
              //         key: miscNotesEditor,
              //         hasAttachment: false,
              //         customToolbar: """
              //     [
              //     ]
              // """,
              //         showBottomToolbar: false,
              //       ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getYachtInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Destination:",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 45,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 45,
                width: MediaQuery.of(context).size.width / 2 -
                    MediaQuery.of(context).size.height / 40 -
                    10,
                child: Text(
                  widget.boat["name"],
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 45 - 4),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDepartureDate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Departure Date:",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 45,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Text(
                DateTime.parse(widget.noteTrip.charter.startDate)
                        .month
                        .toString() +
                    "/" +
                    DateTime.parse(widget.noteTrip.charter.startDate)
                        .day
                        .toString() +
                    "/" +
                    DateTime.parse(widget.noteTrip.charter.startDate)
                        .year
                        .toString(),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 45 - 4),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getReturnDate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(
              "Return Date",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45 - 4),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 45,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 45,
                width: MediaQuery.of(context).size.width / 2 -
                    MediaQuery.of(context).size.height / 40 -
                    10,
                child: Text(
                  DateTime.parse(widget.noteTrip.charter.startDate)
                          .add(Duration(
                              days: int.parse(widget.noteTrip.charter.nights)))
                          .month
                          .toString() +
                      "/" +
                      DateTime.parse(widget.noteTrip.charter.startDate)
                          .add(Duration(
                              days: int.parse(widget.noteTrip.charter.nights)))
                          .day
                          .toString() +
                      "/" +
                      DateTime.parse(widget.noteTrip.charter.startDate)
                          .add(Duration(
                              days: int.parse(widget.noteTrip.charter.nights)))
                          .year
                          .toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 45 - 4),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
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
    double iconSize = MediaQuery.of(context).size.width / 10;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          "Add Adventure Note",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 26,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getLoading() {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }

  @override
  bool get wantKeepAlive => true;
}
