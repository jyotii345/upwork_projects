import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/user_interface_pages/login_page.dart';
import 'package:flutter/material.dart';


class ContactSelection extends StatefulWidget {
  ContactSelection(this.jsonResponse, this.email, this.dateOfBirth, this.name,
      this.password);

  final dynamic jsonResponse;

  final String email;
  final DateTime dateOfBirth;
  final String name;
  final String password;
  @override
  State<StatefulWidget> createState() => new ContactSelectionState();
}

class ContactSelectionState extends State<ContactSelection> {
  /*
  instance vars
   */

  double textSize=0;

  bool isLoading = false;
  String errorMessage = "";
  List<dynamic> contactList = [];
  int groupSelectionValue = 0;

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
    textSize = MediaQuery.of(context).size.width / 25;

    return Scaffold(
      appBar: getAppBar(),
      body: PinchToZoom(
        OrientationBuilder(
          builder: (context, orientation) {
            portrait = orientation == Orientation.portrait;
            return Stack(
              children: [
                getBackgroundImage(),
                getPageForm(),
                getBannerImage(),
              ],
            );
          },
        ),
      ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Opacity(
              opacity: 0,
              child: getBannerImage(),
            ),
            getPageTitle(),
            getPagePrompt(),
            getContactList(),
            contactList.length == 0 ? Container() : getChooseContactButton(),
            getCreateNewContactButton(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  void showConfirmationBox(String value) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text('Confirm selection'),
              content: new Text(
                "Are you sure you would like to select the contact from the following city: " +
                    value,
              ),
              actions: <Widget>[
                new TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('NO')),
                new TextButton(
                    onPressed: () {
                      linkContact(contactList[groupSelectionValue]);
                    },
                    child: new Text('YES')),
              ],
            ));
  }

  void linkContact(var selectedContact) async {
    var linkResponse = await AggressorApi().linkContact(
        selectedContact["contactid"], widget.jsonResponse["userID"].toString());
    if (linkResponse["status"] == "success") {
      int popCount = 0;
      Navigator.popUntil(context, (route) {
        return popCount++ == 3;
      });
    } else {
      setState(() {
        errorMessage = "Error linking to this contact, please try again.";
      });
    }
  }

  Widget getPagePrompt() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Text(
        "Select the city that matches the contact you wish to use or create a new contact",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget getChooseContactButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextButton(
        onPressed: () {
          setState(() {
            errorMessage = "";
          });
          showConfirmationBox(contactList[groupSelectionValue]["city"]);
        },
        child: Text(
          "Choose selected contact",
          style: TextStyle(color: Colors.white),
        ),
        style:
            TextButton.styleFrom(backgroundColor: AggressorColors.primaryColor),
      ),
    );
  }

  Widget getCreateNewContactButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextButton(
        onPressed: () {
          setState(() {
            errorMessage = "";
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()
                // CreateContact(
                // widget.jsonResponse["userID"].toString(),
                // widget.name,
                // widget.email,
                // widget.password)
                ),
          );
        },
        child: Text(
          "Create new contact",
          style: TextStyle(color: Colors.white),
        ),
        style:
            TextButton.styleFrom(backgroundColor: AggressorColors.primaryColor),
      ),
    );
  }

  Widget getContactList() {
    contactList = populateContactList();
    if (contactList.length == 0) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "No contacts were found with this information, please create a new contact.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: contactList.length,
            itemBuilder: (context, position) {
              return Column(children: [
                RadioListTile(
                    title: Text(contactList[position]["city"]),
                    value: position,
                    groupValue: groupSelectionValue,
                    onChanged: (value) {
                      setState(() {
                        groupSelectionValue = int.parse(value.toString());
                      });
                    }),
                Divider(
                  thickness: 1,
                  color: Colors.grey[400],
                )
              ]);
            }),
      );
    }
  }

  List<dynamic> populateContactList() {
    List<dynamic> contactList = [];
    if (widget.jsonResponse["status"] == "success") {
      if (widget.jsonResponse["data"] != null &&
          widget.jsonResponse["data"].length > 0) {
        int i = 1;
        while (widget.jsonResponse["data"][i.toString()] != null) {
          contactList.add(widget.jsonResponse["data"][i.toString()]);
          i++;
        }
      }
    }
    return contactList;
  }

  Widget showErrorMessage() {
    return errorMessage == ""
        ? Container()
        : Padding(
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 10.0),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget getBackgroundImage() {
    // this method return the blue background globe image that is lightly shown under the application, this also return the slightly tinted overview for it.
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.25), BlendMode.dstATop),
        child: Image.asset(
          "assets/pagebackground.png",
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget getBannerImage() {
    // returns banner image
    return Image.asset(
      "assets/bannerimage.png",
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.scaleDown,
    );
  }

  Widget getPageTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Select Contact",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 30
                  : MediaQuery.of(context).size.width / 30,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
