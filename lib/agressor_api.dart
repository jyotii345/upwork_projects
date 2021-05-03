import 'dart:convert';

import 'package:aggressor_adventures/trip.dart';
import 'package:http/http.dart';

class AggressorApi {
  final String apiKey = "pwBL1rik1hyi5JWPid";

  AggressorApi();

  Future<dynamic> getUserLogin(String username, String password) async { //TODO GET call switched to POST call in API update
    //create and send a login request to the Aggressor Api and return json response
    final requestParams = {
      "username": username,
      "password": password,
    };

    Request request = Request("GET",
        Uri.parse("https://secure.aggressor.com/api/app/authentication/login"))
      ..body = json.encode(requestParams)
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<List<Trip>> getReservationList(String contactId) async {
    //create and send a reservation list request to the Aggressor Api and return a list of Trip objects
    String url =
        "https://secure.aggressor.com/api/app/reservations/list/" + contactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    var response = json.decode(await pageResponse.stream.bytesToString());
    List<Trip> tripList = [];
    if (response["status"] == "success") {
      int i = 0;
      while (response[i.toString()] != null) {
        tripList.add(Trip.fromJson(response[i.toString()]));
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
}
