import 'dart:async';
import 'dart:io';
import 'package:aggressor_adventures/classes/trip.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TripDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "tripDatabase.db";

  static final _databaseVersion = 1;

  TripDatabaseHelper._privateConstructor();

  static final TripDatabaseHelper instance =
      TripDatabaseHelper._privateConstructor();
  static Database? _database;


  Future<Database> get database async {
    //get the database object
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    // initialize the database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    //create a new table object in the database
    return db.execute(
      "CREATE TABLE trip(tripDate TEXT,title TEXT,latitude TEXT,longitude TEXT,destination TEXT,reservationDate TEXT,reservationId TEXT, charterId TEXT,total TEXT,discount TEXT,payments TEXT,due TEXT, dueDate TEXT,passengers TEXT,location TEXT,embark TEXT,disembark TEXT,detailDestination TEXT, loginKey TEXT, passengerId TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<void> insertTrip(Trip trip) async {
    //add a trip to the database
    final Database db = await database;

    await db.insert(
      'trip',
      trip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTrip(String reservationId) async {
    // delete a trip in the database
    final db = await database;

    await db.delete(
      'trip',
      where: "reservationId = ?",
      whereArgs: [reservationId],
    );
  }

  Future<void> deleteTripTable() async {
    //delete the entire table of the trip database
    final db = await database;
    await db.delete('trip');
  }

  Future<bool> tripExists(String reservationId) async {
    //check if a trip exists in the database based on the trip id
    final db = await database;
    var result = await db
        .rawQuery('SELECT EXISTS(SELECT 1 FROM trip WHERE reservationId = ?)', [reservationId]);
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<Trip> getTrip(String reservationId) async {
    //get a specific trip from the database by the reservationId
    final db = await database;
    var result = await db
        .rawQuery('SELECT * FROM trip WHERE reservationId = ?', [reservationId]);
    return Trip.TripWithDetails(
      result[0]['tripDate'].toString(),
      result[0]['title'].toString(),
      result[0]['latitude'].toString(),
      result[0]['longitude'].toString(),
      result[0]['destination'].toString(),
      result[0]['reservationDate'].toString(),
      result[0]['reservationId'].toString(),
      result[0]['charterId'].toString(),
      result[0]['total'].toString(),
      result[0]['discount'].toString(),
      result[0]['payments'].toString(),
      result[0]['due'].toString(),
      result[0]['dueDate'].toString(),
      result[0]['passengers'].toString(),
      result[0]['location'].toString(),
      result[0]['embark'].toString(),
      result[0]['disembark'].toString(),
      result[0]['detailDestination'].toString(),
      result[0]['loginKey'].toString(),
      result[0]['passengerId'].toString()
    );

  }

  Future<List<Trip>> queryTrip() async {
    // Get all trip entries from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('trip');

    return List.generate(maps.length, (i) {
      return Trip.TripWithDetails(
        maps[i]['tripDate'],
        maps[i]['title'],
        maps[i]['latitude'],
        maps[i]['longitude'],
        maps[i]['destination'],
        maps[i]['reservationDate'],
        maps[i]['reservationId'],
        maps[i]['charterId'],
        maps[i]['total'],
        maps[i]['discount'],
        maps[i]['payments'],
        maps[i]['due'],
        maps[i]['dueDate'],
        maps[i]['passengers'],
        maps[i]['location'],
        maps[i]['embark'],
        maps[i]['disembark'],
        maps[i]['detailDestination'],
        maps[i]['loginKey'],
        maps[i]['passengerId'],
      );
    });
  }
}
