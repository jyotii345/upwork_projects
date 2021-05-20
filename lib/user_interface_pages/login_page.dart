import 'dart:convert';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/user_database.dart';
import 'package:aggressor_adventures/user_interface_pages/main_page.dart';
import 'package:aggressor_adventures/user_interface_pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
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

  bool isLoading = false; // boolean to see if the page is currently loading a login

  String errorText = ""; //string value of errors detected on login

  Database database; // instance variable for sql database

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
    return new Scaffold(
      resizeToAvoidBottomInset: false,
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
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
            child: SizedBox(
              height: AppBar().preferredSize.height,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton<String>(
                    onSelected: handlePopupClick,
                    child: Container(
                      child: Image.asset(
                        "assets/menuicon.png",
                      ),
                    ),
                    itemBuilder: (BuildContext context) {
                      return {
                        "My Profile",
                      }.map((String option) {
                        return PopupMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList();
                    }),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          getBackgroundImage(),
          getLoginForm(),
          getLoadingWheel(),
        ],
      ),
      bottomNavigationBar: getBottomNavigation(),
    );
  }

/*
  self implemented
   */

  makeCall() async {
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePopupClick(String value) {
    switch (value) {
      case 'My Profile':
        setState(() {
          errorText = "You must be logged in to view your profile.";
        });
    }
  }

  Widget getBackgroundImage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Image.asset(
        "assets/loginbackground.png",
        fit: BoxFit.fitHeight,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  Widget getLoadingWheel() {
    return isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }

  Widget getLoginForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25, MediaQuery.of(context).size.height / 4, 25, 5),
          child: getUserTextField(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
          child: getPassTextField(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(75, 5, 75, 0),
          child: getLoginButton(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
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
          controller: usernameController,
          maxLines: 1,
          decoration: InputDecoration(hintText: "User Name", isDense: true, contentPadding: EdgeInsets.all(1)),
        ),
      ),
    );
  }

  Widget getPassTextField() {
    return Container(
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
          controller: passwordController,
          obscureText: true,
          maxLines: 1,
          decoration: InputDecoration(hintText: "Password", isDense: true, contentPadding: EdgeInsets.all(1)),
        ),
      ),
    );
  }

  Widget getLoginButton() {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          String username = usernameController.text.toString();
          String password = passwordController.text.toString();

          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          isLoading = true;
          login(username, password);
        },
        child: Text(
          "Log-In",
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(0)),
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
        errorText = "username or password do not match any items in our records";
      });
    }
  }

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
      onTap: (int) {},
      backgroundColor: AggressorColors.primaryColor,
      // new
      currentIndex: 0,
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
  }


  void checkLoginStatus() async {
    //check if the user is logged in and set the appropriate view if they are or are not
      var userList = await helper.queryUser();
      if (userList.length != 0) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingPage(userList[0])));
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
                        contentPadding: EdgeInsets.only(left: 0, bottom: 0, top: 11, right: 15),
                        hintText: "email"),
                  )
                ],
              ),
              actions: <Widget>[
                new TextButton(
                    onPressed: () async {
                      var response = await AggressorApi().sendForgotPassword(emailConfirmationController.value.text);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
          },
          child: Text(
            "Create Account",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            height: 14,
            width: 1,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            showConfirmationDialogue();
          },
          child: Text(
            "Forgot Password",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
