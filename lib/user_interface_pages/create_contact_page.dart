import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'login_page.dart';

class CreateContact extends StatefulWidget {
  CreateContact(this.userId);

  String userId;

  @override
  State<StatefulWidget> createState() => new CreateContactState();
}

class CreateContactState extends State<CreateContact>
    with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  double textSize, textDisplayWidth;

  bool isLoading = false;
  bool stateAndCountryLoaded = false;
  String errorMessage = "";
  String genderDropDownOption = "Male";
  String address1 = "",
      address2 = "",
      city = "",
      zip = "",
      territory = "",
      email,
      homePhone,
      mobilePhone;
  DateTime dateOfBirth = DateTime.now();
  Map<String, dynamic> countryDropDownSelection;
  Map<String, dynamic> stateDropDownSelection;

  final formKey = new GlobalKey<FormState>();

  List<dynamic> countryList = [], stateList = [];

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

    textSize = MediaQuery.of(context).size.width / 25;

    textDisplayWidth = MediaQuery.of(context).size.width / 2.6;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: AppBar().preferredSize.height,
          child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xff59a3c0),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        title: Image.asset(
          "assets/logo.png",
          height: AppBar().preferredSize.height,
          fit: BoxFit.fitHeight,
        ),
        actions: <Widget>[],
      ),
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
          getLoadingWheel(),
        ],
      ),
    );
  }

  /*
  Self implemented
   */

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      errorMessage = "";
      isLoading = true;
    });



    if (validateAndSave()) {
      try {

        if(countryDropDownSelection["country"] == "USA"){
          territory = stateDropDownSelection["stateAbbr"];
        }

        String birthday = formatDate(dateOfBirth, [yyyy, mm, dd]);

        var jsonResponse = await AggressorApi().sendNewContact(widget.userId, address1, address2, city, countryDropDownSelection["country"] == "USA" ? territory : "", countryDropDownSelection["country"] != "USA" ? territory : "", countryDropDownSelection["countryid"].toString(), zip, email, homePhone, mobilePhone, birthday, genderDropDownOption.toLowerCase());
        print(jsonResponse.toString());
        if (jsonResponse["status"] == "success") {
            showSuccessDialogue();
        } else {
          throw Exception("Error creating account, please try again.");
        }

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print('caught Error: $e');
        setState(() {
          errorMessage = e.message;
          isLoading = false;
        });
      }
    }
  }

  void showSuccessDialogue() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text('Success'),
          content: new Text(
              "Contact successfully created. You can now log in with this information"),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: new Text('Continue')),
          ],
        ));
  }

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
            getContactDetails(),
            showErrorMessage(),
          ],
        ),
      ),
    );
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
    //this method return the blue background globe image that is lightly shown under the application, this also return the slightly tinted overview for it.
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
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Create new contact",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getContactDetails() {
    return FutureBuilder(
        future: getCountryAndState(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    getAddress1(),
                    getAddress2(),
                    getCity(),
                    getCountry(),
                    getTerritory(),
                    getZip(),
                    getEmail(),
                    getHomePhone(),
                    getMobilePhone(),
                    getDateOfBirth(),
                    getGender(),
                    getCreateContactButton(),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget getCreateContactButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          errorMessage = "";
        });
        validateAndSubmit();
      },
      child: Text(
        "Create new contact",
        style: TextStyle(color: Colors.white),
      ),
      style:
          TextButton.styleFrom(backgroundColor: AggressorColors.primaryColor),
    );
  }

  Widget getGender() {
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Gender: "),
        ),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: genderDropDownOption,
            onChanged: (String newValue) {
              setState(() {
                genderDropDownOption = newValue;
              });
            },
            items: <String>["Male", "Female"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget getDateOfBirth() {
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Birthday: "),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
              ),
            ),
            child: TextButton(
              onPressed: () => selectBirthDay(
                context,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  dateOfBirth.month.toString() +
                      "/" +
                      dateOfBirth.day.toString() +
                      "/" +
                      (dateOfBirth.year).toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(0),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> selectBirthDay(BuildContext context) async {
    final DateTime selection = await showDatePicker(
        context: context,
        initialDate: dateOfBirth,
        firstDate: DateTime.now().subtract(Duration(days: 365 * 130)),
        lastDate: DateTime.now());
    if (selection != null && selection != dateOfBirth)
      setState(() {
        dateOfBirth = selection;
      });
  }

  Widget getAddress1() {
    //returns the widget item containing the address first line
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Address Line 1: "),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: "Address line 1"),
            validator: (value) =>
                value.isEmpty ? 'Address line 1 can\'t be empty' : null,
            onSaved: (value) => address1 = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget getAddress2() {
    //returns the widget item containing the address second line
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Address Line 2: "),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: "Address line 2"),
            onSaved: (value) => address2 = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget getCity() {
    //returns the widget item containing the city
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("City: "),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: "City"),
            validator: (value) => value.isEmpty ? 'City can\'t be empty' : null,
            onSaved: (value) => city = value.trim(),
          ),
        )
      ],
    );
  }

  Widget getTerritory() {
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: countryDropDownSelection["country"] == "USA"
              ? Text("State: ")
              : Text("Province: "),
        ),
        countryDropDownSelection["country"] == "USA"
            ? Expanded(
                child: DropdownButton<Map<String, dynamic>>(
                  isExpanded: true,
                  value: stateDropDownSelection,
                  onChanged: (Map<String, dynamic> newValue) {
                    setState(() {
                      stateDropDownSelection = newValue;
                    });
                  },
                  items: stateList
                      .map<DropdownMenuItem<Map<String, dynamic>>>((value) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      child: Text(value["state"]),
                      value: value,
                    );
                  }).toList(),
                ),
              )
            : Expanded(
                child: TextFormField(
                  decoration: InputDecoration(hintText: "Province"),
                  validator: (value) =>
                      value.isEmpty ? 'Province can\'t be empty' : null,
                  onSaved: (value) => territory = value.trim(),
                ),
              ),
      ],
    );
  }

  Widget getZip() {
    //returns the widget item containing the zip code
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Zip code: "),
        ),
        Expanded(
          child: TextFormField(
            maxLength: 5,
            decoration: InputDecoration(hintText: "Zip code"),
            validator: (value) =>
                value.isEmpty ? 'Zip code can\'t be empty' : null,
            onSaved: (value) => zip = value.trim(),
          ),
        )
      ],
    );
  }

  Widget getCountry() {
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Country: "),
        ),
        Expanded(
          child: DropdownButton<Map<String, dynamic>>(
            isExpanded: true,
            value: countryDropDownSelection,
            onChanged: (Map<String, dynamic> newValue) {
              setState(() {
                countryDropDownSelection = newValue;
              });
            },
            items: countryList
                .map<DropdownMenuItem<Map<String, dynamic>>>((value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                child: Text(value["country"]),
                value: value,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget getEmail() {
    //returns the widget item containing the email
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Email: "),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: "Email"),
            validator: (value) =>
                value.isEmpty ? 'Email can\'t be empty' : null,
            onSaved: (value) => email = value.trim(),
          ),
        )
      ],
    );
  }

  Widget getHomePhone() {
    //returns the widget item containing the Home Phone Number
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Home Phone: "),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: "Home phone"),
            onSaved: (value) => homePhone = value.trim(),
          ),
        )
      ],
    );
  }

  Widget getMobilePhone() {
    //returns the widget item containing the Mobile Phone Number
    return Row(
      children: [
        Container(
          width: textDisplayWidth,
          child: Text("Mobile Phone"),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: "Mobile Phone"),
            onSaved: (value) => mobilePhone = value.trim(),
          ),
        )
      ],
    );
  }

  Future<dynamic> getCountryAndState() async {
    if (!stateAndCountryLoaded) {
      print("getting country and states");
      countryList = await AggressorApi().getCountries();
      stateList = await AggressorApi().getStates();
      countryDropDownSelection = countryList[0];
      stateDropDownSelection = stateList[0];
      setState(() {
        stateAndCountryLoaded = true;
      });
    }
    return "finished";
  }

  Widget getLoadingWheel() {
    return isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }


  @override
  bool get wantKeepAlive => true;
}
