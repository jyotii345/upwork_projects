import 'dart:convert';

import 'package:aggressor_adventures/user_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

class loginPage extends StatefulWidget {
  loginPage();

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<loginPage> {
  /*
  instance vars
   */

  final String apiKey =
      "pwBL1rik1hyi5JWPid"; //TODO store in a more reachable area to improve usability

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Database database;

  String userId;
  String nameF;
  String nameL;
  String email;
  String contactId;
  String OFYContactId;
  String userType;
  String contactType;

  /*
  initState

  Build
   */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Image.asset(
                "assets/bkg.png",
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            getLoginForm(),
          ],
        ));
  }

/*
  self implemented
   */

  Widget getLoginForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              25, MediaQuery.of(context).size.height / 4, 25, 5),
          child: getUserButton(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
          child: getPassButton(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(75, 5, 75, 0),
          child: getLoginButton(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: getToolbar(),
        ),
        //getToolBar(),
      ],
    );
  }

  Widget getUserButton() {
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
          decoration: InputDecoration(
              hintText: "User Name",
              isDense: true,
              contentPadding: EdgeInsets.all(3)),
        ),
      ),
    );
  }

  Widget getPassButton() {
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
          decoration: InputDecoration(
              hintText: "Password",
              isDense: true,
              contentPadding: EdgeInsets.all(3)),
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
          login(username, password);
        },
        child: Text(
          "Log-In",
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.black, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(0)),
        ),
      ),
    );
  }

  void login(String username, String password) async {
    passwordController.clear();
    //creates a get request to the API authentication method for login verification
    final requestParams = {
      "username": username,
      "password": password,
    };

    Request request = Request("GET",
        Uri.parse("https://secure.aggressor.com/api/app/authentication/login"))
      ..body = json.encode(requestParams)
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    print(await pageResponse.stream.bytesToString());
  }

  saveUserData() async {
    await database.delete("user", where: 'id = ?', whereArgs: [100]);
    await database.rawInsert(
        'INSERT INTO user(id, userId ,nameF ,nameL ,email ,contactId ,OFYContactId ,userType ,contactType) VALUES(?,?,?,?,?,?,?,?,?,)',
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
        ]);
  }

  initDatabase() async {
    //initialize database for sql storage
    database = await DatabaseHelper.instance.database;
  }

  Widget getToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            print("create account");
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
            print("forgot password");
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
