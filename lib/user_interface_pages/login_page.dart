import 'dart:io';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/user_database.dart';
import 'package:aggressor_adventures/user_interface_pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'loading_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginPage> {
  /*
  instance vars
   */

  //text editing controllers for user name and password fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading =
      false; // boolean to see if the page is currently loading a login

  String errorText = ""; //string value of errors detected on login

  Database database; // instance variable for sql database

  double sectionWidth, sectionHeight, textSize;

  //user variables to be received upon successful login
  String userId;
  String nameF;
  String nameL;
  String email;
  String contactId;
  String OFYContactId;
  String userType;
  String contactType;

  UserDatabaseHelper helper;

  User currentUser;

  /*
  initState

  Build
   */

  @override
  void initState() {
    super.initState();
    helper = UserDatabaseHelper.instance;
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return PinchToZoom(
      OrientationBuilder(
        builder: (context, orientation) {
          portrait = orientation == Orientation.portrait;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: getAppBar(),
            body: Stack(
              children: <Widget>[
                getBackgroundImage(),
                getLoginForm(),
                getLoadingWheel(),
              ],
            ),
            bottomNavigationBar: getBottomNavigationBar(),
          );
        },
      ),
    );
  }

/*
  self implemented
   */

  Widget getBackgroundImage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Image.asset(
        "assets/loginbackground.png", //TODO make background fit always
        fit: portrait ? BoxFit.fitHeight : BoxFit.fill,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  Widget getLoadingWheel() {
    return isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }

  Widget getLoginForm() {
    sectionWidth = portrait
        ? MediaQuery.of(context).size.width / 1.20
        : MediaQuery.of(context).size.height / 1.20;
    sectionHeight = portrait
        ? MediaQuery.of(context).size.height / 40
        : MediaQuery.of(context).size.width / 50;
    textSize = portrait
        ? MediaQuery.of(context).size.width / 27
        : MediaQuery.of(context).size.height / 60;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              25,
              portrait
                  ? MediaQuery.of(context).size.height / 4
                  : MediaQuery.of(context).size.height / 4.25,
              25,
              portrait ? 5 : 2.5),
          child: getUserTextField(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, portrait ? 5 : 2.5),
          child: getPassTextField(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(75, portrait ? 5 : 2.5, 75, 0),
          child: getLoginButton(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25, portrait ? 5 : 2.5, 25, 0),
          child: getToolbar(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 25, 0),
          child: getErrorText(),
        ),
      ],
    );
  }

  Widget getErrorText() {
    return errorText == ""
        ? Container()
        : Container(
            color: Colors.white70,
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget getUserTextField() {
    return new Container(
      width: sectionWidth,
      height: sectionHeight * 1.2,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: TextField(
          style: TextStyle(fontSize: textSize),
          controller: usernameController,
          maxLines: 1,
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "User Name",
              isDense: true,
              contentPadding: EdgeInsets.all(1)),
        ),
      ),
    );
  }

  Widget getPassTextField() {
    return Container(
      width: sectionWidth,
      height: sectionHeight * 1.2,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: TextField(
          style: TextStyle(fontSize: textSize),
          controller: passwordController,
          obscureText: true,
          maxLines: 1,
          decoration: InputDecoration(

              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Password",
              isDense: true,
              contentPadding: EdgeInsets.all(1)),
        ),
      ),
    );
  }

  Widget getLoginButton() {
    return Container(
      width: sectionWidth * 1.20,
      height: portrait ? sectionHeight * 2 : sectionHeight,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: TextButton(
          onPressed: () {
            String username = usernameController.text.toString().trim();
            String password = passwordController.text.toString().trim();

            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            isLoading = true;
            login(username, password);
          },
          child: Text(
            "Log-In",
            style: TextStyle(color: Colors.white, fontSize: textSize),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(0),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.black, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(0)),
          ),
        ),
      ),
    );
  }

  void login(String username, String password) async {
    //login function to dismiss keyboard, display appropriate error message, store login data in sql database
    setState(() {
      errorText = "";
    });

    passwordController.clear();
    //creates a get request to the API authentication method for login verification
    if (password == "" || username == "") {
      setState(() {
        isLoading = false;
        errorText = "username or password was left blank";
      });
    }

    var loginResponse = await AggressorApi().getUserLogin(username, password);

    if (loginResponse["status"] == "success") {
      setState(() {
        isLoading = false;
      });

      userId = loginResponse["userID"].toString();
      nameF = loginResponse["first"];
      nameL = loginResponse["last"];
      email = loginResponse["email"];
      contactId = loginResponse["contactID"].toString();
      OFYContactId = loginResponse["OFYcontactID"].toString();
      userType = loginResponse["user_type"];
      contactType = loginResponse["contact_type"];

      await initDatabase();
      await saveUserData();

      checkLoginStatus();
    } else {
      setState(() {
        isLoading = false;
        errorText =
            "username or password do not match any items in our records";
      });
    }
  }

  void checkLoginStatus() async {
    //check if the user is logged in and set the appropriate view if they are or are not
    var userList = await helper.queryUser();
    if (userList.length != 0) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoadingPage(userList[0])));
    }
  }

  saveUserData() async {
    //saves user data into the sql database
    await database.delete("user", where: 'id = ?', whereArgs: [100]);
    await database.rawInsert(
      'INSERT INTO user(id, userId ,nameF ,nameL ,email ,contactId ,OFYContactId ,userType ,contactType) VALUES(?,?,?,?,?,?,?,?,?)',
      [
        100,
        userId,
        nameF,
        nameL,
        email,
        contactId,
        OFYContactId,
        userType,
        contactType,
      ],
    );
  }

  initDatabase() async {
    //initialize database for sql storage
    database = await UserDatabaseHelper.instance.database;
  }

  void showConfirmationDialogue() {
    TextEditingController emailConfirmationController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text('Forgot Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Please enter the email associated with your account"),
                  TextField(
                    controller: emailConfirmationController,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 0, bottom: 0, top: 11, right: 15),
                        hintText: "email"),
                  )
                ],
              ),
              actions: <Widget>[
                new TextButton(
                    onPressed: () async {
                      var response = await AggressorApi().sendForgotPassword(
                          emailConfirmationController.value.text);
                      Navigator.pop(context);
                      setState(() {
                        errorText = response["message"];
                      });
                    },
                    child: new Text('Continue')),
              ],
            ));
  }

  Widget getToolbar() {
    //returns widgets for create account and forgot password
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: textSize + 2,
            child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
              onPressed: () {
                setState(() {
                  outterDistanceFromLogin ++;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationPage(distanceReduce)));
              },
              child: Text(
                "Create Account",
                style: TextStyle(color: Colors.white, fontSize: textSize),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Container(
              height: textSize,
              width: 1,
              color: Colors.white,
            ),
          ),
          Container(
            height: textSize + 2,
            child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
              onPressed: () {
                showConfirmationDialogue();
              },
              child: Text(
                "Forgot Password",
                style: TextStyle(color: Colors.white, fontSize: textSize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void distanceReduce(){
    setState(() {
      outterDistanceFromLogin --;
    });
  }
}
