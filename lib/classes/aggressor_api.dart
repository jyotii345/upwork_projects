import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:aggressor_adventures/classes/boat.dart';
import 'package:aggressor_adventures/classes/charter.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/databases/boat_database.dart';
import 'package:aggressor_adventures/databases/charter_database.dart';
import 'package:aggressor_adventures/databases/trip_database.dart';
import 'package:aggressor_adventures/model/countries.dart';
import 'package:aggressor_adventures/model/emergencyContactModel.dart';
import 'package:aggressor_adventures/model/inventoryDetails.dart';
import 'package:aggressor_adventures/model/rentalModel.dart';
import 'package:aggressor_adventures/model/travelInformationModel.dart';
import 'package:aggressor_adventures/model/userModel.dart';
import 'package:aggressor_adventures/user_interface_pages/Guest%20information%20System/model/masterModel.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/basicInfoModel.dart';
import '../model/divingInsurance.dart';
import '../model/tripInsuranceModel.dart';
import '../model/welcomePageModel.dart';
import '../user_interface_pages/Guest information System/model/formStatusModel.dart';
import '../user_interface_pages/widgets/download.dart';
import '../user_interface_pages/widgets/toaster.dart';
import 'messages.dart';

class AggressorApi {
  final String apiKey = "L9F6ZJ00CKFJ4Z!";

