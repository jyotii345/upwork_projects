import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/user_interface_pages/contact_selection_page.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage();

  @override
  State<StatefulWidget> createState() => new RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage>
    with AutomaticKeepAliveClientMixin {
  /*
  instance vars
   */

  String firstName = "",
      lastName = "",
      email = "",
      password = "",
      passwordConfirmation = "",
      errorMessage = "";

  double textSize;

  DateTime dateOfBirth = DateTime.now();

  bool isLoading = false;

  final formKey = new GlobalKey<FormState>();

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

  Widget getPageForm() {
    //returns the main listview containing the contents of the page
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
            Form(
              key: formKey,
              child: Column(
                children: [
                  getPageTitle(),
                  getFirstName(),
                  getLastName(),
                  getEmail(),
                  getEmail(),
                  getDateOfBirth(),
                  getPassword(),
                  getConfirmPassword(),
                ],
              ),
            ),
            showPasswordRequirements(),
            showRegisterButton(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget getFirstName() {
    //returns the field prompting for the first name
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: textSize),
        decoration: new InputDecoration(
          hintText: 'First Name',
          icon: Icon(
            Icons.person,
            color: AggressorColors.secondaryColor,
          ),
        ),
        validator: (value) =>
            value.isEmpty ? 'First Name can\'t be empty' : null,
        onSaved: (value) => firstName = value.trim(),
      ),
    );
  }

  Widget getLastName() {
    //returns the field prompting for the last name
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: textSize),
        decoration: new InputDecoration(
          hintText: 'Last Name',
          icon: Icon(
            Icons.person_outlined,
            color: AggressorColors.secondaryColor,
          ),
        ),
        validator: (value) =>
            value.isEmpty ? 'Last Name can\'t be empty' : null,
        onSaved: (value) => lastName = value.trim(),
      ),
    );
  }

  Widget getEmail() {
    //returns the field prompting for the email
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: textSize),
        decoration: new InputDecoration(
          hintText: 'Email',
          icon: Icon(
            Icons.email,
            color: AggressorColors.secondaryColor,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => email = value.trim(),
      ),
    );
  }

  Widget getDateOfBirth() {
    //returns the date picker for the user's date of birth
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
            child: Icon(
              Icons.cake,
              color: AggressorColors.secondaryColor,
            ),
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
                      fontSize: textSize,
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
      ),
    );
  }

  Future<void> selectBirthDay(BuildContext context) async {
    //calls the date picker to open and prompts for the users birthday
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

  Widget getPassword() {
    //prompts for the password
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: new TextFormField(
        obscureText: true,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: textSize),
        decoration: new InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: AggressorColors.secondaryColor,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => password = value.trim(),
      ),
    );
  }

  Widget getConfirmPassword() {
    //prompts for the password confirmation
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: new TextFormField(
        obscureText: true,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: textSize),
        decoration: new InputDecoration(
          hintText: 'Confirm Password',
          icon: Icon(
            Icons.lock_outline,
            color: AggressorColors.secondaryColor,
          ),
        ),
        validator: (value) =>
            value.isEmpty ? 'Password confirmation can\'t be empty' : null,
        onSaved: (value) => passwordConfirmation = value.trim(),
      ),
    );
  }

  Widget showPasswordRequirements() {
    //displays the criteria of a valid password
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Text(
            "• Password must be 8 characters long or larger",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: MediaQuery.of(context).size.height / 60,
            ),
          ),
          Text(
            "• Password must contain at least one numerical digit",
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: MediaQuery.of(context).size.height / 60),
          ),
          Text(
            "• Password must contain at least one capital letter",
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: MediaQuery.of(context).size.height / 60),
          ),
          Text(
            "• Password must contain one special character",
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: MediaQuery.of(context).size.height / 60),
          ),
        ],
      ),
    );
  }

  Widget showRegisterButton() {
    //returns the registration button
    return Padding(
        padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
        child: SizedBox(
          height: 40.0,
          child: TextButton(
            style: TextButton.styleFrom(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              backgroundColor: AggressorColors.secondaryColor,
            ),
            child: Text('Register',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showErrorMessage() {
    //displays the error message if there is one
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

  bool validateAndSave() {

    // Check if form is valid before perform login or signup
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void showSuccessDialogue() {
    //shows a dialogue confirming the profile was registered and navigates to the home screen
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text('Success'),
              content: new Text(
                  "Account was successfully registered. You can now log in with this information"),
              actions: <Widget>[
                new TextButton(
                    onPressed: () {
                      int popCount = 0;
                      Navigator.popUntil(context, (route) {
                        return popCount++ == 2;
                      });
                    },
                    child: new Text('Continue')),
              ],
            ));
  }

  void validateAndSubmit() async {

    // Perform login or signup
    setState(() {
      errorMessage = "";
      isLoading = true;
    });

    if (validateAndSave()) {
      try {
        if (password != passwordConfirmation) {
          if (!validatePassword(password)) {
            throw Exception("Password does not meet security requirements");
          }
        } else {
          String birthday = formatDate(dateOfBirth, [yyyy, '-', mm, '-', dd]);
          var jsonResponse = await AggressorApi()
              .sendRegistration(firstName, lastName, email, password, birthday);
          if (jsonResponse["status"] == "success") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContactSelection(jsonResponse)));
          } else {
            throw Exception("Error creating account, please try again.");
          }
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

  bool validatePassword(String password) {
    //used to ensure the password is valid
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(password);
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
    //returns the page title
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Registration",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getLoadingWheel() {
    //shows loading wheel if the page is loading data
    return isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }

  @override
  bool get wantKeepAlive => true;
}
