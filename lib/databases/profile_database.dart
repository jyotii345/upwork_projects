import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ProfileDatabaseHelper {
  //a helper class to drive the database

  static final _databaseName = "profileDatabase.db";

  static final _databaseVersion = 1;

  ProfileDatabaseHelper._privateConstructor();

  static final ProfileDatabaseHelper instance =
      ProfileDatabaseHelper._privateConstructor();
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
      "CREATE TABLE profile(id INTEGER PRIMARY KEY,userId TEXT, first TEXT, last TEXT, email TEXT, address1 TEXT, address2 TEXT, city TEXT, state TEXT, province TEXT, country TEXT, time_zone TEXT, zip TEXT, username TEXT, password TEXT, homePhone TEXT, workPhone TEXT, mobilePhone TEXT)",
    );
  }

  /*
   Database helper methods
   */

  Future<int> insertProfile(
    String? userId,
    String? first,
    String? last,
    String? email,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? province,
    String? country,
    String? timeZone,
    String? zip,
    String? username,
    String? password,
    String? homePhone,
    String? workPhone,
    String? mobilePhone,
  ) async {
    //add a profile to the database
    final Database db = await database;

    int id = await db.insert(
      'profile',
      {
        'userId': userId,
        'first': first,
        'last': last,
        'email': email,
        'address1': address1,
        'address2': address2,
        // 'address2': address2,
        'state': state,
        'province': province,
        'country': country,
        'time_zone':timeZone,
        'zip': zip,
        'username': username,
        'password': password,
        'homePhone': homePhone,
        'workPhone': workPhone,
        'mobilePhone': mobilePhone,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteProfile(int id) async {
    // delete a profile in the database
    final db = await database;

    await db.delete(
      'profile',
      where: "userId = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteProfileTable() async {
    //delete the entire profile table in the database
    final db = await database;
    await db.delete('profile');
  }

  Future<bool> profileExists(String userId) async {
    //check if a profile exists in the database by the profile path and name
    final db = await database;
    var result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM profile WHERE userId = ?)', [userId]);
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<Map<String, dynamic>>> queryProfile() async {
    // Get a profile from the database
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('profile');

    return List.generate(maps.length, (i) {
      return {
        'userId': maps[i]['userId'],
        'first': maps[i]['first'],
        'last': maps[i]['last'],
        'email': maps[i]['email'],
        'address1': maps[i]['address1'],
        'address2': maps[i]['address2'],
        'state': maps[i]['state'],
        'province': maps[i]['province'],
        'country': maps[i]['country'],
        'time_zone': maps[i]['time_zone'],
        'zip': maps[i]['zip'],
        'username': maps[i]['username'],
        'password': maps[i]['password'],
        'homePhone': maps[i]['homePhone'],
        'workPhone': maps[i]['workPhone'],
        'mobilePhone': maps[i]['mobilePhone'],
      };
    });
  }
}
