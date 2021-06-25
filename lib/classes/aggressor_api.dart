import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:aggressor_adventures/classes/boat.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/databases/boat_database.dart';
import 'package:aggressor_adventures/databases/charter_database.dart';
import 'package:aggressor_adventures/databases/trip_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class AggressorApi {
  final String apiKey = "pwBL1rik1hyi5JWPid";

  AggressorApi();

  Future<dynamic> getUserLogin(String username, String password) async {
    //create and send a login request to the Aggressor Api and return the current user
    Response response = await post(
      Uri.https('crshome.customphpdesign.com', 'api/app/authentication/login'),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<List<Trip>> getReservationList(
      String contactId, VoidCallback loadingCallBack) async {
    //create and send a reservation list request to the Aggressor Api and return a list of Trip objects also removes duplicates from the received list

    TripDatabaseHelper tripDatabaseHelper = TripDatabaseHelper.instance;
    CharterDatabaseHelper charterDatabaseHelper =
        CharterDatabaseHelper.instance;
    BoatDatabaseHelper boatDatabaseHelper = BoatDatabaseHelper.instance;

    String url =
        "https://crshome.customphpdesign.com/api/app/reservations/list/" + contactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    var response = json.decode(await pageResponse.stream.bytesToString());

    int length = 0;
    while (response[length.toString()] != null) {
      length++;
    }

    loadingLength = length.toDouble();

    List<String> addedTrips = [];
    List<Trip> tripList = [];
    if (response["status"] == "success") {
      int i = 0;
      while (response[i.toString()] != null) {
        Trip newTrip;
        if (!addedTrips
            .contains(response[i.toString()]["reservationid"].toString())) {
          addedTrips.add(response[i.toString()]["reservationid"].toString());
          if (!await tripDatabaseHelper
              .tripExists(response[i.toString()]["reservationid"].toString())) {
            newTrip = Trip.fromJson(response[i.toString()]);
            var detailsResponse = await newTrip.getTripDetails(contactId);

            await tripDatabaseHelper.insertTrip(newTrip);
          } else {
            newTrip = await tripDatabaseHelper
                .getTrip(response[i.toString()]["reservationid"].toString());
          }

          if (!await charterDatabaseHelper.charterExists(newTrip.charterId)) {
            var charterResponse =
                await AggressorApi().getCharter(newTrip.charterId);
            if (charterResponse["status"] == "success") {
              Charter newCharter = Charter(
                  charterResponse["charterid"].toString(),
                  charterResponse["startdate"].toString(),
                  charterResponse["statusid"].toString(),
                  charterResponse["boatid"].toString(),
                  charterResponse["nights"].toString(),
                  charterResponse["itinerary"].toString(),
                  charterResponse["embarkment"].toString(),
                  charterResponse["disembarkment"].toString(),
                  charterResponse["destination"].toString());

              await charterDatabaseHelper.insertCharter(newCharter);

              if (!await boatDatabaseHelper.boatExists(newCharter.boatId)) {
                var boatResponse =
                    await AggressorApi().getBoat(newCharter.boatId);
                if (boatResponse["status"] == "success") {
                  Boat newBoat;

                  newBoat = Boat(
                      boatResponse["boatid"].toString(),
                      boatResponse["name"].toString(),
                      boatResponse["abbreviation"].toString(),
                      boatResponse["boat_email"].toString(),
                      boatResponse["active"].toString(),
                      boatResponse["image"],
                      '',
                      '');

                  await boatDatabaseHelper.insertBoat(newBoat);
                }
              }
            }
          }
        }
        loadingCallBack();
        i++;
      }

      Database db = await tripDatabaseHelper.database;
      List<Map> queryList = await db.rawQuery('SELECT * FROM trip');
      if (queryList.length > 0) {
        tripList = queryList.map((data) => Trip.fromMap(data)).toList();
      } else {
        tripList = [];
      }
    } else {
      tripList = [];
    }

    return tripList;
  }

  Future<dynamic> getReservationDetails(
      String reservationId, String contactId) async {
    //create and send a reservation view request to the Aggressor Api and return json response
    String url = "https://crshome.customphpdesign.com/api/app/reservations/view/" +
        reservationId +
        "/" +
        contactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> getInventoryDetails(
    String reservationId,
  ) async {
    //create and send a inventory view request to the Aggressor Api and return json response
    String url =
        "https://crshome.customphpdesign.com/api/app/reservations/inventory/" +
            reservationId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> getContact(String contactId) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url =
        "https://crshome.customphpdesign.com/api/app/contacts/view/" + contactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> recordPayment(String reservationId, String amount,
      String billingContact, String creditType) async {
    //create and send a payment to be recorded request to the Aggressor Api and return json response
    String url =
        "https://crshome.customphpdesign.com/api/app/payments/record/" + reservationId;

    final requestParams = {
      "amount": amount,
      "billing_contact": billingContact,
      "credit_type": creditType,
    };

    Request request = Request("GET", Uri.parse(url))
      ..body = json.encode(requestParams)
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> sendRegistration(String firstName, String lastName,
      String email, String password, String dateOfBirth) async {
    //sends collected information to the API and sees if there are matching users, returns a userID for future queries
    Response response = await post(
      Uri.https('crshome.customphpdesign.com', 'api/app/registration/register'),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first': firstName,
        'last': lastName,
        'email': email,
        'password': password,
        'dob': dateOfBirth,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> linkContact(String contactId, String userId) async {
    //allows a user to link user to a contact
    String url = "https://crshome.customphpdesign.com/api/app/registration/select/" +
        contactId +
        "/" +
        userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> getCountries() async {
    //returns a list of all countries and their country codes
    String url = "https://crshome.customphpdesign.com/api/app/registration/countries";

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> getStates() async {
    //returns a list of all states and their country codes
    String url = "https://crshome.customphpdesign.com/api/app/registration/states";

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> sendNewContact(
      String userId,
      String address1,
      String address2,
      String city,
      String state,
      String province,
      String country,
      String zip,
      String email,
      String homePhone,
      String mobilePhone,
      String dateOfBirth,
      String gender) async {
    //creates a new contact and returns success on completion
    Response response = await post(
      Uri.https(
          'crshome.customphpdesign.com', "api/app/registration/newcontact/" + userId),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'address1': address1,
        'address2': address2,
        'city': city,
        'state': state,
        'province': province,
        'country': country,
        'zip': zip,
        'email': email,
        'home': homePhone,
        'mobile': mobilePhone,
        'dateOfBirth': dateOfBirth,
        'gender': gender
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> getProfileData(String userId) async {
    //returns the profile data for the userId provided
    String url = "https://crshome.customphpdesign.com/api/app/profile/view/" + userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> saveProfileData(
    String userId,
    String first,
    String last,
    String email,
    String address1,
    String address2,
    String city,
    String state,
    String province,
    String country,
    String zip,
    String username,
    String password,
    String homePhone,
    String workPhone,
    String mobilePhone,
  ) async {
    //saves the updated profile data for the userId provided

    Response response = await post(
      Uri.https('crshome.customphpdesign.com', "api/app/profile/save/" + userId),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: password == null
          ? jsonEncode(<String, dynamic>{
              'first': first,
              'last': last,
              'email': email,
              'address1': address1,
              'address2': address2,
              'city': city,
              'state': state,
              'province': province,
              'country': int.parse(country),
              'zip': zip,
              'username': username,
              'home_phone': homePhone,
              'work_phone': workPhone,
              'mobile_phone': mobilePhone,
            })
          : jsonEncode(<String, dynamic>{
              'first': first,
              'last': last,
              'email': email,
              'address1': address1,
              'address2': address2,
              'city': city,
              'state': state,
              'province': province,
              'country': int.parse(country),
              'zip': int.parse(zip),
              'username': username,
              'password': password,
              'home_phone': homePhone,
              'work_phone': workPhone,
              'mobile_phone': mobilePhone,
            }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> uploadAwsFile(String userId, String gallery, String boatId,
      String filePath, String datePath) async {
    //saves the updated profile data for the userId provided

    String url = "https://crshome.customphpdesign.com/api/app/s3/upload/" +
        userId.toString() +
        "/" +
        gallery +
        "/" +
        boatId.toString() +
        "/" +
        datePath;

    var uri = Uri.parse(url);
    MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers.addEntries([MapEntry('apikey', apiKey)]);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    StreamedResponse response = await request.send();

    var jsonResponse = await json.decode(await response.stream.bytesToString());

    return Map<String, dynamic>.from(jsonResponse);
  }


  Future<dynamic> uploadUserImage(String userId,String filePath) async {
    //saves the updated profile image for the userId provided

    String url = "https://crshome.customphpdesign.com/api/app/profile/avatar/" + userId;

    var uri = Uri.parse(url);
    MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers.addEntries([MapEntry('apikey', apiKey)]);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    StreamedResponse response = await request.send();

    var jsonResponse = await json.decode(await response.stream.bytesToString());

    return Map<String, dynamic>.from(jsonResponse);
  }


  Future<dynamic> downloadAwsFile(String key) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url = "https://crshome.customphpdesign.com/api/app/s3/download/" + key;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    return pageResponse;
  }

  Future<dynamic> deleteAwsFile(String userId, String section, String boatId,
      String date, String fileName) async {
    //delete a file from the aws directories
    String url = "https://crshome.customphpdesign.com/api/app/s3/delete/" +
        userId +
        "/" +
        section +
        "/" +
        boatId +
        "/" +
        date + "/" + fileName.replaceAll("\"", "");
    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var resultJson = json.decode(await pageResponse.stream.bytesToString());
    return pageResponse;
  }

  Future<dynamic> sendForgotPassword(
    String email,
  ) async {
    //saves the updated profile data for the userId provided

    Response response = await post(
        Uri.https(
            'crshome.customphpdesign.com', "api/app/authentication/forgotpassword"),
        headers: <String, String>{
          'apikey': apiKey,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
        }));

    return jsonDecode(response.body);
  }

  Future<dynamic> getCharter(String charterId) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url =
        "https://crshome.customphpdesign.com/api/app/charters/view/" + charterId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());
    return pageJson;
  }

  Future<dynamic> getBoat(String boatId) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url = "https://crshome.customphpdesign.com/api/app/boats/view/" + boatId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());
    return pageJson;
  }

  Future<dynamic> getBoatImage(String url) async {
    //create and send a contact details request to the Aggressor Api and return json response
    Uint8List bytes;
    try {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(url)).load("");
      bytes = imageData.buffer.asUint8List();

      return [bytes];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> checkProfileLink(String userId) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url =
        "https://crshome.customphpdesign.com/api/app/profile/checklinked/" + userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());
    return pageJson;
  }

  Future<dynamic> getBoatList() async {
    //gets the list of boats from the API and adds the maps to the boat list
    String url = "https://crshome.customphpdesign.com/api/app/boats/list";

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    List<dynamic> pageJson =
        json.decode(await pageResponse.stream.bytesToString());

    pageJson.forEach((element) {
      boatList.add(element);
    });

    Map<String, dynamic> selectionTrip = {
      "boatid": -1,
      "name": " -- SELECT -- ",
      "abbreviation": "SEL"
    };
    boatList.insert(0, selectionTrip);
    return boatList;
  }

  Future<dynamic> getRewardsSliderList() async {
    //gets the list of the slider imgaes and downloads the items from the API
    String url = "https://crshome.customphpdesign.com/api/app/s3/slider/list";

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    List<dynamic> pageJson =
        json.decode(await pageResponse.stream.bytesToString());
    List<String> imageNames = [];
    pageJson.forEach((element) {
      if (element != "sliders/") {
        imageNames.add(element);
      }
    });
    return imageNames;
  }

  Future<dynamic> getRewardsSliderImage(String imageName) async {
    //Downloads the image from the database for a slider image
    String url =
        "https://crshome.customphpdesign.com/api/app/s3/slider/download/" + imageName;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    return pageResponse;
  }

  Future<dynamic> getNoteList(String userId) async {
    //gets a list of all the ntoes to be displayed in the app
    notesList.clear();
    String url =
        "https://crshome.customphpdesign.com/api/app/tripnotes/list/" + userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    List<dynamic> pageJson =
        json.decode(await pageResponse.stream.bytesToString());

    return pageJson;
  }

  Future<dynamic> saveNote(
      String startDate,
      String endDate,
      String preTripNotes,
      String postTripNotes,
      String miscNotes,
      String boatId,
      String userId) async {
    //create and send a login request to the Aggressor Api and return the current user

    Response response = await post(
      Uri.https('crshome.customphpdesign.com', 'api/app/tripnotes/save/' + userId),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "boatID": boatId,
        "start_date": startDate,
        "end_date": endDate,
        "pre_trip_notes": preTripNotes,
        "post_trip_notes": postTripNotes,
        "misc": miscNotes,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> updateNote(
      String startDate,
      String endDate,
      String preTripNotes,
      String postTripNotes,
      String miscNotes,
      String boatId,
      String userId,
      String id) async {
    //create and send a login request to the Aggressor Api and return the current user
    Response response = await post(
      Uri.https('crshome.customphpdesign.com',
          'api/app/tripnotes/update/' + userId + '/' + id),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "boatID": boatId,
        "start_date": startDate,
        "end_date": endDate,
        "pre_trip_notes": preTripNotes,
        "post_trip_notes": postTripNotes,
        "misc": miscNotes,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> deleteNote(String userId, String id) async {
    //create and send a login request to the Aggressor Api and return the current user
    Response response = await post(
      Uri.https('crshome.customphpdesign.com',
          'api/app/tripnotes/delete/' + userId + '/' + id),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> getIronDiverList(String userId) async {
    //gets the list of iron diver awards for the given user from the API
    notesList.clear();
    String url =
        "https://crshome.customphpdesign.com/api/app/club/irondiver/list/" + userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    List<dynamic> pageJson =
        json.decode(await pageResponse.stream.bytesToString());

    return pageJson;
  }

  Future<dynamic> saveIronDiver(String userId, String boatId) async {
    //Save a new iron diver award to a specific boat
    Response response = await post(
      Uri.https(
          'crshome.customphpdesign.com', '/api/app/club/irondiver/save/' + userId),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "boatID": boatId,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> deleteIronDiver(String userId, String id) async {
    //delete an iron diver award by a certain id
    notesList.clear();
    String url = "https://crshome.customphpdesign.com/api/app/club/irondiver/delete/" +
        userId +
        "/" +
        id;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());

    return pageJson;
  }

  Future<dynamic> getCertificationList(String userId) async {
    //gets the certificates for a particular user from the API
    notesList.clear();
    String url =
        "https://crshome.customphpdesign.com/api/app/club/certifications/list/" +
            userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    List<dynamic> pageJson =
        json.decode(await pageResponse.stream.bytesToString());

    return pageJson;
  }

  Future<dynamic> saveCertification(
      String userId, String certificationType) async {
    //save a new certification with a certain certification type to the user
    Response response = await post(
      Uri.https('crshome.customphpdesign.com',
          '/api/app/club/certifications/save/' + userId),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "certificationType": certificationType,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> deleteCertification(String userId, String id) async {
    //delete a certification by a certain id
    notesList.clear();
    String url =
        "https://crshome.customphpdesign.com/api/app/club/certifications/delete/" +
            userId +
            "/" +
            id;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());

    return pageJson;
  }

  Future<dynamic> makePayment(
      String reservationId,
      String charterId,
      String contactId,
      String paymentAmount,
      String creditCardMonth,
      String creditCardYear,
      String creditCardNumber,
      String cvv) async {
    //make a card payment

    var paymentBody = {
      "payment_amount": paymentAmount,
      "credit_card_month": creditCardMonth,
      "credit_card_year": creditCardYear,
      "credit_card_number": creditCardNumber,
      "credit_card_cvv": cvv,
    };

    String url = 'https://crshome.customphpdesign.com/api/app/payments/credit/' +
        reservationId +
        '/' +
        charterId +
        '/' +
        contactId;

    MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addEntries([MapEntry('apikey', apiKey)]);
    request.fields.addAll(paymentBody);
    StreamedResponse response = await request.send();

    var jsonResponse = await json.decode(await response.stream.bytesToString());

    return jsonResponse;
  }

  Future<dynamic> saveDatabase(String userId, String databaseName) async {

    String region = "us-east-1";
    String bucketId = "aggressor.app.user.images";
    final AwsS3Client s3client = AwsS3Client(
        region: region,
        host: "s3.$region.amazonaws.com",
        bucketId: bucketId,
        accessKey: "AKIA43MMI6CI2KP4CUUY",
        secretKey: "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");

    final dataDir = await getApplicationDocumentsDirectory();
    var databaseValue = dataDir.path + "/" + databaseName;
      try {
        final zipFile = File(databaseValue);

        String databasePath =
            userId + "/config/databases/filesDatabase/";
        var resList =
        await s3client.listObjects(prefix: databasePath, delimiter: "/");
        try {
          for (var value in resList.contents) {
            if(double.parse(value.size) > 0) {
              var res = await deleteAwsFile(
                  userId, "config", "databases", "filesDatabase",
                  value.key.substring(value.key.lastIndexOf("/") + 1));
            }
          }
        }catch(e){
          print("empty data file");
        }
        var key = await uploadAwsFile(
          userId,
          "config",
          "databases",
          zipFile.path,
            "filesDatabase",
        );
      } catch (e) {
        print(e);
      }
  }
}
