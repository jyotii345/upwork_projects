import 'package:aggressor_adventures/bloc/user_cubit/user_cubit.dart';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ContactUsPage extends StatefulWidget {
  ContactUsPage();


  @override
  State<StatefulWidget> createState() => new ContactUsPageState();
}

class ContactUsPageState extends State<ContactUsPage> {
  /*
  instance vars
   */

  TextEditingController firstName = TextEditingController(),
      lastName = TextEditingController(),
      email = TextEditingController();
  String messageBody = "", errorMessage = "";

  double textSize = 0;

  DateTime dateOfBirth = DateTime.now();

  bool isLoading = false;

  final formKey = new GlobalKey<FormState>();

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
    showBackBtn();
  }

  showBackBtn() {
    backButton = true;

    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserInitial && userState.currentUser != null) {
      outterDistanceFromLogin++;
      // popDistance=1;
      homePage = true;
      firstName.text = userState.currentUser!.nameF.toString();
      lastName.text = userState.currentUser!.nameL.toString();
      email.text = userState.currentUser!.email.toString();
    }
    else{
      outterDistanceFromLogin++;
      homePage = false;
    }
    setState(() {});
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
                getLoadingWheel(),
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
    //returns the main listview containing the contents of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Opacity(
              opacity: 0,
              child: getBannerImage(),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  getPageTitle(),
                  getFirstName(),
                  getLastName(),
                  getEmail(),
                  getMessageBody(),
                ],
              ),
            ),
            // showPasswordRequirements(),
            showSendMailButton(),
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
        controller: firstName,
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
        validator: (value) => (value == null || (value.isEmpty))
            ? 'First Name can\'t be empty'
            : null,
        onSaved: (value) => firstName.text = value!.trim(),
      ),
    );
  }

  Widget getLastName() {
    //returns the field prompting for the last name
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: new TextFormField(
        controller: lastName,
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
        validator: (value) => (value == null || value.isEmpty)
            ? 'Last Name can\'t be empty'
            : null,
        onSaved: (value) => lastName.text = value!.trim(),
      ),
    );
  }

  Widget getEmail() {
    //returns the field prompting for the email
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: new TextFormField(
        controller: email,
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
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Email can\'t be empty' : null,
        onSaved: (value) => email.text = value!.trim(),
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
                  bottom: BorderSide(width: 1.0, color: Colors.grey[400]!),
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
    final DateTime? selection = await showDatePicker(
        context: context,
        initialDate: dateOfBirth,
        firstDate: DateTime.now().subtract(Duration(days: 365 * 130)),
        lastDate: DateTime.now());
    if (selection != null && selection != dateOfBirth)
      setState(() {
        dateOfBirth = selection;
      });
  }

  Widget getMessageBody() {
    //prompts for the password
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: new TextFormField(
        // obscureText: true,
        minLines: 5,
        maxLines: 5,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: textSize),
        decoration: new InputDecoration(
            hintText: 'Type message here',
            icon: Icon(
              Icons.message,
              color: AggressorColors.secondaryColor,
            ),
            alignLabelWithHint: true,
            border: OutlineInputBorder()),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Message can\'t be empty' : null,
        onSaved: (value) => messageBody = value!.trim(),
      ),
    );
  }

  Widget showSendMailButton() {
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
            child: Text('Send',
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
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      setState(() {
        isLoading = false;
      });
    }
    return false;
  }

  void validateAndSubmit() async {
    // Perform login or signup
    setState(() {
      errorMessage = "";
      isLoading = true;
    });

    if (validateAndSave()) {
      try {
        // String birthday = formatDate(dateOfBirth, [yyyy, '-', mm, '-', dd]);
        var jsonResponse = await AggressorApi().sendEmail(
          firstName.text,
          lastName.text,
          email.text,
          messageBody,
        );
        if (jsonResponse["status"] == "success") {
          outterDistanceFromLogin--;
          // popDistance--;

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Message send successfully"),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error sending mail, please try again."),
            ),
          );
          throw Exception("Error sending mail, please try again.");
        }

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error sending mail, please try again."),
          ),
        );

        // print('caught Error: $e');
        setState(() {
          //   errorMessage = e.toString(); //.message;
          isLoading = false;
        });
      }
    }
  }

  bool validatePassword(String password) {
    // used to ensure the password is valid
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(password);
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
          fit: BoxFit.cover,
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
    // returns the page title
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Contact Us",
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

  Widget getLoadingWheel() {
    // shows loading wheel if the page is loading data
    return isLoading ? Center(child: CircularProgressIndicator()) : Container();
  }
}
