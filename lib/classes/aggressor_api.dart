import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
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
import 'package:http/http.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class AggressorApi {
  final String apiKey = "pwBL1rik1hyi5JWPid";

  AggressorApi();

  Future<dynamic> getUserLogin(String username, String password) async {
    //create and send a login request to the Aggressor Api and return the current user
    Response response = await post(
      Uri.https('secure.aggressor.com', 'api/app/authentication/login'),
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

  Future<List<Trip>> getReservationList(String contactId, VoidCallback loadingCallBack) async {
    //create and send a reservation list request to the Aggressor Api and return a list of Trip objects also removes duplicates from the received list

    TripDatabaseHelper tripDatabaseHelper = TripDatabaseHelper.instance;
    CharterDatabaseHelper charterDatabaseHelper =
        CharterDatabaseHelper.instance;
    BoatDatabaseHelper boatDatabaseHelper = BoatDatabaseHelper.instance;

    String url =
        "https://secure.aggressor.com/api/app/reservations/list/" + contactId;

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
            await newTrip.getTripDetails(contactId);
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
                  //TODO get boat image here

                  Boat newBoat;

                  var imageDetails = await getBoatImage(boatResponse["image"]);
                  if (imageDetails != null) {

                    var imageName = boatResponse["image"].substring(boatResponse["image"].toString().lastIndexOf("/") + 1);

                    Directory appDocumentsDirectory =
                        await getApplicationDocumentsDirectory();
                    String appDocumentsPath = appDocumentsDirectory.path;
                    String filePath = '$appDocumentsPath/$imageName';
                    print(filePath);
                    File tempFile = await File(filePath).writeAsBytes(imageDetails[0]);

                    print(boatResponse.toString());
                    newBoat = Boat(
                        boatResponse["boatid"].toString(),
                        boatResponse["name"].toString(),
                        boatResponse["abbreviation"].toString(),
                        boatResponse["boat_email"].toString(),
                        boatResponse["active"].toString(),
                        tempFile.path);
                  } else {
                    newBoat = Boat(
                        boatResponse["boatid"].toString(),
                        boatResponse["name"].toString(),
                        boatResponse["abbreviation"].toString(),
                        boatResponse["boat_email"].toString(),
                        boatResponse["active"].toString(),
                        "");
                  }

                  await boatDatabaseHelper.insertBoat(newBoat);
                }
              }
            }
          }
          await newTrip.initCharterInformation();
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
    String url = "https://secure.aggressor.com/api/app/reservations/view/" +
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
        "https://secure.aggressor.com/api/app/reservations/inventory/" +
            reservationId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> getContact(String contactId) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url =
        "https://secure.aggressor.com/api/app/contacts/view/" + contactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> recordPayment(String reservationId, String amount,
      String billingContact, String creditType) async {
    //create and send a payment to be recorded request to the Aggressor Api and return json response
    String url =
        "https://secure.aggressor.com/api/app/payments/record/" + reservationId;

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
      Uri.https('secure.aggressor.com', 'api/app/registration/register'),
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
    String url = "https://secure.aggressor.com/api/app/registration/select/" +
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
    String url = "https://secure.aggressor.com/api/app/registration/countries";

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> getStates() async {
    //returns a list of all states and their country codes
    String url = "https://secure.aggressor.com/api/app/registration/states";

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
          'secure.aggressor.com', "api/app/registration/newcontact/" + userId),
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
    String url = "https://secure.aggressor.com/api/app/profile/view/" + userId;

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
      Uri.https('secure.aggressor.com', "api/app/profile/save/" + userId),
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
              'zip': int.parse(zip),
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

  Future<dynamic> uploadAwsFile(
      String userId, String gallery, String charterId, String filePath) async {
    //saves the updated profile data for the userId provided

    String url = "https://secure.aggressor.com/api/app/gallery/upload/" +
        userId.toString() +
        "/" +
        gallery +
        "/" +
        charterId.toString();

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
    String url = "https://secure.aggressor.com/api/app/gallery/download/" + key;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    return pageResponse;
  }

  Future<dynamic> sendForgotPassword(
    String email,
  ) async {
    //saves the updated profile data for the userId provided

    Response response = await post(
        Uri.https(
            'secure.aggressor.com', "api/app/authentication/forgotpassword"),
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
        "https://secure.aggressor.com/api/app/charters/view/" + charterId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());
    return pageJson;
  }

  Future<dynamic> getBoat(String boatId) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url = "https://secure.aggressor.com/api/app/boats/view/" + boatId;

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

      final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load("");
      bytes = imageData.buffer.asUint8List();

      return [bytes];


    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future<dynamic> checkProfileLink(String userId) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url = "https://secure.aggressor.com/api/app/profile/checklinked/" + userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());
    return pageJson;
  }
}
