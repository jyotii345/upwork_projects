import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/databases/boat_database.dart';
import 'package:aggressor_adventures/databases/certificate_database.dart';
import 'package:aggressor_adventures/databases/charter_database.dart';
import 'package:aggressor_adventures/databases/contact_database.dart';
import 'package:aggressor_adventures/databases/countries_database.dart';
import 'package:aggressor_adventures/databases/files_database.dart';
import 'package:aggressor_adventures/databases/iron_diver_database.dart';
import 'package:aggressor_adventures/databases/notes_database.dart';
import 'package:aggressor_adventures/databases/offline_database.dart';
import 'package:aggressor_adventures/databases/photo_database.dart';
import 'package:aggressor_adventures/databases/profile_database.dart';
import 'package:aggressor_adventures/databases/slider_database.dart';
import 'package:aggressor_adventures/databases/states_database.dart';
import 'package:aggressor_adventures/databases/trip_database.dart';
import 'package:aggressor_adventures/databases/user_database.dart';
import 'package:aggressor_adventures/user_interface_pages/contact_us_page.dart';
import 'package:aggressor_adventures/user_interface_pages/inbox_page.dart';
import 'package:aggressor_adventures/user_interface_pages/photos_page.dart';
import 'package:aggressor_adventures/user_interface_pages/reels_page.dart';
import 'package:aggressor_adventures/user_interface_pages/rewards_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_cubit/user_cubit.dart';
import '../classes/fcm_helper.dart';
import '../model/userModel.dart';
import 'login_page.dart';
import 'files_page.dart';
import 'profile_view_page.dart';
import 'trips_page.dart';
import 'notes_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.tripList}) : super(key: key);

  // final User user;
  final List<Trip>? tripList;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  /*
  instance variables
   */

  UserDatabaseHelper helper = UserDatabaseHelper.instance;
  User? currentUser;
  Widget galleryWidget = Container();
  bool isLoading = true;
  /*
  init state
   */

  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  var pageList = [];

  getCurrentUser() async {
    var userList = await helper.queryUser();
    currentUser = userList[0];
  }

  loadInitialData() async {
    setState(() {
      isLoading = true;
    });
    await getCurrentUser();
    await loadProfileDetails();
    getCountriesList();

    BlocProvider.of<UserCubit>(context).setCurrentUser(currentUser);
    pageList = [
      MyTrips(
        user: currentUser,
      ),
      //trips page
      Rewards(currentUser!),
      // notes page
      Photos(
        currentUser!,
      ),
      // photos page
      // rewards page
      Reels(currentUser!, refreshState),
      // login page
      MyProfile(currentUser!),
      //my profile page
      MyFiles(currentUser!),
      // my files page
      Notes(currentUser!),
      InboxPage(currentUser!),
    ];
    mainPageCallback = refreshState;
    mainPageSignOutCallback = signOutUser;
    homePage = true;

    //fcm
    FCMHelper.initializeFcmSetup(
      context,
      () {
        setState(() {
          currentIndex = 7;
        });
      },
      currentUser!.contactId ?? "",
      currentUser!.userId ?? "",
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<dynamic> loadProfileDetails() async {
    //loads the initial value of the users profile data
    await AggressorApi().getProfileData(currentUser!.userId!);
  }

  void getCountriesList() async {
    //set the initial countries list
    countriesList = await AggressorApi().getCountries();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    homePage = true;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: showVideo ? null : getBottomNavigationBar(),
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   setState(() {
      //     currentIndex = 7;
      //   });
      // },),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pageList[currentIndex],
      // appBar: showVideo ? null : getAppBar(),
      // body: Scaffold(
      //     resizeToAvoidBottomInset: false,
      //     // bottomNavigationBar: showVideo ? null : getBottomNavigationBar(),
      //     body: pageList[currentIndex]),
    );
  }

/*
  Self implemented
   */

  refreshState() {
    setState(() {});
  }

  void signOutUser() async {
    //sings user out and clears databases

    await BoatDatabaseHelper.instance.deleteBoatTable();
    await CertificateDatabaseHelper.instance.deleteCertificateTable();
    await CharterDatabaseHelper.instance.deleteCharterTable();
    await ContactDatabaseHelper.instance.deleteContactTable();
    await CountriesDatabaseHelper.instance.deleteCountriesTable();
    await FileDatabaseHelper.instance.deleteFileTable();
    await IronDiverDatabaseHelper.instance.deleteIronDiverTable();
    await NotesDatabaseHelper.instance.deleteNotesTable();
    await OfflineDatabaseHelper.instance.deleteOfflineTable();
    await PhotoDatabaseHelper.instance.deletePhotoTable();
    await ProfileDatabaseHelper.instance.deleteProfileTable();
    await SlidersDatabaseHelper.instance.deleteSlidersTable();
    await StatesDatabaseHelper.instance.deleteStatesTable();
    await TripDatabaseHelper.instance.deleteTripTable();
    await UserDatabaseHelper.instance.deleteUser(100);
    BlocProvider.of<UserCubit>(context).setCurrentUser(null);

    setState(() {
      navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  Widget getIndexStack() {
    /*
    Returns an indexed Stack widget containing the value of what dart page belongs at which button of the navitgation bar, the extra option is for the login page, will show if the user is not verified
     */

    return IndexedStack(
      children: <Widget>[
        MyTrips(
          user: currentUser,
        ),
        //trips page
        Rewards(currentUser!),
        // notes page
        Photos(
          currentUser!,
        ),
        // photos page
        // rewards page
        Reels(currentUser!, refreshState),
        // login page
        MyProfile(currentUser!),
        //my profile page
        MyFiles(currentUser!),
        // my files page
        Notes(currentUser!),
        // my notes page
      ],
      index: currentIndex,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