  Future<dynamic> getUserLogin(String username, String password) async {
    //create and send a login request to the Aggressor Api and return the current user
    Response response = await post(
      Uri.https('app.aggressor.com', 'api/app/authentication/login'),
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
        "https://app.aggressor.com/api/app/reservations/list/" + contactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    var response = json.decode(await pageResponse.stream.bytesToString());
    print(response);
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

          if (newTrip.charterId == null ||
              !await charterDatabaseHelper.charterExists(newTrip.charterId!)) {
            var charterResponse =
                await AggressorApi().getCharter(newTrip.charterId!);
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

              if (!await boatDatabaseHelper.boatExists(newCharter.boatId!)) {
                var boatResponse =
                    await AggressorApi().getBoat(newCharter.boatId!);
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

        // percent+=0.01;
        percent = i / loadingLength;
        // loadingCallBack();
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
    String url = "https://app.aggressor.com/api/app/reservations/view/" +
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
    String url = "https://app.aggressor.com/api/app/reservations/inventory/" +
        reservationId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> getContact(String contactId) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url = "https://app.aggressor.com/api/app/contacts/view/" + contactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<dynamic> recordPayment(String reservationId, String amount,
      String billingContact, String creditType) async {
    //create and send a payment to be recorded request to the Aggressor Api and return json response
    String url =
        "https://app.aggressor.com/api/app/payments/record/" + reservationId;

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
      Uri.https('app.aggressor.com', 'api/app/registration/register'),
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

  Future<dynamic> sendRegistrationCondensed(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    //sends collected information to the API and sees if there are matching users, returns a userID for future queries
    Response response = await post(
      Uri.https('app.aggressor.com', 'api/app/registration/register'),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first': firstName,
        'last': lastName,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<dynamic> linkContact(String contactId, String userId) async {
    //allows a user to link user to a contact
    String url = "https://app.aggressor.com/api/app/registration/select/" +
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
    String url = "https://app.aggressor.com/api/app/registration/countries";

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<List<MasterModel>> getCountriesList() async {
    //returns a list of all countries and their country codes
    List<MasterModel> countriesList = [];
    String url = "https://app.aggressor.com/api/app/registration/countries";

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    var response = jsonDecode(await pageResponse.stream.bytesToString());
    for (var country in response) {
      countriesList.add(
          MasterModel(id: country['countryid'], title: country['country']));
    }
    listOfCountries = countriesList;
    return countriesList;
  }

  Future<bool> postGuestInformation(
      {required String contactId, required BasicInfoModel userInfo}) async {
    bool isUserDataUpdated = false;
    String url =
        "https://app.aggressor.com/api/gis/guestinformation/AF/$contactId";

    var userJson = userInfo.toJson();
    print(userJson);
    try {
      Response response = await post(Uri.parse(url),
          headers: <String, String>{
            'apikey': apiKey,
          },
          body: userJson);
      if (json.decode(response.body)['status'] == 'success') {
        isUserDataUpdated = true;
      }
    } catch (e) {
      print(e);
    }
    return isUserDataUpdated;
  }

  Future postEmergencyContact(
      {required String contactId,
      required EmergencyContactModel userInfo}) async {
    String url =
        "https://app.aggressor.com/api/gis/emergencycontact/AF/$contactId";

    var userJson = userInfo.toJson();
    print(userJson);
    try {
      Response response = await post(Uri.parse(url),
          headers: <String, String>{
            'apikey': apiKey,
          },
          body: userJson);
      print(response);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> postWaiverForm(
      {required String contactId,
      required String reservationID,
      String? charID,
      var ipAddress}) async {
    bool isWaiverPosted = false;
    String url =
        "https://app.aggressor.com/api/gis/waiverv2/$contactId/$reservationID/$charID";

    try {
      Response response = await post(Uri.parse(url), headers: <String, String>{
        'apikey': apiKey,
      }, body: {
        "ip_address": ipAddress
      });
      Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (decodedResponse['status'] == 'success') {
        isWaiverPosted = true;
      }
    } catch (e) {
      print(e);
    }
    return isWaiverPosted;
  }

  Future downloadWaiver({required String contactId, String? charID}) async {
    String url =
        "https://app.aggressor.com/api/gis/artifact/AF/$contactId/$charID/waiver";

    try {
      String filePath =
          await Download().downloadFile(fileURL: url, fileName: "File");
      if (filePath.isNotEmpty) {
        Toaster.showSuccess("Download completed");
        OpenFile.open(filePath);
      } else {
        Toaster.showError("Unable to download PDF, please try again.");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> updatingStatus(
      {required String column, String? contactID, String? charID}) async {
    bool isStatusUpdated = false;
    String url =
        "https://app.aggressor.com/api/gis/updatestatus/AF/${basicInfoModel.contactID}/${welcomePageDetails.charterid}/$column";
    try {
      Response response = await get(Uri.parse(url), headers: <String, String>{
        'apikey': apiKey,
      });
      if (response.statusCode == 200) {
        isStatusUpdated = true;
      }
    } catch (e) {
      print(e);
    }
    return isStatusUpdated;
  }

  getFormStatus({String? contactId, String? charterId}) async {
    String url =
        'https://app.aggressor.com/api/gis/getformstatus/AF/${basicInfoModel.contactID}/${welcomePageDetails.charterid}';
    try {
      Response response = await get(Uri.parse(url), headers: <String, String>{
        'apikey': apiKey,
      });
      if (response.statusCode == 200) {
        List decodedResponse = json.decode(response.body);
        form_status = FormStatusModel.fromJson(decodedResponse[0]);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getStates() async {
    //returns a list of all states and their country codes
    String url = "https://app.aggressor.com/api/app/registration/states";

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<List<MasterModel>> getStatesList() async {
    //returns a list of all countries and their country codes
    List<MasterModel> statesList = [];
    String url = "https://app.aggressor.com/api/app/registration/states";

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    var response = jsonDecode(await pageResponse.stream.bytesToString());

    for (var i = 0; i < response.length; i++) {
      statesList.add(MasterModel(
          title: response[i]['state'], abbv: response[i]['stateAbbr'], id: i));
    }

    // for (var states in response) {
    //   statesList
    //       .add(MasterModel(title: states['state'], abbv: states['stateAbbr'], id: ));
    // }
    listOfStates = statesList;
    return statesList;
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
          'app.aggressor.com', "api/app/registration/newcontact/" + userId),
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

  Future<dynamic> sendNewContactCondensed(
      String userId, String name, String email, String password) async {
    //creates a new contact and returns success on completion
    Response response = await post(
      Uri.https(
          'app.aggressor.com', "api/app/registration/newcontact/" + userId),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> getProfileData(String userId) async {
    //returns the profile data for the userId provided
    String url = "https://app.aggressor.com/api/app/profile/view/" + userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    var userJson = jsonDecode(await pageResponse.stream.bytesToString());
    userModel = UserModel.fromJson(userJson);
    return userJson;
  }

  Future<BasicInfoModel> getBasicDetails({String? contactId}) async {
    String newContactId = contactId ?? basicInfoModel.contactID!;
    //returns the profile data for the userId provided
    String url = "https://app.aggressor.com/api/gis/contacts/" + newContactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    var userJson = jsonDecode(await pageResponse.stream.bytesToString());
    basicInfoModel = BasicInfoModel.fromJson(userJson);
    return basicInfoModel;
  }

  Future<String?> getDietaryRestrictions({required String contactId}) async {
    String url =
        'https://app.aggressor.com/api/gis/dietaryrestrictions/$contactId';
    String? dietaryInformation;
    try {
      Response response = await get(Uri.parse(url), headers: <String, String>{
        'apikey': apiKey,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        print(decodedResponse);
        dietaryInformation = decodedResponse['0']['specialPassengerDetails'];
      }
    } catch (e) {
      print(e);
    }
    return dietaryInformation;
  }

  getInventoryDetail({required String? reservationId}) async {
    String url =
        'https://app.aggressor.com/api/app/reservations/inventory/$reservationId';
    Response response = await get(Uri.parse(url), headers: <String, String>{
      'apikey': apiKey,
      "Content-Type": "application/x-www-form-urlencoded"
    });

    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        inventoryDetails = InventoryDetails.fromJson(decodedResponse['0']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<RentalModel> getRentalAndCoursesDetails() async {
    RentalModel rentalModel = RentalModel();
    String url =
        'https://app.aggressor.com/api/gis/rentalscourses/${welcomePageDetails.inventoryid}';
    Response response = await get(Uri.parse(url), headers: <String, String>{
      'apikey': apiKey,
      "Content-Type": "application/x-www-form-urlencoded"
    });
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        rentalModel = RentalModel.fromJson(decodedResponse);
      }
    } catch (e) {
      print(e);
    }
    return rentalModel;
  }

  Future getTravelInformation() async {
    List<TravelInformationModel> travelInformation = [];
    String url =
        'https://app.aggressor.com/api/gis/flightsv2/${basicInfoModel.contactID}/${welcomePageDetails.charterid}';
    try {
      Response response = await get(Uri.parse(url), headers: <String, String>{
        'apikey': apiKey,
      });

      if (response.statusCode == 200) {
        print(response.body);
        var decodedResponse = json.decode(response.body);
        for (var data in decodedResponse) {
          travelInformation.add(TravelInformationModel.fromJson(data));
        }
      }
    } catch (e) {
      print(e);
    }
    return travelInformation;
  }

  getWelcomePageInfo(
      {required String contactId,
      required charterId,
      required String reservationId}) async {
    String url =
        'https://app.aggressor.com/api/gis/authenticate/AF/$contactId/$reservationId/$charterId/f082784c136c6b565a88184e3689413a';
    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});
    try {
      StreamedResponse pageResponse = await request.send();
      var response = jsonDecode(await pageResponse.stream.bytesToString());
      welcomePageDetails = WelcomePageModel.fromJson(response);
    } catch (e) {
      print(e);
    }
  }

  deleteTravelInformation(
      {required String contactId, required int flightId}) async {
    String url = 'https://app.aggressor.com/api/gis/deleteflight/AF/$contactId';
    try {
      Response response = await post(Uri.parse(url), headers: <String, String>{
        'apikey': apiKey,
      }, body: {
        'flightID': flightId.toString()
      });
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  updateTravelInformation(
      {required String contactId,
      required TravelInformationModel travelInfo}) async {
    String url = 'https://app.aggressor.com/api/gis/updateflight/AF/$contactId';
    var userJson = travelInfo.toJson();
    print(userJson);
    try {
      Response response = await post(Uri.parse(url),
          headers: <String, String>{
            'apikey': apiKey,
          },
          body: userJson);
      print(response);
    } catch (e) {
      print(e);
    }
  }

  postTravelInformation(
      {required String contactId,
      required charterId,
      required TravelInformationModel travelInfo}) async {
    String url =
        'https://app.aggressor.com/api/gis/saveflight/AF/${contactId}/$charterId';
    var userJson = travelInfo.toJson();
    print(userJson);
    try {
      Response response = await post(Uri.parse(url),
          headers: <String, String>{
            'apikey': apiKey,
          },
          body: userJson);
      print(response);
    } catch (e) {
      print(e);
    }
  }

  postRentalAndCoursesDetails({
    required int? inventoryId,
    String? courses,
    String? rentals,
    String? otherText,
  }) async {
    String url =
        'https://app.aggressor.com/api/gis/rentalscourses/AF/$inventoryId';

    try {
      Response response = await post(Uri.parse(url), headers: <String, String>{
        'apikey': apiKey,
      }, body: {
        'rental_equipment[]': rentals,
        'course[]': courses,
        'other_rental': otherText,
      });
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> postDivingInsuranceDetails(
      {required DivingInsuranceModel divingInfo}) async {
    bool isDataUpdated = false;
    String url =
        "https://app.aggressor.com/api/gis/diveinsurance/AF/${welcomePageDetails.inventoryid}";

    var userJson = divingInfo.toJson();
    try {
      Response response = await post(Uri.parse(url),
          headers: <String, String>{
            'apikey': apiKey,
          },
          body: userJson);
      if (response.statusCode == 200) {
        isDataUpdated = true;
      }
    } catch (e) {
      print(e);
    }
    return isDataUpdated;
  }

  Future<bool> postTripInsuranceDetails(
      {required TripInsuranceModel insuranceData}) async {
    bool isUpdated = false;
    String url =
        "https://app.aggressor.com/api/gis/tripinsurance/AF/${welcomePageDetails.inventoryid}";
    var userJson = insuranceData.toJson();
    print(userJson);
    try {
      Response response = await post(Uri.parse(url),
          headers: <String, String>{
            'apikey': apiKey,
          },
          body: userJson);
      if (response.statusCode == 200) {
        isUpdated = true;
      }
    } catch (e) {
      print(e);
    }
    return isUpdated;
  }

  Future<DivingInsuranceModel?> getDivingInsuranceDetails() async {
    DivingInsuranceModel? divingInsuranceModel;
    String url =
        "https://app.aggressor.com/api/gis/diveinsurance/${welcomePageDetails.inventoryid}";
    Response response = await get(Uri.parse(url), headers: <String, String>{
      'apikey': apiKey,
      "Content-Type": "application/json"
    });
    try {
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        divingInsuranceModel =
            DivingInsuranceModel.fromJson(decodedResponse['0']);
      }
    } catch (e) {
      print(e);
    }
    return divingInsuranceModel;
  }

  Future<TripInsuranceModel?> getTripInsuranceDetails() async {
    TripInsuranceModel? tripInsuranceModel;
    String url =
        "https://app.aggressor.com/api/gis/tripinsurance/${welcomePageDetails.inventoryid}";
    Response response = await get(Uri.parse(url), headers: <String, String>{
      'apikey': apiKey,
      "Content-Type": "application/json"
    });
    try {
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        tripInsuranceModel = TripInsuranceModel.fromJson(decodedResponse['0']);
      }
    } catch (e) {
      print(e);
    }
    return tripInsuranceModel;
  }

  getEmergencyContactDetails({required String contactId}) async {
    String url = "https://app.aggressor.com/api/gis/contacts/$contactId";
    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});
    try {
      StreamedResponse pageResponse = await request.send();
      var response = jsonDecode(await pageResponse.stream.bytesToString());
      emergencyContact = EmergencyContactModel.fromJson(response);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> savingDietaryRestrictions(
      {required String contactId, required String information}) async {
    bool isDietaryInformationSaved = false;
    String url =
        'https://app.aggressor.com/api/gis/dietaryrestrictions/AF/$contactId';
    try {
      Response response = await post(Uri.parse(url), headers: <String, String>{
        'apikey': apiKey,
      }, body: {
        'special_passenger_details': information
      });
      if (response.statusCode == 200) {
        isDietaryInformationSaved = true;
      }
    } catch (e) {
      print(e);
    }
    return isDietaryInformationSaved;
  }

  Future<dynamic> sendEmail(
    String fName,
    String lName,
    String email,
    String body,
  ) async {
    try {
      Response response = await post(
          Uri.https('app.aggressor.com', 'api/app/contactus/'),
          headers: <String, String>{
            'apikey': apiKey,
          },
          body: jsonEncode({
            "first": "$fName",
            "last": "$lName",
            "email": "$email",
            "body": "$body"
          }));

      var data = jsonDecode(response.body);
      print(data);
      return data;
      // return {"status":"success"};
    } catch (e) {
      return "Error sending mail, please try again.";
    }
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
    String timeZone,
    String zip,
    String username,
    String? password,
    String homePhone,
    String workPhone,
    String mobilePhone,
  ) async {
    //saves the updated profile data for the userId provided

    Response response = await post(
      Uri.https('app.aggressor.com', "api/app/profile/save/" + userId),
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
              'time_zone': timeZone,
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
              'time_zone': timeZone,
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

  Future<dynamic> downloadUserImage(String userId, userImageName) async {
    var res =
        await downloadAwsFile(userId + "/profile/crs/app/" + userImageName);
    return res;
  }

  Future<dynamic> uploadAwsFile(String userId, String gallery, String boatId,
      String filePath, String datePath) async {
    //saves the updated profile data for the userId provided

    String url = "https://app.aggressor.com/api/app/s3/upload/" +
        userId.toString() +
        "/" +
        gallery +
        "/" +
        boatId.toString() +
        "/" +
        datePath;

    File(filePath);

    var uri = Uri.parse(url);
    MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers.addEntries([MapEntry('apikey', apiKey)]);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    StreamedResponse response = await request.send();

    var jsonResponse = await json.decode(await response.stream.bytesToString());

    return Map<String, dynamic>.from(jsonResponse);
  }

  Future<dynamic> uploadUserImage(String userId, String filePath) async {
    //saves the updated profile image for the userId provided

    String url = "https://app.aggressor.com/api/app/profile/avatar/" + userId;

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
    String url = "https://app.aggressor.com/api/app/s3/download/" + key;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    return pageResponse;
  }

  Future<dynamic> deleteAwsFile(String userId, String section, String boatId,
      String date, String fileName) async {
    //delete a file from the aws directories
    String url = "https://app.aggressor.com/api/app/s3/delete/" +
        userId +
        "/" +
        section +
        "/" +
        boatId +
        "/" +
        date +
        "/" +
        fileName.replaceAll("\"", "");
    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    json.decode(await pageResponse.stream.bytesToString());
    return pageResponse;
  }

  Future<dynamic> sendForgotPassword(
    String email,
  ) async {
    //saves the updated profile data for the userId provided

    Response response = await post(
        Uri.https('app.aggressor.com', "api/app/authentication/forgotpassword"),
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
    String url = "https://app.aggressor.com/api/app/charters/view/" +
        charterId.toString();

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());
    return pageJson;
  }

  Future<dynamic> getBoat(String boatId) async {
    //create and send a contact details request to the Aggressor Api and return json response
    String url = "https://app.aggressor.com/api/app/boats/view/" + boatId;

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
        "https://app.aggressor.com/api/app/profile/checklinked/" + userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());
    return pageJson;
  }

  Future<dynamic> getBoatList() async {
    //gets the list of boats from the API and adds the maps to the boat list
    String url = "https://app.aggressor.com/api/app/boats/list";

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
    String url = "https://app.aggressor.com/api/app/s3/slider/list";

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
        "https://app.aggressor.com/api/app/s3/slider/download/" + imageName;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    return pageResponse;
  }

  Future<dynamic> getNoteList(String userId) async {
    //gets a list of all the ntoes to be displayed in the app
    notesList.clear();
    String url = "https://app.aggressor.com/api/app/tripnotes/list/" + userId;

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
      String boatId,
      String userId) async {
    //create and send a login request to the Aggressor Api and return the current user

    Response response = await post(
      Uri.https('app.aggressor.com', 'api/app/tripnotes/save/' + userId),
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
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> updateNote(
      String startDate,
      String endDate,
      String preTripNotes,
      String postTripNotes,
      String boatId,
      String userId,
      String id) async {
    //create and send a login request to the Aggressor Api and return the current user
    Response response = await post(
      Uri.https(
          'app.aggressor.com', 'api/app/tripnotes/update/' + userId + '/' + id),
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
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> deleteNote(String userId, String id) async {
    //create and send a login request to the Aggressor Api and return the current user
    Response response = await post(
      Uri.https(
          'app.aggressor.com', 'api/app/tripnotes/delete/' + userId + '/' + id),
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
        "https://app.aggressor.com/api/app/club/irondiver/list/" + userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    List<dynamic> pageJson =
        json.decode(await pageResponse.stream.bytesToString());

    return pageJson;
  }

  Future<dynamic> storeFCMToken(String contactID, String fcmToken) async {
    String deviceType = (Platform.isAndroid) ? "Android" : "IOS";

    Response response = await post(
      Uri.https('app.aggressor.com', '/api/app/fcmtoken/save/' + contactID),
      headers: <String, String>{
        'apikey': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"deviceType": deviceType, "fcmToken": fcmToken}),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> saveIronDiver(String userId, String boatId) async {
    //Save a new iron diver award to a specific boat
    Response response = await post(
      Uri.https('app.aggressor.com', '/api/app/club/irondiver/save/' + userId),
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
    String url = "https://app.aggressor.com/api/app/club/irondiver/delete/" +
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
        "https://app.aggressor.com/api/app/club/certifications/list/" + userId;

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
      Uri.https(
          'app.aggressor.com', '/api/app/club/certifications/save/' + userId),
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
        "https://app.aggressor.com/api/app/club/certifications/delete/" +
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

    String url = 'https://app.aggressor.com/api/app/payments/credit/' +
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

      String databasePath = userId + "/config/databases/filesDatabase/";
      var resList =
          await s3client.listObjects(prefix: databasePath, delimiter: "/");
      try {
        for (var value in resList!.contents!) {
          if (double.parse(value.size!) > 0) {
            await deleteAwsFile(userId, "config", "databases", "filesDatabase",
                value.key!.substring(value.key!.lastIndexOf("/") + 1));
          }
        }
      } catch (e) {
        print("empty data file");
      }
      await uploadAwsFile(
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

  Future<dynamic> getAllStar(
    String contactId,
  ) async {
    //delete a certification by a certain id
    notesList.clear();
    String url = "https://app.aggressor.com/api/app/allstars/list/" + contactId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());

    return pageJson;
  }

  Future<dynamic> redeemPoints(String userId, int points) async {
    //redeem points for a coupon
    notesList.clear();
    String url = "https://app.aggressor.com/api/app/boutique/redeem/" +
        userId +
        "/" +
        points.toString();

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());

    return pageJson;
  }

  Future<dynamic> getCoupons(
    String userId,
  ) async {
    // get the coupons from the API
    notesList.clear();
    String url = "https://app.aggressor.com/api/app/boutique/list/" + userId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();

    var pageJson = json.decode(await pageResponse.stream.bytesToString());

    return pageJson;
  }

  Future<dynamic> getReelsList() async {
    // allows a user to link user to a contact
    String url = 'https://app.aggressor.com/api/app/reels/list';
    // String url = 'https://app.aggressor.com/api/app/reels/list';

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey, "Content-Type": "application/json"});

    StreamedResponse pageResponse = await request.send();
    return jsonDecode(await pageResponse.stream.bytesToString());
  }

  Future<Uint8List> getReelImage(String imageId, String imageName) async {
    // allows a user to link user to a contact
    String url = 'https://app.aggressor.com/api/app/reels/image/' + imageId;

    Request request = Request("GET", Uri.parse(url))
      ..headers.addAll({"apikey": apiKey});

    StreamedResponse pageResponse = await request.send();

    // var byte = await pageResponse.stream;
    var bytes = await readByteStream(pageResponse.stream);

    imageName = imageName.toLowerCase();
    print(imageId);
    print(imageName);
    print("getting image^");

    // File imageFile = File((await getApplicationDocumentsDirectory()).path +
    //     "/$imageName" +
    //     "_" +
    //     getRandString(10));

    // await imageFile.writeAsBytes(bytes);
    // print(imageFile.lengthSync());

    return bytes;
  }

  Future<File> getReelVideo(String videoId, String videoName) async {
    // allows a user to link user to a contact

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    videoName = videoName.toLowerCase();
    File file = new File('$tempPath/$videoName');

    try {
      if (file.lengthSync() != 0) {
        return file;
      }
    } catch (e) {}
    print("loading video stream");
    String url = 'https://app.aggressor.com/api/app/reels/stream/' + videoId;

    print(url);

    final response = await http.get(
      Uri.parse(url),
      headers: {"apikey": apiKey},
    );

    await file.writeAsBytes(response.bodyBytes);

    print(await file.length());
    return file;
  }

  Future<dynamic> increaseReelCounter(String reelId) async {
    print("loading video stream");
    String url = 'https://app.aggressor.com/api/app/reels/counter/' + reelId;

    print(url);

    final response = await http.get(
      Uri.parse(url),
      headers: {"apikey": apiKey},
    );

    return response.body;
  }

  Future<bool> sendMessage(String uId) async {
    try {
      Response response = await post(
          Uri.https('app.aggressor.com', 'api/notifications/new/27'),
          headers: <String, String>{
            'apikey': apiKey,
          },
          body: {
            "title": "$uId",
            "sub_title": "$uId",
            "body": "$uId",
            "show_in_app": "yes",
            "message_body": "$uId",
          });

      var data = jsonDecode(response.body);
      print(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Message>> getAllMessages(String contactId) async {
    try {
      List<Message> message = [];
      Response response = await get(
        Uri.https('app.aggressor.com', 'api/app/inbox/list/$contactId'),
        headers: <String, String>{
          'apikey': apiKey,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);
      await Future.forEach(
          data, (element) => message.add(Message.fromJson(element)));
      return message;
    } catch (e) {
      return [];
    }
  }

  Future<bool> flagMessages(int id, String contactId) async {
    try {
      Response response = await put(
        Uri.https('app.aggressor.com', 'api/app/inbox/flag/$contactId/$id'),
        headers: <String, String>{
          'apikey': apiKey,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);
      return data["status"] == "success";
    } catch (e) {
      return false;
    }
  }

  Future<bool> unFlagMessages(int id, String contactId) async {
    try {
      Response response = await put(
        Uri.https('app.aggressor.com', 'api/app/inbox/unflag/$contactId/$id'),
        headers: <String, String>{
          'apikey': apiKey,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);
      return data["status"] == "success";
    } catch (e) {
      return false;
    }
  }

  Future<bool> viewMessage(String contactId, int messageId) async {
    try {
      List<Message> message = [];
      Response response = await get(
        Uri.https(
            'app.aggressor.com', 'api/app/inbox/view/$contactId/$messageId'),
        headers: <String, String>{
          'apikey': apiKey,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);
      await Future.forEach(
          data, (element) => message.add(Message.fromJson(element)));
      return message.length > 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMessage(String contactId, int messageId) async {
    try {
      Response response = await delete(
        Uri.https(
            'app.aggressor.com', 'api/app/inbox/delete/$contactId/$messageId'),
        headers: <String, String>{
          'apikey': apiKey,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);
      return data["status"] == "success";
    } catch (e) {
      return false;
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }
}
