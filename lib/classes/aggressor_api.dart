import 'dart:convert';
import 'dart:core';

import 'package:aggressor_adventures/classes/trip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

  Future<List<Trip>> getReservationList(String contactId) async {
    //create and send a reservation list request to the Aggressor Api and return a list of Trip objects also removes duplicates from the received list

    String url =
        "https://secure.aggressor.com/api/app/reservations/list/" + contactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    var response = json.decode(await pageResponse.stream.bytesToString());
    List<String> addedTrips = [];
    List<Trip> tripList = [];
    if (response["status"] == "success") {
      int i = 0;
      while (response[i.toString()] != null) {
        if (!addedTrips
            .contains(response[i.toString()]["reservationid"].toString())) {
          tripList.add(Trip.fromJson(response[i.toString()]));
          addedTrips.add(response[i.toString()]["reservationid"].toString());
          await tripList[tripList.length - 1].getTripDetails(contactId);
        }
        i++;
      }
    } else {
      tripList = null;
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

  Future<dynamic> getSelectContact(String contactId, String userId) async {
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
          'secure.aggressor.com', 'api/app/registration/newcontact/' + userId),
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
}
