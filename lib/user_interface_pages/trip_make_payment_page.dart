import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/aggressor_colors.dart';

class MakePayment extends StatefulWidget {
  MakePayment(this.user, this.trip);

  final User user;
  final Trip trip;

  @override
  State<StatefulWidget> createState() => new MakePaymentState();
}

class MakePaymentState extends State<MakePayment> {
  /*
  instance vars
   */

  int pageIndex = 1;
  String errorMessage = "";
  bool loading = false;

  String cardNumber = "";
  String cardExpirationDate = "";
  String paymentAmount = "";
  String cvv = "";

  final paymentController = MoneyMaskedTextController(
    thousandSeparator: ",",
    decimalSeparator: ".",
  );

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
    return Scaffold(
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
      bottomNavigationBar: getBottomNavigation(),
      body: Stack(
        children: [
          getBackgroundImage(),
          getPageForm(),
          showLoading(),
          Container(
            height: MediaQuery.of(context).size.height / 7 + 4,
            width: double.infinity,
            color: AggressorColors.secondaryColor,
          ),
          getBannerImage(),
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

    double iconSize = MediaQuery.of(context).size.width / 10;
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
  }

  makeCall() async {
    //calls the provided number when clicked
    const url = 'tel:7069932531';
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
  }

  void handleBottomNavigation(int index) {
    //handles what the app does when a bottom navigation bar item is clicked
    currentIndex = index - 1;
    Navigator.pop(context);
  }

  void handlePopupClick(String value) {
    //handles the options in the menu bar
    switch (value) {
      case 'My Profile':
        currentIndex = 5;
        Navigator.pop(context);
    }
  }

  Widget getPageForm() {
    //returns the main contents of the page
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
            getPaymentInformation(),
            getPaymentDetails(),
            showErrorMessage(),
            Container(
              height: 400,
            ),
          ],
        ),
      ),
    );
  }

  Widget getPaymentInformation() {
    //displays the information of what the total is, what trip it is for, and when the payment is due
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height / 6,
                  child: Text(
                    "Trip Destination:",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 45),
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
                      widget.trip.charter.destination,
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.height / 40 - 4),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height / 6,
                  child: Text(
                    "Trip Date:",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 45),
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
                      months[DateTime.parse(widget.trip.charter.startDate)
                                      .month -
                                  1]
                              .substring(0, 3) +
                          " " +
                          DateTime.parse(widget.trip.charter.startDate)
                              .day
                              .toString() +
                          ", " +
                          DateTime.parse(widget.trip.charter.startDate)
                              .year
                              .toString(),
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.height / 40 - 4),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height / 6,
                  child: Text(
                    "Payment due date:",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 45),
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
                      months[DateTime.parse(widget.trip.dueDate).month - 1]
                              .substring(0, 3) +
                          " " +
                          DateTime.parse(widget.trip.dueDate).day.toString() +
                          ", " +
                          DateTime.parse(widget.trip.dueDate).year.toString(),
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.height / 40 - 4),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height / 6,
                  child: Text(
                    "Total due:",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 45),
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
                      double.parse(widget.trip.due) > 0
                          ? double.parse(widget.trip.due).toString()
                          : "0.00",
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.height / 40 - 4),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPaymentDetails() {
    //gets card information and displays what cards we accept
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text(
                  "• Please note, we only accept Visa and Mastercard",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: MediaQuery.of(context).size.height / 60,
                  ),
                ),
              ],
            ),
          ),
          getCardNumber(),
          getCardExpirationDate(),
          getPaymentAmount(),
          getPaymentButton(),
        ],
      ),
    );
  }

  Widget getCardNumber() {
    //returns the field prompting for the email
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
        child: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            CardNumberInputFormatter(),
            LengthLimitingTextInputFormatter(22),
          ],
          decoration: new InputDecoration(
            icon: Icon(Icons.credit_card),
            hintText: "0000  0000  0000  0000",
            labelText: "Card Number",
          ),
          validator: (value) =>
              value.isEmpty ? 'Card Number can\'t be empty' : null,
          onSaved: (value) => cardNumber = value.trim(),
        ),
      ),
    );
  }

  Widget getCardExpirationDate() {
    //returns the field prompting for the email
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CardDateInputFormatter(),
                LengthLimitingTextInputFormatter(7),
              ],
              decoration: new InputDecoration(
                icon: Icon(Icons.date_range),
                hintText: "00/0000",
                labelText: "Expiration Date",
              ),
              validator: (value) =>
                  value.isEmpty ? 'Card Expiration Date can\'t be empty' : null,
              onSaved: (value) => cardExpirationDate = value.trim(),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: new InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: "000",
                  labelText: "CVV",
                ),
                validator: (value) =>
                    value.isEmpty ? 'CVV can\'t be empty' : null,
                onSaved: (value) => cvv = value.trim(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getPaymentAmount() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: paymentController,
        textAlign: TextAlign.center,
        maxLength: 8,
        decoration: new InputDecoration(
          icon: Icon(Icons.attach_money),
          hintText: "0",
          hintStyle: TextStyle(),
          labelText: "Payment Amount",
        ),
        validator: (value) =>
            value.isEmpty ? 'Payment Amount can\'t be empty' : null,
        onSaved: (value) => paymentAmount = value.trim(),
      ),
    );
  }

  Widget getPaymentButton() {
    return TextButton(
      onPressed: () {
        validateAndSubmit();
      },
      child: Text(
        "Make Payment",
        style: TextStyle(color: Colors.white),
      ),
      style:
          TextButton.styleFrom(backgroundColor: AggressorColors.secondaryColor),
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

  Widget showLoading() {
    //displays a loading bar if data is being downloaded
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }

  Widget showErrorMessage() {
    //displays an error message if there is one
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

  Widget getPageTitle() {
    //returns the title of the page
    double iconSize = MediaQuery.of(context).size.width / 10;
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Text(
        "Make Payment",
        style: TextStyle(
            color: AggressorColors.primaryColor,
            fontSize: MediaQuery.of(context).size.height / 26,
            fontWeight: FontWeight.bold),
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

  void validateAndSubmit() async {
    // Perform login or signup
    setState(() {
      errorMessage = "";
      loading = true;
    });

    if (validateAndSave()) {
      try {
        // if (double.parse(widget.trip.due) < double.parse(paymentAmount)) {
        //   throw Exception("You may not pay more than is due.");
        // }
        //
        // if (double.parse(widget.trip.due) <= 0) {
        //   throw Exception("You may not pay for a trip that has nothing due.");
        // }

        cardNumber = cardNumber.replaceAll('  ', '');
        String paymentMonth = cardExpirationDate.substring(0, 2);

        var response = await AggressorApi().makePayment(
            widget.trip.reservationId,
            widget.trip.charterId,
            widget.user.contactId,
            double.parse(paymentAmount).toString(),
            paymentMonth,
            cardExpirationDate.substring(3),
            cardNumber,
            cvv);

        if (response["status"] == "success") {
          showSuccessDialogue();
          widget.trip.updateTripValues();
        } else {
          setState(() {
            errorMessage = response["message"];
          });
        }

        setState(() {
          loading = false;
        });
      } catch (e) {
        print('caught Error: $e');
        setState(() {
          errorMessage = e.message;
          loading = false;
        });
      }
    }
  }
}

void showSuccessDialogue() {
  //shows a dialogue confirming the profile was registered and navigates to the home screen
  showDialog(
    context: navigatorKey.currentContext,
    builder: (_) => new AlertDialog(
      title: new Text('Success'),
      content: new Text("Your payment was successful"),
      actions: <Widget>[
        new TextButton(
            onPressed: () {
              int popCount = 0;
              Navigator.popUntil(navigatorKey.currentContext, (route) {
                return popCount++ == 2;
              });
            },
            child: new Text('Continue')),
      ],
    ),
  );
}

class CardNumberInputFormatter extends TextInputFormatter {
  //automatically updates the format to a credit card format
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

class CardDateInputFormatter extends TextInputFormatter {
  //automatically updates the format to a credit date format
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != text.length) {
        buffer.write('/'); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
